import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/terrasse/prod_model_terrasse_store.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class ProdModelTerrasseController extends GetxController
    with StateMixin<List<ProductModel>> {
  final ProdModelTerrasseStore prodModelterrasseStore =
      ProdModelTerrasseStore();
  final ProfilController profilController = Get.find();

  var produitModelList = <ProductModel>[].obs;

  var venteFilterQtyList = <ProductModel>[].obs;

  final Rx<List<ProductModel>> _venteList = Rx<List<ProductModel>>([]);
  List<ProductModel> get venteList => _venteList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController identifiantController = TextEditingController();
  TextEditingController uniteController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController filterController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
    onSearchText('');
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  @override
  void dispose() {
    filterController.dispose();
    identifiantController.dispose();
    uniteController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void clear() {
    identifiantController.clear();
    uniteController.clear();
    priceController.clear();
  }

  void getList() async {
    await prodModelterrasseStore.getAllData().then((response) {
      produitModelList.clear();
      venteFilterQtyList.clear();
      produitModelList.addAll(response);
      venteFilterQtyList.addAll(response);
      change(produitModelList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onSearchText(String text) async {
    List<ProductModel> results = [];
    if (text.isEmpty) {
      results = venteFilterQtyList;
    } else {
      results = venteFilterQtyList
          .where((element) => element.identifiant
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
    _venteList.value = results;
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await prodModelterrasseStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await prodModelterrasseStore.deleteData(id).then((value) {
        clear();
        produitModelList.clear();
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

  void submit(String service) async {
    try {
      _isLoading.value = true;
      final idProductform =
          "${identifiantController.text.trim()}-${uniteController.text.trim()}";
      final dataItem = ProductModel(
          service: service,
          identifiant: (identifiantController.text == "")
              ? '-'
              : identifiantController.text.trim(),
          unite:
              (uniteController.text == "") ? '-' : uniteController.text.trim(),
          price:
              (priceController.text == "") ? '0' : priceController.text.trim(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await prodModelterrasseStore.insertData(dataItem).then((value) {
        clear();
        produitModelList.clear();
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

  void submitUpdate(ProductModel data) async {
    try {
      _isLoading.value = true;
      final idProductform =
          "${identifiantController.text.trim()}-${uniteController.text.trim()}";
      final dataItem = ProductModel(
          id: data.id,
          service: data.service,
          identifiant: (identifiantController.text == "")
              ? data.identifiant
              : identifiantController.text.trim(),
          unite: (uniteController.text == "")
              ? data.unite
              : uniteController.text.trim(),
          price: (priceController.text == "")
              ? data.price
              : priceController.text.trim(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          sync: "new",
          async: "new");
      await prodModelterrasseStore.updateData(dataItem).then((value) {
        clear();
        produitModelList.clear();
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
