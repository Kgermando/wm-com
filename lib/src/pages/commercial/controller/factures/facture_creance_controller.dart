import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/facture_creance_store.dart';
import 'package:wm_com/src/global/store/commercial/facture_store.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class FactureCreanceController extends GetxController
    with StateMixin<List<CreanceCartModel>> {
  final FactureCreanceStore factureCreanceStore = FactureCreanceStore();
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
}
