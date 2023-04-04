import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/creance_facture_api.dart';
import 'package:wm_com/src/global/store/commercial/facture_creance_store.dart';
import 'package:wm_com/src/global/store/commercial/facture_store.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class FactureCreanceController extends GetxController
    with StateMixin<List<CreanceCartModel>> {
  final FactureCreanceStore factureCreanceStore = FactureCreanceStore();
  final CreanceFactureApi creanceFactureApi = CreanceFactureApi();
  final FactureStore factureStore = FactureStore();
  final ProfilController profilController = Get.find();

  var creanceFactureList = <CreanceCartModel>[].obs;

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
    await factureCreanceStore.getAllData().then((response) {
      creanceFactureList.clear();
      creanceFactureList.addAll(response);
      creanceFactureList.refresh();
      change(creanceFactureList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await factureCreanceStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await factureCreanceStore.deleteData(id).then((value) {
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

  void submit(CreanceCartModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = FactureCartModel(
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
      await factureStore.insertData(dataItem).then((value) {
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
      var dataCloudList = await creanceFactureApi.getAllData();
      var dataList =
          creanceFactureList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          creanceFactureList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = CreanceCartModel( 
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
            await creanceFactureApi.insertData(dataItem).then((value) async {
              CreanceCartModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .first;
              final dataItem = CreanceCartModel(
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
              await factureCreanceStore.updateData(dataItem).then((value) {
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
            final dataItem = CreanceCartModel( 
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
            await factureCreanceStore.insertData(dataItem).then((value) {
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
                  final dataItem = CreanceCartModel(
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
                  await creanceFactureApi
                      .updateData(dataItem)
                      .then((value) async {
                    CreanceCartModel dataModel = dataUpdateList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .first;
                    final dataItem = CreanceCartModel(
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
                    await factureCreanceStore
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
