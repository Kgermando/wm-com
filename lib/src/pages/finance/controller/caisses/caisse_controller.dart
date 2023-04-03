import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/finance/caisse_api.dart';
import 'package:wm_com/src/global/store/finance/caisse_store.dart';

import 'package:wm_com/src/models/finance/caisse_model.dart';
import 'package:wm_com/src/models/finance/caisse_name_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/dropdown.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/type_operation.dart';

class CaisseController extends GetxController
    with StateMixin<List<CaisseModel>> {
  final CaisseStore caisseStore = CaisseStore();
  final CaisseApi caisseApi = CaisseApi();
  final ProfilController profilController = Get.find();

  var caisseList = <CaisseModel>[].obs;

  final GlobalKey<FormState> formKeyEncaissement = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyDecaissement = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController nomCompletController = TextEditingController();
  TextEditingController pieceJustificativeController = TextEditingController();
  TextEditingController libelleController = TextEditingController();
  TextEditingController montantController = TextEditingController();

  String? typeOperation; // For Update

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;
  final List<String> departementList = Dropdown().departement;

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

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    super.dispose();
  }

  void clear() {
    typeOperation = null;
    nomCompletController.clear();
    pieceJustificativeController.clear();
    libelleController.clear();
    montantController.clear();
  }

  void getList() async {
    await caisseStore.getAllData().then((response) {
      caisseList.clear();
      caisseList.assignAll(response);
      change(caisseList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await caisseStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await caisseStore.deleteData(id).then((value) {
        caisseList.clear();
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

  void submitEncaissement(CaisseNameModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseModel(
          nomComplet: nomCompletController.text,
          pieceJustificative: pieceJustificativeController.text,
          libelle: libelleController.text,
          montantEncaissement: montantController.text,
          departement: '-',
          typeOperation: 'Encaissement',
          numeroOperation: 'Transaction-Caisse-${caisseList.length + 1}',
          signature: profilController.user.matricule,
          reference: data.id!,
          caisseName: data.nomComplet,
          created: DateTime.now(),
          montantDecaissement: "0",
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await caisseStore.insertData(dataItem).then((value) {
        clear();
        caisseList.clear();
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

  void submitDecaissement(CaisseNameModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseModel(
          nomComplet: nomCompletController.text,
          pieceJustificative: '-',
          libelle: libelleController.text,
          montantEncaissement: "0",
          departement: '-',
          typeOperation: 'Decaissement',
          numeroOperation: 'Transaction-Caisse-${caisseList.length + 1}',
          signature: profilController.user.matricule,
          reference: data.id!,
          caisseName: data.nomComplet,
          created: DateTime.now(),
          montantDecaissement: montantController.text,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await caisseStore.insertData(dataItem).then((value) {
        clear();
        caisseList.clear();
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
      var dataCloudList = await caisseApi.getAllData();
      var dataList = caisseList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          caisseList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = CaisseModel(
              nomComplet: element.nomComplet,
              pieceJustificative: element.pieceJustificative,
              libelle: element.libelle,
              montantEncaissement: element.montantEncaissement,
              departement: element.departement,
              typeOperation: element.typeOperation,
              numeroOperation: element.numeroOperation,
              signature: element.signature,
              reference: element.reference,
              caisseName: element.caisseName,
              created: element.created,
              montantDecaissement: element.montantDecaissement,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await caisseApi.insertData(dataItem).then((value) async {
              CaisseModel dataModel = dataList
                  .where((p0) => p0.nomComplet == value.nomComplet).last;
              final dataItem = CaisseModel(
                id: dataModel.id,
                nomComplet: dataModel.nomComplet,
                pieceJustificative: dataModel.pieceJustificative,
                libelle: dataModel.libelle,
                montantEncaissement: dataModel.montantEncaissement,
                departement: dataModel.departement,
                typeOperation: dataModel.typeOperation,
                numeroOperation: dataModel.numeroOperation,
                signature: dataModel.signature,
                reference: dataModel.reference,
                caisseName: dataModel.caisseName,
                created: dataModel.created,
                montantDecaissement: dataModel.montantDecaissement,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await caisseStore.updateData(dataItem).then((value) {
                caisseList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up caisseList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (caisseList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = CaisseModel(
              nomComplet: element.nomComplet,
              pieceJustificative: element.pieceJustificative,
              libelle: element.libelle,
              montantEncaissement: element.montantEncaissement,
              departement: element.departement,
              typeOperation: element.typeOperation,
              numeroOperation: element.numeroOperation,
              signature: element.signature,
              reference: element.reference,
              caisseName: element.caisseName,
              created: element.created,
              montantDecaissement: element.montantDecaissement,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await caisseStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download caisseList ok");
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
                  final dataItem = CaisseModel(
                    id: e.id,
                    nomComplet: element.nomComplet,
                    pieceJustificative: element.pieceJustificative,
                    libelle: element.libelle,
                    montantEncaissement: element.montantEncaissement,
                    departement: element.departement,
                    typeOperation: element.typeOperation,
                    numeroOperation: element.numeroOperation,
                    signature: element.signature,
                    reference: element.reference,
                    caisseName: element.caisseName,
                    created: element.created,
                    montantDecaissement: element.montantDecaissement,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await caisseApi.updateData(dataItem).then((value) async {
                    CaisseModel dataModel = dataList
                        .where((p0) => p0.nomComplet == value.nomComplet)
                        .last;
                    final dataItem = CaisseModel(
                      id: dataModel.id,
                      nomComplet: dataModel.nomComplet,
                      pieceJustificative: dataModel.pieceJustificative,
                      libelle: dataModel.libelle,
                      montantEncaissement: dataModel.montantEncaissement,
                      departement: dataModel.departement,
                      typeOperation: dataModel.typeOperation,
                      numeroOperation: dataModel.numeroOperation,
                      signature: dataModel.signature,
                      reference: dataModel.reference,
                      caisseName: dataModel.caisseName,
                      created: dataModel.created,
                      montantDecaissement: dataModel.montantDecaissement,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await caisseStore.updateData(dataItem).then((value) {
                      caisseList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up caisseList ok');
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
