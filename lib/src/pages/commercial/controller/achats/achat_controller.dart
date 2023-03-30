import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/cart_store.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AchatController extends GetxController with StateMixin<List<AchatModel>> {
  final StockStore stockStore = StockStore();
  final CartStore cartStore = CartStore();

  final ProfilController profilController = Get.put(ProfilController());
  final ProduitModelController produitModelController =
      Get.put(ProduitModelController());

  var achatList = <AchatModel>[].obs;
  var venteFilterQtyList = <AchatModel>[].obs;

  final Rx<List<AchatModel>> _venteList = Rx<List<AchatModel>>([]);
  List<AchatModel> get venteList => _venteList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController filterController = TextEditingController();

  String? idProduct;
  String quantityAchat = '0';
  String priceAchatUnit = '0';
  double prixVenteUnit = 0;
  double remise = 0;
  double qtyRemise = 0;
  double tva = 0;

  @override
  void onInit() {
    super.onInit();
    getList();
    onSearchText('');
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  void clear() {
    idProduct = null;
  }

  void getList() async {
    await stockStore.getAllData().then((response) async {
      achatList.clear();
      venteFilterQtyList.clear();
      achatList.addAll(response
          .where((element) =>
              element.succursale == profilController.user.succursale)
          .toList());
      venteFilterQtyList.addAll(response
          .where((element) =>
              double.parse(element.quantity) > 0 &&
              element.succursale == profilController.user.succursale)
          .toList());
      achatList.refresh();
      venteFilterQtyList.refresh();

      change(achatList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onSearchText(String text) async {
    List<AchatModel> results = [];
    if (text.isEmpty) {
      results = venteFilterQtyList;
    } else {
      results = venteFilterQtyList
          .where((element) => element.idProduct
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
    _venteList.value = results;
  }

  detailView(int id) async {
    final data = await stockStore.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await stockStore.deleteData(id).then((value) {
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
      var uniteProd = idProduct!.split('-');
      var unite = uniteProd.elementAt(1);
      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      final dataItem = AchatModel(
          idProduct: idProduct.toString(),
          quantity: quantityAchat.toString(),
          quantityAchat: quantityAchat.toString(),
          priceAchatUnit: priceAchatUnit.toString(),
          prixVenteUnit: prixVenteUnit.toString(),
          unite: unite.toString(),
          tva: tva.toString(),
          remise: remisePourcentToMontant.toString(),
          qtyRemise: qtyRemise.toString(),
          qtyLivre: quantityAchat.toString(),
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await stockStore.insertData(dataItem).then((value) {
        clear();
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

  void submitUpdate(AchatModel data) async {
    try {
      _isLoading.value = true;
      var uniteProd = idProduct!.split('-');
      var unite = uniteProd.elementAt(1);
      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      final dataItem = AchatModel(
          idProduct: idProduct.toString(),
          quantity: quantityAchat.toString(),
          quantityAchat: quantityAchat.toString(),
          priceAchatUnit: priceAchatUnit.toString(),
          prixVenteUnit: prixVenteUnit.toString(),
          unite: unite.toString(),
          tva: tva.toString(),
          remise: remisePourcentToMontant.toString(),
          qtyRemise: qtyRemise.toString(),
          qtyLivre: quantityAchat.toString(),
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          sync: "update",
          async: "new");
      await stockStore.updateData(dataItem).then((value) {
        clear();
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
