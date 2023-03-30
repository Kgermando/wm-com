import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/restaurant/table_restaurant_store.dart';
import 'package:wm_com/src/models/restaurant/table_restaurant_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class TableRestaurantController extends GetxController
    with StateMixin<List<TableRestaurantModel>> {
  TableRestaurantStore tableRestaurantStore = TableRestaurantStore();
  final ProfilController profilController = Get.find();

  var tableRestaurantList = <TableRestaurantModel>[].obs;

  final Rx<List<TableRestaurantModel>> _venteList =
      Rx<List<TableRestaurantModel>>([]);
  List<TableRestaurantModel> get venteList => _venteList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController tableController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    tableController.dispose();
    super.dispose();
  }

  void clear() {
    tableController.clear();
  }

  void getList() async {
    tableRestaurantStore.getAllData().then((response) {
      tableRestaurantList.clear();
      tableRestaurantList.addAll(response);
      tableRestaurantList.refresh();
      change(tableRestaurantList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) => tableRestaurantStore.getOneData(id);

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await tableRestaurantStore.deleteData(id).then((value) {
        tableRestaurantList.clear();
        getList();
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

  Future submitCommande() async {
    try {
      _isLoading.value = true;
      final dataItem = TableRestaurantModel(
          table: tableController.text,
          part: 'commande',
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await tableRestaurantStore.insertData(dataItem).then((value) async {
        clear();
        getList();
        // Get.back();
        Get.snackbar("Enregistrement effectué!", "Le document a bien été créé!",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
      });
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        "Erreur s'est produite",
        "$e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future submitConsommation() async {
    try {
      _isLoading.value = true;
      final dataItem = TableRestaurantModel(
          table: tableController.text,
          part: 'consommation',
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await tableRestaurantStore.insertData(dataItem).then((value) async {
        clear();
        getList();
        // Get.back();
        Get.snackbar("Enregistrement effectué!", "Le document a bien été créé!",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
      });
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        "Erreur s'est produite",
        "$e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future submitUpdate(TableRestaurantModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = TableRestaurantModel(
          table: tableController.text,
          part: data.part,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          sync: "update",
          async: "new");
      await tableRestaurantStore.updateData(dataItem).then((value) {
        getList();
        Get.back();
        Get.snackbar(
            "Modification effectué!", "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
      });
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
