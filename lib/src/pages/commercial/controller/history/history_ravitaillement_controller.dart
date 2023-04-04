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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await historyRavitaillementApi.getAllData();
      var dataList =
          historyRavitaillementList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          historyRavitaillementList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = HistoryRavitaillementModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              margeBen: element.margeBen,
              tva: element.tva,
              qtyRavitailler: element.qtyRavitailler,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            ); 
            await historyRavitaillementApi
                .insertData(dataItem)
                .then((value) async {
              HistoryRavitaillementModel dataModel =
                  dataList.where((p0) => p0.idProduct == value.idProduct).first;
              final dataItem = HistoryRavitaillementModel(
                id: dataModel.id,
                idProduct: dataModel.idProduct,
                quantity: dataModel.quantity,
                quantityAchat: dataModel.quantityAchat,
                priceAchatUnit: dataModel.priceAchatUnit,
                prixVenteUnit: dataModel.prixVenteUnit,
                unite: dataModel.unite,
                margeBen: dataModel.margeBen,
                tva: dataModel.tva,
                qtyRavitailler: dataModel.qtyRavitailler,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await historyRavitaillementStore.updateData(dataItem).then((value) {
                historyRavitaillementList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up historyRavitaillementList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (historyRavitaillementList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = HistoryRavitaillementModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              margeBen: element.margeBen,
              tva: element.tva,
              qtyRavitailler: element.qtyRavitailler,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await historyRavitaillementStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download historyRavitaillementList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.idProduct == element.idProduct) {
                  final dataItem = HistoryRavitaillementModel(
                    id: e.id,
                    idProduct: element.idProduct,
                    quantity: element.quantity,
                    quantityAchat: element.quantityAchat,
                    priceAchatUnit: element.priceAchatUnit,
                    prixVenteUnit: element.prixVenteUnit,
                    unite: element.unite,
                    margeBen: element.margeBen,
                    tva: element.tva,
                    qtyRavitailler: element.qtyRavitailler,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await historyRavitaillementApi
                      .updateData(dataItem)
                      .then((value) async {
                    HistoryRavitaillementModel dataModel = dataUpdateList
                        .where((p0) => p0.idProduct == value.idProduct)
                        .first;
                    final dataItem = HistoryRavitaillementModel(
                      id: dataModel.id,
                      idProduct: dataModel.idProduct,
                      quantity: dataModel.quantity,
                      quantityAchat: dataModel.quantityAchat,
                      priceAchatUnit: dataModel.priceAchatUnit,
                      prixVenteUnit: dataModel.prixVenteUnit,
                      unite: dataModel.unite,
                      margeBen: dataModel.margeBen,
                      tva: dataModel.tva,
                      qtyRavitailler: dataModel.qtyRavitailler,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await historyRavitaillementStore.updateData(dataItem).then((value) {
                      historyRavitaillementList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up historyRavitaillementList ok');
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
