import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/history_livraison_store.dart';
import 'package:wm_com/src/models/commercial/livraiason_history_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class HistoryLivraisonController extends GetxController
    with StateMixin<List<LivraisonHistoryModel>> {
  final HistoryLivraisonStore historyLivraisonStore =
      HistoryLivraisonStore();
  final ProfilController profilController = Get.find();

  var livraisonHistoryList = <LivraisonHistoryModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

    @override
  void refresh() {
    getList();
    super.refresh();
  }

  void getList() async {
    await historyLivraisonStore.getAllData().then((response) {
      livraisonHistoryList.clear();
      livraisonHistoryList.addAll(response);
      livraisonHistoryList.refresh();
      change(livraisonHistoryList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await historyLivraisonStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await historyLivraisonStore.deleteData(id).then((value) {
        livraisonHistoryList.clear();
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
