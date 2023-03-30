import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/gain_store.dart';
import 'package:wm_com/src/models/commercial/gain_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class GainCartController extends GetxController
    with StateMixin<List<GainModel>> {
  final GainStore gainStore = GainStore();
  final ProfilController profilController = Get.find();

  var gainList = <GainModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    await gainStore.getAllData().then((response) {
      gainList.clear();
      gainList.addAll(response);
      gainList.refresh();
      change(gainList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await gainStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await gainStore.deleteData(id).then((value) {
        gainList.clear();
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
}
