import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class RavitaillementController extends GetxController {
  final AchatController achatController = Get.find();
  final HistoryRavitaillementController historyRavitaillementController =
      Get.put(HistoryRavitaillementController());
  final ProfilController profilController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<ProductModel> idProductDropdown = [];

  int? id;
  String? quantity;
  // String? priceAchatUnit;
  double prixVenteUnit = 0.0;
  double tva = 0.0;
  bool modeAchat = true;
  String modeAchatBool = "false";
  DateTime? date;
  String? telephone;
  String? succursale;

  TextEditingController controlleridProduct = TextEditingController();
  TextEditingController controllerquantity = TextEditingController();
  TextEditingController controllerpriceAchatUnit = TextEditingController();
  // TextEditingController controllerPrixVenteUnit = TextEditingController();
  TextEditingController controllerUnite = TextEditingController();

  double pavTVA = 0.0;

  @override
  void dispose() {
    controlleridProduct.dispose();
    controllerquantity.dispose();
    controllerpriceAchatUnit.dispose();
    // controllerPrixVenteUnit.dispose();
    controllerUnite.dispose();
    super.dispose();
  }

  void clear() {
    quantity == null;
    // priceAchatUnit == null;
    date == null;
    telephone == null;
    succursale == null;
    controlleridProduct.clear();
    controllerquantity.clear();
    controllerpriceAchatUnit.clear();
    // controllerPrixVenteUnit.clear();
    controllerUnite.clear();
  }

  // Historique de ravitaillement
  void submit(AchatModel stock) async {
    try {
      var qtyDisponible =
          double.parse(controllerquantity.text) + double.parse(stock.quantity);

      // Add Achat history pour voir les entrés et sorties de chaque produit
      var qtyDifference =
          double.parse(stock.quantityAchat) - double.parse(stock.quantity);
      var priceDifference = pavTVA - double.parse(stock.priceAchatUnit);
      var margeBenMap = qtyDifference * priceDifference;

      final historyRavitaillementModel = HistoryRavitaillementModel(
          idProduct: stock.idProduct,
          quantity: stock.quantity,
          quantityAchat: stock.quantityAchat,
          priceAchatUnit: stock.priceAchatUnit,
          prixVenteUnit: stock.prixVenteUnit,
          unite: stock.unite,
          margeBen: margeBenMap.toString(),
          tva: stock.tva,
          qtyRavitailler: stock.qtyLivre,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: stock.created,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await historyRavitaillementController.historyRavitaillementstore
          .insertData(historyRavitaillementModel)
          .then((value) {
        // Update stock global
        final achatModel = AchatModel(
            id: stock.id,
            idProduct: stock.idProduct,
            quantity: qtyDisponible.toString(),
            quantityAchat: qtyDisponible.toString(),
            priceAchatUnit: (controllerpriceAchatUnit.text == '')
                ? stock.priceAchatUnit
                : controllerpriceAchatUnit.text,
            prixVenteUnit:
                (pavTVA == 0) ? stock.prixVenteUnit : pavTVA.toString(),
            unite: stock.unite,
            tva: (tva == 0) ? stock.tva : tva.toString(),
            remise: stock.remise,
            qtyRemise: stock.qtyRemise,
            qtyLivre: stock.qtyLivre,
            succursale: stock.succursale,
            signature: profilController.user.matricule,
            created: DateTime.now(),
            business: InfoSystem().business(),
            sync: "upadte",
            async: "new");
        achatController.stockStore.updateData(achatModel).then((value) {
          clear();
          achatController.getList();
          Get.back();
          Get.snackbar("Ravitaillement effectuée avec succès!",
              "Le Ravitaillement a bien été envoyée",
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check),
              snackPosition: SnackPosition.TOP);
          _isLoading.value = false;
        });
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
