import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/marketing/agenda_api.dart';
import 'package:wm_com/src/global/store/marketing/agenda_store.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AgendaController extends GetxController
    with StateMixin<List<AgendaModel>> {
  final AgendaStore agendaStore = AgendaStore();
  final AgendaApi agendaApi = AgendaApi();

  final ProfilController profilController = Get.find();

  var agendaList = <AgendaModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? dateTime;

  @override
  void onInit() {
    agendaList.value = [];
    getList();
    super.onInit();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void clear() {
    titleController.clear();
    descriptionController.clear();
  }

  getList() async {
    await agendaStore.getAllData().then((response) {
      agendaList.clear();
      agendaList.addAll(response);
      change(agendaList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await agendaStore.getOneData(id);
    return data;
  }

  void deleteData(AgendaModel dataItem) {
    agendaStore
        .deleteData(dataItem.id!)
        .then((_) => agendaList.remove(dataItem));
  }

  void updateList(AgendaModel dataItem) async {
    var result = await getList();
    if (result != null) {
      final index = agendaList.indexOf(dataItem);
      agendaList[index] = dataItem;
    }
  }

  void submit() async {
    try {
      _isLoading.value = true;
      final dataItem = AgendaModel(
          title: titleController.text,
          description: descriptionController.text,
          dateRappel: dateTime!,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await agendaStore.insertData(dataItem).then((value) {
        clear();
        updateList(dataItem);
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

  void updateData(AgendaModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = AgendaModel(
          id: data.id!,
          title: titleController.text,
          description: descriptionController.text,
          dateRappel: dateTime!,
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          sync: "update",
          async: "new");
      await agendaStore.updateData(dataItem).then((value) {
        clear();
        updateList(dataItem);
        Get.back();
        Get.snackbar("Modification effectuée avec succès!", "",
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
      var dataCloudList = await agendaApi.getAllData();
      var dataList = agendaList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          agendaList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = AgendaModel(
              title: element.title,
              description: element.description,
              dateRappel: element.dateRappel,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await agendaApi.insertData(dataItem).then((value) async {
              AgendaModel dataModel = dataList
                  .where((p0) =>
                      p0.created.millisecondsSinceEpoch ==
                      value.created.millisecondsSinceEpoch)
                  .first;
              final dataItem = AgendaModel(
                id: dataModel.id,
                title: dataModel.title,
                description: dataModel.description,
                dateRappel: dataModel.dateRappel,
                signature: dataModel.signature,
                created: dataModel.created,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await agendaStore.updateData(dataItem).then((value) {
                agendaList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up agendaList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (agendaList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = AgendaModel(
              title: element.title,
              description: element.description,
              dateRappel: element.dateRappel,
              signature: element.signature,
              created: element.created,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await agendaStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download agendaList ok");
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
                  final dataItem = AgendaModel(
                    id: e.id,
                    title: element.title,
                    description: element.description,
                    dateRappel: element.dateRappel,
                    signature: element.signature,
                    created: element.created,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await agendaApi.updateData(dataItem).then((value) async {
                    AgendaModel dataModel = dataUpdateList
                        .where((p0) =>
                            p0.created.millisecondsSinceEpoch ==
                            value.created.millisecondsSinceEpoch)
                        .first;
                    final dataItem = AgendaModel(
                      id: dataModel.id,
                      title: dataModel.title,
                      description: dataModel.description,
                      dateRappel: dataModel.dateRappel,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    );
                    await agendaStore.updateData(dataItem).then((value) {
                      agendaList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up agendaList ok');
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
