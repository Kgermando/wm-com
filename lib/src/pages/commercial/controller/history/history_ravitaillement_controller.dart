import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/history_rabitaillement_api.dart';
import 'package:wm_com/src/global/store/commercial/history_ravitaillement_store.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class HistoryRavitaillementController extends GetxController
    with StateMixin<List<HistoryRavitaillementModel>> {
  final HistoryRavitaillementStore historyRavitaillementStore =
      HistoryRavitaillementStore();
  final HistoryRavitaillementApi historyRavitaillementApi =
      HistoryRavitaillementApi();
  final ProfilController profilController = Get.find();

  var historyRavitaillementList = <HistoryRavitaillementModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

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

  void getList() async {
    await historyRavitaillementStore.getAllData().then((response) {
      historyRavitaillementList.clear();
      historyRavitaillementList.addAll(response);
      historyRavitaillementList.refresh();
      change(historyRavitaillementList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await historyRavitaillementStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await historyRavitaillementStore.deleteData(id).then((value) {
        historyRavitaillementList.clear();
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
    var dataCloudList = await historyRavitaillementApi.getAllData();
        dataCloudList.map((e) async {
          if (!historyRavitaillementList.contains(e)) {
            if (dataCloudList.isNotEmpty) {
              final dataItem = HistoryRavitaillementModel(
                idProduct: e.idProduct,
                quantity: e.quantity,
                quantityAchat: e.quantityAchat,
                priceAchatUnit: e.priceAchatUnit,
                prixVenteUnit: e.prixVenteUnit,
                unite: e.unite,
                margeBen: e.margeBen,
                tva: e.tva,
                qtyRavitailler: e.qtyRavitailler,
                succursale: e.succursale,
                signature: e.signature,
                created: e.created,
                business: e.business,
                sync: e.sync,
                async: 'saved',
              ); 
              await historyRavitaillementStore.insertData(dataItem).then((value) {
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
