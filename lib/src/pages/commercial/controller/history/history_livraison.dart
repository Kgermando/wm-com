import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/livraison_history_api.dart';
import 'package:wm_com/src/global/store/commercial/history_livraison_store.dart';
import 'package:wm_com/src/models/commercial/livraiason_history_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class HistoryLivraisonController extends GetxController
    with StateMixin<List<LivraisonHistoryModel>> {
  final HistoryLivraisonStore historyLivraisonStore = HistoryLivraisonStore();
  final LivraisonHistoryApi livraisonHistoryApi = LivraisonHistoryApi();
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

  void syncDataDown() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await livraisonHistoryApi.getAllData();
    dataCloudList.map((e) async {
      if (!livraisonHistoryList.contains(e)) {
        if (dataCloudList.isNotEmpty) {
          final dataItem = LivraisonHistoryModel(
            idProduct: e.idProduct,
            quantity: e.quantity,
            quantityAchat: e.quantityAchat,
            priceAchatUnit: e.priceAchatUnit,
            prixVenteUnit: e.prixVenteUnit,
            unite: e.unite,
            margeBen: e.margeBen,
            tva: e.tva,
            remise: e.remise,
            qtyRemise: e.qtyRemise,
            margeBenRemise: e.margeBenRemise,
            qtyLivre: e.qtyLivre,
            succursale: e.succursale,
            signature: e.signature,
            created: e.created, 
            business: e.business,
            sync: e.sync,
            async: 'saved',
          ); 
          await historyLivraisonStore.insertData(dataItem).then((value) {
            getList();
            if (kDebugMode) {
              print('Sync Down historyLivraison ok');
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
