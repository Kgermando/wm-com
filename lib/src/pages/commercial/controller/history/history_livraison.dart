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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await livraisonHistoryApi.getAllData();
      var dataList =
          livraisonHistoryList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          livraisonHistoryList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = LivraisonHistoryModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              margeBen: element.margeBen,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              margeBenRemise: element.margeBenRemise,
              qtyLivre: element.qtyLivre,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            ); 
            await livraisonHistoryApi.insertData(dataItem).then((value) async {
              LivraisonHistoryModel dataModel =
                  dataList.where((p0) => p0.idProduct == value.idProduct).first;
              final dataItem = LivraisonHistoryModel(
                id: dataModel.id,
                idProduct: dataModel.idProduct,
                quantity: dataModel.quantity,
                quantityAchat: dataModel.quantityAchat,
                priceAchatUnit: dataModel.priceAchatUnit,
                prixVenteUnit: dataModel.prixVenteUnit,
                unite: dataModel.unite,
                margeBen: dataModel.margeBen,
                tva: dataModel.tva,
                remise: dataModel.remise,
                qtyRemise: dataModel.qtyRemise,
                margeBenRemise: dataModel.margeBenRemise,
                qtyLivre: dataModel.qtyLivre,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await historyLivraisonStore.updateData(dataItem).then((value) {
                livraisonHistoryList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up livraisonHistoryList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (livraisonHistoryList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = LivraisonHistoryModel(
              idProduct: element.idProduct,
              quantity: element.quantity,
              quantityAchat: element.quantityAchat,
              priceAchatUnit: element.priceAchatUnit,
              prixVenteUnit: element.prixVenteUnit,
              unite: element.unite,
              margeBen: element.margeBen,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              margeBenRemise: element.margeBenRemise,
              qtyLivre: element.qtyLivre,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            ); 
            await historyLivraisonStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download livraisonHistoryList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.idProduct == element.idProduct) {
                  final dataItem = LivraisonHistoryModel(
                    id: e.id,
                    idProduct: element.idProduct,
                    quantity: element.quantity,
                    quantityAchat: element.quantityAchat,
                    priceAchatUnit: element.priceAchatUnit,
                    prixVenteUnit: element.prixVenteUnit,
                    unite: element.unite,
                    margeBen: element.margeBen,
                    tva: element.tva,
                    remise: element.remise,
                    qtyRemise: element.qtyRemise,
                    margeBenRemise: element.margeBenRemise,
                    qtyLivre: element.qtyLivre,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  ); 
                  await livraisonHistoryApi
                      .updateData(dataItem)
                      .then((value) async {
                    LivraisonHistoryModel dataModel = dataUpdateList
                        .where((p0) => p0.idProduct == value.idProduct)
                        .first;
                    final dataItem = LivraisonHistoryModel(
                      id: dataModel.id,
                      idProduct: dataModel.idProduct,
                      quantity: dataModel.quantity,
                      quantityAchat: dataModel.quantityAchat,
                      priceAchatUnit: dataModel.priceAchatUnit,
                      prixVenteUnit: dataModel.prixVenteUnit,
                      unite: dataModel.unite,
                      margeBen: dataModel.margeBen,
                      tva: dataModel.tva,
                      remise: dataModel.remise,
                      qtyRemise: dataModel.qtyRemise,
                      margeBenRemise: dataModel.margeBenRemise,
                      qtyLivre: dataModel.qtyLivre,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    ); 
                    await historyLivraisonStore
                        .updateData(dataItem)
                        .then((value) {
                      livraisonHistoryList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up livraisonHistoryList ok');
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
