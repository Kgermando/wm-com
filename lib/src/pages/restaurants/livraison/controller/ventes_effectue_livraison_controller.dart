import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/livraison/vente_effectuee_livraison_api.dart';
import 'package:wm_com/src/global/store/livraison/vente_effectue_livraison_store.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';

class VenteEffectueLivraisonController extends GetxController
    with StateMixin<List<VenteRestaurantModel>> {
  final VenteEffectueLivraisonStore venteEffectuelivraisonStore =
      VenteEffectueLivraisonStore();
  final VenteEffectueLivraisonApi venteEffectuelivraisonApi =
      VenteEffectueLivraisonApi();

  var venteEffectueList = <VenteRestaurantModel>[].obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    getList();
    super.onInit();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  void getList() async {
    await venteEffectuelivraisonStore.getAllData().then((response) {
      venteEffectueList.clear();
      venteEffectueList.addAll(response);
      change(venteEffectueList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await venteEffectuelivraisonStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await venteEffectuelivraisonStore.deleteData(id).then((value) {
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
      var dataCloudList = await venteEffectuelivraisonApi.getAllData();
      var dataList = venteEffectueList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          venteEffectueList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = VenteRestaurantModel(
              identifiant: element.identifiant,
              table: element.table,
              priceTotalCart: element.priceTotalCart,
              qty: element.qty,
              price: element.price,
              unite: element.unite,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await venteEffectuelivraisonApi
                .insertData(dataItem)
                .then((value) async {
              VenteRestaurantModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .last;
              final dataItem = VenteRestaurantModel(
                id: dataModel.id,
                identifiant: dataModel.identifiant,
                table: dataModel.table,
                priceTotalCart: dataModel.priceTotalCart,
                qty: dataModel.qty,
                price: dataModel.price,
                unite: dataModel.unite,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await venteEffectuelivraisonStore
                  .updateData(dataItem)
                  .then((value) {
                venteEffectueList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up venteEffectueList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (venteEffectueList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = VenteRestaurantModel(
              identifiant: element.identifiant,
              table: element.table,
              priceTotalCart: element.priceTotalCart,
              qty: element.qty,
              price: element.price,
              unite: element.unite,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await venteEffectuelivraisonStore
                .insertData(dataItem)
                .then((value) {
              if (kDebugMode) {
                print("download venteEffectueList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.created.millisecondsSinceEpoch ==
                    element.created.millisecondsSinceEpoch) {
                  final dataItem = VenteRestaurantModel(
                    id: e.id,
                    identifiant: element.identifiant,
                    table: element.table,
                    priceTotalCart: element.priceTotalCart,
                    qty: element.qty,
                    price: element.price,
                    unite: element.unite,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await venteEffectuelivraisonApi
                      .updateData(dataItem)
                      .then((value) async {
                    VenteRestaurantModel dataModel = dataList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .last;
                    final dataItem = VenteRestaurantModel(
                      id: dataModel.id,
                      identifiant: dataModel.identifiant,
                      table: dataModel.table,
                      priceTotalCart: dataModel.priceTotalCart,
                      qty: dataModel.qty,
                      price: dataModel.price,
                      unite: dataModel.unite,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await venteEffectuelivraisonStore
                        .updateData(dataItem)
                        .then((value) {
                      venteEffectueList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up venteEffectueList ok');
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
