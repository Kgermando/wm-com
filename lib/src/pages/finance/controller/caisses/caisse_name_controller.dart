import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/finance/caisse_name_api.dart';
import 'package:wm_com/src/global/store/finance/caisse_name_store.dart';

import 'package:wm_com/src/models/finance/caisse_name_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class CaisseNameController extends GetxController
    with StateMixin<List<CaisseNameModel>> {
  final CaisseNameStore caisseNameStore = CaisseNameStore();
  final CaisseNameApi caisseNameApi = CaisseNameApi();
  final ProfilController profilController = Get.find();

  var caisseNameList = <CaisseNameModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController nomCompletController = TextEditingController();
  TextEditingController rccmController = TextEditingController();
  TextEditingController idNatController = TextEditingController();
  TextEditingController addresseController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    rccmController.dispose();
    idNatController.dispose();
    addresseController.dispose();
    super.dispose();
  }

  void clear() {
    nomCompletController.clear();
    rccmController.clear();
    idNatController.clear();
    addresseController.clear();
  }

  void getList() async {
    await caisseNameStore.getAllData().then((response) {
      caisseNameList.clear();
      caisseNameList.assignAll(response);
      caisseNameList.refresh();
      change(caisseNameList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await caisseNameStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await caisseNameStore.deleteData(id).then((value) {
        caisseNameList.clear();
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

  void submit() async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseNameModel(
          nomComplet: nomCompletController.text.toUpperCase(),
          rccm: '-',
          idNat: (idNatController.text == '') ? '-' : idNatController.text,
          addresse:
              (addresseController.text == '') ? '-' : addresseController.text,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await caisseNameStore.insertData(dataItem).then((value) {
        clear();
        caisseNameList.clear();
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

  void submitUpdate(CaisseNameModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseNameModel(
          id: data.id,
          nomComplet: (nomCompletController.text == '')
              ? data.nomComplet
              : nomCompletController.text.toUpperCase(),
          rccm: '-',
          idNat:
              (idNatController.text == '') ? data.idNat : idNatController.text,
          addresse: (addresseController.text == '')
              ? data.addresse
              : addresseController.text,
          created: data.created,
          business: data.business,
          sync: "update",
          async: "new");
      await caisseNameStore.updateData(dataItem).then((value) {
        clear();
        caisseNameList.clear();
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
      var dataCloudList = await caisseNameApi.getAllData();
      var dataList = caisseNameList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          caisseNameList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = CaisseNameModel(
              nomComplet: element.nomComplet,
              rccm: element.rccm,
              idNat: element.idNat,
              addresse: element.addresse,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await caisseNameApi.insertData(dataItem).then((value) async {
              CaisseNameModel dataModel = dataList
                  .where((p0) => p0.nomComplet == value.nomComplet)
                  .last;
              final dataItem = CaisseNameModel(
                id: dataModel.id,
                nomComplet: dataModel.nomComplet,
                rccm: dataModel.rccm,
                idNat: dataModel.idNat,
                addresse: dataModel.addresse,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await caisseNameStore.updateData(dataItem).then((value) {
                caisseNameList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up caisseNameList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (caisseNameList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = CaisseNameModel(
              nomComplet: element.nomComplet,
              rccm: element.rccm,
              idNat: element.idNat,
              addresse: element.addresse,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await caisseNameStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download caisseNameList ok");
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
                  final dataItem = CaisseNameModel(
                    id: e.id,
                    nomComplet: element.nomComplet,
                    rccm: element.rccm,
                    idNat: element.idNat,
                    addresse: element.addresse,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await caisseNameApi.updateData(dataItem).then((value) async {
                    CaisseNameModel dataModel = dataList
                        .where((p0) => p0.nomComplet == value.nomComplet)
                        .last;
                    final dataItem = CaisseNameModel(
                      id: dataModel.id,
                      nomComplet: dataModel.nomComplet,
                      rccm: dataModel.rccm,
                      idNat: dataModel.idNat,
                      addresse: dataModel.addresse,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await caisseNameStore.updateData(dataItem).then((value) {
                      caisseNameList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up caisseNameList ok');
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
