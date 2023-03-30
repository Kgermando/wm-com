import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/home/service_home_store.dart';
import 'package:wm_com/src/models/home/service_home_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class HomeController extends GetxController
    with StateMixin<List<ServiceHomeModel>> {
  final ServiceHomeStore serviceHomeStore = ServiceHomeStore();
  final ProfilController profilController = Get.put(ProfilController());

  var serviceHomeList = <ServiceHomeModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController nameController = TextEditingController();
  String? iconPlace;
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void clear() {
    nameController.clear();
  }

  void getList() async {
    serviceHomeStore.getAllData().then((response) {
      serviceHomeList.clear();
      serviceHomeList.addAll(response);
      serviceHomeList.refresh();

      change(response, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await serviceHomeStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await serviceHomeStore.deleteData(id).then((value) {
        serviceHomeList.clear();
        getList();
        Get.back();
        Get.snackbar("Supprimé avec succès!", "Cet élément a bien été supprimé",
            backgroundColor: Colors.green,
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

  void submit() async {
    try {
      _isLoading.value = true;
      final dataItem = ServiceHomeModel(
        name: nameController.text,
        categorie: 'Restauration',
        iconPlace: iconPlace.toString().toLowerCase(),
        signature: profilController.user.matricule,
        created: DateTime.now(),
        business: InfoSystem().business(),
      );
      await serviceHomeStore.insertData(dataItem).then((value) {
        clear();
        serviceHomeList.clear();
        getList();
        // Get.back();
        Get.snackbar("Archivage effectuée avec succès!",
            "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
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

  void updateData(ServiceHomeModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = ServiceHomeModel(
        name: (nameController.text == '') ? data.name : nameController.text,
        categorie: data.categorie,
        iconPlace: iconPlace.toString().toLowerCase(),
        signature: profilController.user.matricule,
        created: data.created,
        business: data.business,
      );
      await serviceHomeStore.updateData(dataItem).then((value) {
        clear();
        serviceHomeList.clear();
        getList();
        // Get.back();
        Get.snackbar("Modification de l'Archive effectuée avec succès!",
            "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
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

  // deleteDataAll() async {
  //   _isLoading.value = true;
  //   final data = await serviceHomeStore.deleteDataAll();
  //   _isLoading.value = false;
  //   return data;
  // }
}
