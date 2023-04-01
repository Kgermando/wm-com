import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/user/user_api.dart';
import 'package:wm_com/src/global/store/rh/users_store.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';

class UsersController extends GetxController with StateMixin<List<UserModel>> {
  final UsersStore usersStore = UsersStore();
  final UserApi userApi = UserApi();

  var usersList = <UserModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String? succursale;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  void clear() {
    succursale = null;
  }

  void getList() async {
    await usersStore.getAllData().then((response) {
      usersList.clear();
      usersList.addAll(response);
      usersList.refresh();
      change(usersList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await usersStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  // Delete user login accès
  void deleteUser(AgentModel personne) async {
    int? userId = usersList
        .where((element) =>
            element.matricule == personne.matricule &&
            element.prenom == personne.prenom &&
            element.nom == personne.nom)
        .map((e) => e.id)
        .first;
    deleteData(userId!);
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await usersStore.deleteData(id).then((value) {
        usersList.clear();
        getList();
        Get.back();
        Get.snackbar("Suppression de l'accès avec succès!",
            "Cet élément a bien été supprimé",
            backgroundColor: Colors.purple,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void createUser(AgentModel personne) async {
    try {
      final userModel = UserModel(
          photo: '-',
          nom: personne.nom,
          prenom: personne.prenom,
          email: personne.email,
          telephone: personne.telephone,
          matricule: personne.matricule,
          departement: personne.departement,
          servicesAffectation: personne.servicesAffectation,
          fonctionOccupe: personne.fonctionOccupe,
          role: personne.role,
          isOnline: 'false',
          createdAt: DateTime.now(),
          passwordHash: '12345678',
          succursale: '-',
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await usersStore.insertData(userModel).then((value) {
        usersList.clear();
        getList();
        Get.back();
        Get.snackbar(
            "L'activation a réussie", "${personne.prenom} activé avec succès!",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void succursaleUser(UserModel user) async {
    try {
      final userModel = UserModel(
          id: user.id,
          nom: user.nom,
          prenom: user.prenom,
          email: user.email,
          telephone: user.telephone,
          matricule: user.matricule,
          departement: user.departement,
          servicesAffectation: user.servicesAffectation,
          fonctionOccupe: user.fonctionOccupe,
          role: user.role,
          isOnline: user.isOnline,
          createdAt: user.createdAt,
          passwordHash: user.passwordHash,
          succursale: succursale.toString(),
          business: user.business,
          sync: "update",
          async: "new");
      await usersStore.updateData(userModel).then((value) {
        clear();
        usersList.clear();
        getList();
        Get.back();
        Get.snackbar(
            "Succursale ajoutée avec succès!", "Le document a bien été soumis",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void syncDataDown() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await userApi.getAllData();
      dataCloudList.map((e) async {
        if (!usersList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = UserModel(
              nom: e.nom,
              prenom: e.prenom,
              email: e.email,
              telephone: e.telephone,
              matricule: e.matricule,
              departement: e.departement,
              servicesAffectation: e.servicesAffectation,
              fonctionOccupe: e.fonctionOccupe,
              role: e.role,
              isOnline: e.isOnline,
              createdAt: e.createdAt,
              passwordHash: e.passwordHash,
              succursale: e.succursale,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            ); 
            await usersStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down user ok');
              }
            });
          }
        }
      }).toList();
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
