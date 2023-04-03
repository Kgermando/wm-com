import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/gain_api.dart';
import 'package:wm_com/src/global/store/commercial/gain_store.dart';
import 'package:wm_com/src/models/commercial/gain_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class GainCartController extends GetxController
    with StateMixin<List<GainModel>> {
  final GainStore gainStore = GainStore();
  final GainApi gainApi = GainApi();
  final ProfilController profilController = Get.find();

  var gainList = <GainModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void getList() async {
    await gainStore.getAllData().then((response) {
      gainList.clear();
      gainList.addAll(response);
      gainList.refresh();
      change(gainList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await gainStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await gainStore.deleteData(id).then((value) {
        gainList.clear();
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
      var dataCloudList = await gainApi.getAllData();
      var dataList = gainList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList = gainList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = GainModel(
              sum: element.sum,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await gainApi.insertData(dataItem).then((value) async {
              GainModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .last;
              final dataItem = GainModel(
                id: dataModel.id,
                sum: dataModel.sum,
                succursale: dataModel.succursale,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await gainStore.updateData(dataItem).then((value) {
                gainList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up gainList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (gainList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = GainModel(
              sum: element.sum,
              succursale: element.succursale,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await gainStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download gainList ok");
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
                  final dataItem = GainModel(
                    id: e.id,
                    sum: element.sum,
                    succursale: element.succursale,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await gainApi.updateData(dataItem).then((value) async {
                    GainModel dataModel = dataList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .last;
                    final dataItem = GainModel(
                      id: dataModel.id,
                      sum: dataModel.sum,
                      succursale: dataModel.succursale,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await gainStore.updateData(dataItem).then((value) {
                      gainList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up gainList ok');
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
