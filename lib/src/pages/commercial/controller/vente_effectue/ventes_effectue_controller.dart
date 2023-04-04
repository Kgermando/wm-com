import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/vente_cart_api.dart';
import 'package:wm_com/src/global/store/commercial/vente_effectue_store.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';

class VenteEffectueController extends GetxController
    with StateMixin<List<VenteCartModel>> {
  final VenteEffectueStore venteEffectueStore = VenteEffectueStore();
  final VenteCartApi venteCartApi = VenteCartApi();

  var venteCartList = <VenteCartModel>[].obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    getList();
    super.onInit();
  }

  void getList() async {
    await venteEffectueStore.getAllData().then((response) {
      venteCartList.clear();
      venteCartList.addAll(response);
      venteCartList.refresh();
      change(venteCartList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await venteEffectueStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await venteEffectueStore.deleteData(id).then((value) {
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
      var dataCloudList = await venteCartApi.getAllData();
      var dataList = venteCartList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          venteCartList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = VenteCartModel(
              idProductCart: element.idProductCart,
              quantityCart: element.quantityCart,
              priceTotalCart: element.priceTotalCart,
              unite: element.unite,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              createdAt: element.createdAt,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await venteCartApi.insertData(dataItem).then((value) async {
              VenteCartModel dataModel =
                  dataList.where((p0) => p0.idProductCart == value.idProductCart).first;
              final dataItem = VenteCartModel(
                id: dataModel.id,
                idProductCart: dataModel.idProductCart,
                quantityCart: dataModel.quantityCart,
                priceTotalCart: dataModel.priceTotalCart,
                unite: dataModel.unite,
                tva: dataModel.tva,
                remise: dataModel.remise,
                qtyRemise: dataModel.qtyRemise,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                createdAt: dataModel.createdAt,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              ); 
              await venteEffectueStore.updateData(dataItem).then((value) {
                venteCartList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up venteCartList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (venteCartList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = VenteCartModel( 
              idProductCart: element.idProductCart,
              quantityCart: element.quantityCart,
              priceTotalCart: element.priceTotalCart,
              unite: element.unite,
              tva: element.tva,
              remise: element.remise,
              qtyRemise: element.qtyRemise,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              createdAt: element.createdAt,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await venteEffectueStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download venteCartList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.idProductCart == element.idProductCart) {
                  final dataItem = VenteCartModel(
                    id: e.id,
                    idProductCart: e.idProductCart,
                    quantityCart: element.quantityCart,
                    priceTotalCart: element.priceTotalCart,
                    unite: element.unite,
                    tva: element.tva,
                    remise: element.remise,
                    qtyRemise: element.qtyRemise,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    createdAt: element.createdAt,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await venteCartApi.updateData(dataItem).then((value) async {
                    VenteCartModel dataModel =
                        dataUpdateList
                        .where((p0) => p0.idProductCart == value.idProductCart).first;
                    final dataItem = VenteCartModel(
                      id: dataModel.id,
                      idProductCart: dataModel.idProductCart,
                      quantityCart: dataModel.quantityCart,
                      priceTotalCart: dataModel.priceTotalCart,
                      unite: dataModel.unite,
                      tva: dataModel.tva,
                      remise: dataModel.remise,
                      qtyRemise: dataModel.qtyRemise,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      createdAt: dataModel.createdAt,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await venteEffectueStore.updateData(dataItem).then((value) {
                      venteCartList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up venteCartList ok');
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
