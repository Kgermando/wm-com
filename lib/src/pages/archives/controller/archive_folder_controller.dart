import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/archives/archive_folder_api.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class ArchiveFolderController extends GetxController
    with StateMixin<List<ArchiveFolderModel>> {
  final ArchiveFolderApi archiveFolderApi = ArchiveFolderApi();
  final ProfilController profilController = Get.find();

  List<ArchiveFolderModel> archiveFolderList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final TextEditingController folderNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    folderNameController.dispose();
    super.dispose();
  }

  @override
  void refresh() {
    getList();
    super.refresh();
  }

  void clear() {
    folderNameController.clear();
  }

  void getList() async {
    await archiveFolderApi.getAllData().then((response) {
      archiveFolderList.clear();
      archiveFolderList.addAll(response);
      change(archiveFolderList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await archiveFolderApi.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await archiveFolderApi.deleteData(id).then((value) {
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
      final archiveModel = ArchiveFolderModel(
          departement: profilController.user.departement,
          folderName: folderNameController.text,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business());
      await archiveFolderApi.insertData(archiveModel).then((value) {
        clear();
        getList();
        Get.snackbar("Soumission effectuée avec succès!",
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

  // Pas de modification ici par ce que les fichiers inclus ne trouveront pas leur folder
  // void updateData(ArchiveFolderModel data) async {
  //   try {
  //     _isLoading.value = true;
  //     final archiveModel = ArchiveFolderModel(
  //         departement: profilController.user.departement,
  //         folderName: folderNameController.text,
  //         signature: profilController.user.matricule,
  //         created: DateTime.now());
  //     await archiveFolderApi.updateData(transRest).then((value) {
  //       archiveFolderList.clear();
  //       getList();
  //       Get.snackbar("Soumission effectuée avec succès!",
  //           "Le document a bien été sauvegadé",
  //           backgroundColor: Colors.green,
  //           icon: const Icon(Icons.check),
  //           snackPosition: SnackPosition.TOP);
  //       _isLoading.value = false;
  //     });
  //   } catch (e) {
  //     _isLoading.value = false;
  // Get.snackbar("Erreur de soumission", "$e",
  //         backgroundColor: Colors.red,
  //         icon: const Icon(Icons.check),
  //         snackPosition: SnackPosition.TOP);
  //   }
  // }
}
