import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/number_facture_api.dart';
import 'package:wm_com/src/global/store/commercial/number_facture_store.dart';
import 'package:wm_com/src/models/commercial/number_facture.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class NumeroFactureController extends GetxController
    with StateMixin<List<NumberFactureModel>> {
  final NumberFactureStore numberFactureStore = NumberFactureStore();
  final NumberFactureApi numberFactureApi = NumberFactureApi();
  final ProfilController profilController = Get.find();

  var numberFactureList = <NumberFactureModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    await numberFactureStore.getAllData().then((response) {
      numberFactureList.clear();
      numberFactureList.addAll(response);
      numberFactureList.refresh();
      change(numberFactureList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await numberFactureStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await numberFactureStore.deleteData(id).then((value) {
        numberFactureList.clear();
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

  // Le numero facture est generé automatiquement en offline
  // Donc les factures au comptant et a crédit sont synchronisé avec leurs
  // Numero facture
  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await numberFactureApi.getAllData();
      var dataList = numberFactureList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          numberFactureList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = NumberFactureModel(
              number: element.number,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            ); 
            await numberFactureApi.insertData(dataItem).then((value) async {
              NumberFactureModel dataModel =
                  dataList.where((p0) => p0.number == value.number).last;
              final dataItem = NumberFactureModel(
                id: dataModel.id,
                number: dataModel.number,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await numberFactureStore.updateData(dataItem).then((value) {
                numberFactureList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up numberFactureList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (numberFactureList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = NumberFactureModel(
              number: element.number,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await numberFactureStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download numberFactureList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.number == element.number) {
                  final dataItem = NumberFactureModel(
                    id: e.id,
                    number: element.number,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await numberFactureApi
                      .updateData(dataItem)
                      .then((value) async {
                    NumberFactureModel dataModel = dataList
                        .where((p0) => p0.number == value.number)
                        .last;
                    final dataItem = NumberFactureModel(
                      id: dataModel.id,
                      number: dataModel.number,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await numberFactureStore.updateData(dataItem).then((value) {
                      numberFactureList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up numberFactureList ok');
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
