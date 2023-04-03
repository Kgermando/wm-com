import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/livraison/facture_livraison_api.dart';
import 'package:wm_com/src/global/store/livraison/facture_livraison_store.dart';
import 'package:wm_com/src/models/restaurant/facture_restaurant_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class FactureLivraisonController extends GetxController
    with StateMixin<List<FactureRestaurantModel>> {
  final FactureLivraisonStore facturelivraisonStore = FactureLivraisonStore();
  final FactureLivraisonApi facturelivraisonApi = FactureLivraisonApi();
  final ProfilController profilController = Get.find();

  var factureList = <FactureRestaurantModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    await facturelivraisonStore.getAllData().then((response) {
      factureList.clear();
      factureList.addAll(response);
      factureList.refresh();
      change(factureList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await facturelivraisonStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await facturelivraisonStore.deleteData(id).then((value) {
        factureList.clear();
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
      var dataCloudList = await facturelivraisonApi.getAllData();
      var dataList = factureList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          factureList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = FactureRestaurantModel(
              cart: element.cart,
              client: element.client,
              nomClient: element.nomClient,
              telephone: element.telephone,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await facturelivraisonApi.insertData(dataItem).then((value) async {
              FactureRestaurantModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .last;
              final dataItem = FactureRestaurantModel(
                id: dataModel.id,
                cart: element.cart,
                client: element.client,
                nomClient: element.nomClient,
                telephone: element.telephone,
                succursale: element.succursale,
                signature: element.signature,
                created: element.created,
                business: element.business,
                sync: "sync",
                async: element.async,
              );
              await facturelivraisonStore.updateData(dataItem).then((value) {
                factureList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up factureList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (factureList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = FactureRestaurantModel(
              cart: element.cart,
              client: element.client,
              nomClient: element.nomClient,
              telephone: element.telephone,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await facturelivraisonStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download factureList ok");
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
                  final dataItem = FactureRestaurantModel(
                    id: e.id,
                    cart: element.cart,
                    client: element.client,
                    nomClient: element.nomClient,
                    telephone: element.telephone,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await facturelivraisonApi
                      .updateData(dataItem)
                      .then((value) async {
                    FactureRestaurantModel dataModel = dataList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .last;
                    final dataItem = FactureRestaurantModel(
                      id: dataModel.id,
                      cart: element.cart,
                      client: element.client,
                      nomClient: element.nomClient,
                      telephone: element.telephone,
                      succursale: element.succursale,
                      signature: element.signature,
                      created: element.created,
                      business: element.business,
                      sync: "sync",
                      async: element.async,
                    );
                    await facturelivraisonStore
                        .updateData(dataItem)
                        .then((value) {
                      factureList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up factureList ok');
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
