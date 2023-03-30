import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/global/api/settings/monnaie_api.dart';
import 'package:wm_com/src/models/settings/monnaie_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class MonnaieStorage extends GetxController {
  final MonnaieApi monnaieApi = MonnaieApi();
  final ProfilController profilController = Get.find();

  List<MonnaieModel> monnaieList = [];
  List<MonnaieModel> monnaieActiveList = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _monney = '\$'.obs;
  String get monney => _monney.value;

  TextEditingController symbolController = TextEditingController();
  TextEditingController monnaieEnLettreController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    symbolController.dispose();
    monnaieEnLettreController.dispose();
    super.dispose();
  }

  void clear() {
    symbolController.clear();
    monnaieEnLettreController.clear();
  }

  void getList() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        await monnaieApi.getAllData().then((response) {
          monnaieList.clear();
          monnaieActiveList.clear();
          monnaieList.addAll(response);
          monnaieActiveList.addAll(
              response.where((element) => element.isActive == 'true').toList());
          if (monnaieActiveList.isNotEmpty) {
            _monney.value = monnaieActiveList.first.monnaie;
          }
        });
      }
    }

    if (GetPlatform.isWeb) {
      await monnaieApi.getAllData().then((response) {
        monnaieList.clear();
        monnaieActiveList.clear();
        monnaieList.addAll(response);
        monnaieActiveList.addAll(
            response.where((element) => element.isActive == 'true').toList());
        if (monnaieActiveList.isNotEmpty) {
          _monney.value = monnaieActiveList.first.monnaie;
        }
      });
    }
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await monnaieApi.deleteData(id).then((value) {
        getList();
        // Get.back();
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
      final dataItem = MonnaieModel(
          monnaie: symbolController.text.toUpperCase(),
          monnaieEnlettre: monnaieEnLettreController.text,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          isActive: 'false',
          business: InfoSystem().business());
      await monnaieApi.insertData(dataItem).then((value) {
        // clear();
        getList();
        Get.toNamed(SettingsRoutes.monnaiePage);
        Get.snackbar("Monnaie effectuée avec succès!",
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

  void updateData(MonnaieModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = MonnaieModel(
          id: data.id,
          monnaie: symbolController.text.toUpperCase(),
          monnaieEnlettre: monnaieEnLettreController.text,
          signature: profilController.user.matricule,
          created: data.created,
          isActive: data.isActive,
          business: data.business);
      await monnaieApi.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.toNamed(SettingsRoutes.monnaiePage);
        Get.snackbar("Modification effectuée avec succès!",
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

  void activeMonnaie(MonnaieModel data, String bool) async {
    try {
      _isLoading.value = true;
      final dataItem = MonnaieModel(
          id: data.id,
          monnaie: data.monnaie,
          monnaieEnlettre: data.monnaieEnlettre,
          signature: data.signature,
          created: data.created,
          isActive: bool,
          business: data.business);
      await monnaieApi.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.toNamed(SettingsRoutes.monnaiePage);
        Get.snackbar("Modification effectuée avec succès!",
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

  // setData(value) async {
  //   box.write(_keyMonnaie, json.encode(value));
  // }

  // removeData() async {
  //   await box.remove(_keyMonnaie);
  // }
}
