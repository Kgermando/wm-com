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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await userApi.getAllData();
      var dataList = usersList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          usersList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = UserModel(
              nom: element.nom,
              prenom: element.prenom,
              email: element.email,
              telephone: element.telephone,
              matricule: element.matricule,
              departement: element.departement,
              servicesAffectation: element.servicesAffectation,
              fonctionOccupe: element.fonctionOccupe,
              role: element.role,
              isOnline: element.isOnline,
              createdAt: element.createdAt,
              passwordHash: element.passwordHash,
              succursale: element.succursale,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await userApi.insertData(dataItem).then((value) async {
              UserModel dataModel = dataList
                  .where((p0) => p0.matricule == value.matricule)
                  .last;
              final dataItem = UserModel(
                id: dataModel.id,
                nom: dataModel.nom,
                prenom: dataModel.prenom,
                email: dataModel.email,
                telephone: dataModel.telephone,
                matricule: dataModel.matricule,
                departement: dataModel.departement,
                servicesAffectation: dataModel.servicesAffectation,
                fonctionOccupe: dataModel.fonctionOccupe,
                role: dataModel.role,
                isOnline: dataModel.isOnline,
                createdAt: dataModel.createdAt,
                passwordHash: dataModel.passwordHash,
                succursale: dataModel.succursale,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await usersStore.updateData(dataItem).then((value) {
                usersList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up usersList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (usersList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = UserModel(
              nom: element.nom,
              prenom: element.prenom,
              email: element.email,
              telephone: element.telephone,
              matricule: element.matricule,
              departement: element.departement,
              servicesAffectation: element.servicesAffectation,
              fonctionOccupe: element.fonctionOccupe,
              role: element.role,
              isOnline: element.isOnline,
              createdAt: element.createdAt,
              passwordHash: element.passwordHash,
              succursale: element.succursale,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await usersStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download usersList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.matricule == element.matricule) {
                  final dataItem = UserModel(
                    id: e.id,
                    nom: element.nom,
                    prenom: element.prenom,
                    email: element.email,
                    telephone: element.telephone,
                    matricule: element.matricule,
                    departement: element.departement,
                    servicesAffectation: element.servicesAffectation,
                    fonctionOccupe: element.fonctionOccupe,
                    role: element.role,
                    isOnline: element.isOnline,
                    createdAt: element.createdAt,
                    passwordHash: element.passwordHash,
                    succursale: element.succursale,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await userApi.updateData(dataItem).then((value) async {
                     UserModel dataModel = dataList
                        .where((p0) => p0.matricule == value.matricule)
                        .last;
                    final dataItem = UserModel(
                      id: dataModel.id,
                      nom: dataModel.nom,
                      prenom: dataModel.prenom,
                      email: dataModel.email,
                      telephone: dataModel.telephone,
                      matricule: dataModel.matricule,
                      departement: dataModel.departement,
                      servicesAffectation: dataModel.servicesAffectation,
                      fonctionOccupe: dataModel.fonctionOccupe,
                      role: dataModel.role,
                      isOnline: dataModel.isOnline,
                      createdAt: dataModel.createdAt,
                      passwordHash: dataModel.passwordHash,
                      succursale: dataModel.succursale,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await usersStore.updateData(dataItem).then((value) {
                      usersList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up usersList ok');
                      }
                    });
                  });
                }
              }
            }
          }).toList();
        }

        _isLoading.value = false;
      }
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
