import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/livraison/creance_livraison_api.dart';
import 'package:wm_com/src/global/store/livraison/creance_livraison_store.dart';
import 'package:wm_com/src/global/store/livraison/facture_livraison_store.dart';
import 'package:wm_com/src/models/restaurant/creance_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/facture_restaurant_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class CreanceLivraisonController extends GetxController
    with StateMixin<List<CreanceRestaurantModel>> {
  final CreanceLivraisonStore creancelivraisonStore = CreanceLivraisonStore();
  final CreanceLivraisonApi creancelivraisonApi = CreanceLivraisonApi();
  final FactureLivraisonStore factureRestaurantStore = FactureLivraisonStore();
  final ProfilController profilController = Get.find();

  var creanceFactureList = <CreanceRestaurantModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    await creancelivraisonStore.getAllData().then((response) {
      creanceFactureList.clear();
      creanceFactureList.addAll(response);
      creanceFactureList.refresh();
      change(creanceFactureList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await creancelivraisonStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await creancelivraisonStore.deleteData(id).then((value) {
        creanceFactureList.clear();
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

  void submit(CreanceRestaurantModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = FactureRestaurantModel(
          cart: data.cart,
          client: data.client,
          nomClient: data.nomClient,
          telephone: data.telephone,
          succursale: data.succursale,
          signature: data.signature,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await factureRestaurantStore.insertData(dataItem).then((value) {
        deleteData(data.id!); // Une fois dette payé suppression du fichier
        getList();
        Get.back();
        Get.snackbar("Soumission effectuée avec succès!",
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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await creancelivraisonApi.getAllData();
      var dataList =
          creanceFactureList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          creanceFactureList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = CreanceRestaurantModel(
              cart: element.cart,
              client: element.client,
              nomClient: element.nomClient,
              telephone: element.telephone,
              addresse: element.addresse,
              delaiPaiement: element.delaiPaiement,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await creancelivraisonApi.insertData(dataItem).then((value) async {
              CreanceRestaurantModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .last;
              final dataItem = CreanceRestaurantModel(
                id: dataModel.id,
                cart: dataModel.cart,
                client: dataModel.client,
                nomClient: dataModel.nomClient,
                telephone: dataModel.telephone,
                addresse: dataModel.addresse,
                delaiPaiement: dataModel.delaiPaiement,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await creancelivraisonStore.updateData(dataItem).then((value) {
                creanceFactureList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up creanceFactureList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (creanceFactureList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = CreanceRestaurantModel(
              cart: element.cart,
              client: element.client,
              nomClient: element.nomClient,
              telephone: element.telephone,
              addresse: element.addresse,
              delaiPaiement: element.delaiPaiement,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await creancelivraisonStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download creanceFactureList ok");
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
                  final dataItem = CreanceRestaurantModel(
                    id: e.id,
                    cart: element.cart,
                    client: element.client,
                    nomClient: element.nomClient,
                    telephone: element.telephone,
                    addresse: element.addresse,
                    delaiPaiement: element.delaiPaiement,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await creancelivraisonApi
                      .updateData(dataItem)
                      .then((value) async {
                    CreanceRestaurantModel dataModel = dataList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .last;
                    final dataItem = CreanceRestaurantModel(
                      id: dataModel.id,
                      cart: dataModel.cart,
                      client: dataModel.client,
                      nomClient: dataModel.nomClient,
                      telephone: dataModel.telephone,
                      addresse: dataModel.addresse,
                      delaiPaiement: dataModel.delaiPaiement,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await creancelivraisonStore
                        .updateData(dataItem)
                        .then((value) {
                      creanceFactureList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up creanceFactureList ok');
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
