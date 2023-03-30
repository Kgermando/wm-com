import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/stock_global_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class RavitaillementController extends GetxController {
  final StockGlobalController stockGlobalController = Get.find();
  final HistoryRavitaillementController historyRavitaillementController =
      Get.put(HistoryRavitaillementController());
  final ProfilController profilController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<ProductModel> idProductDropdown = [];

  int? id;
  String? quantity;
  String? priceAchatUnit;
  double prixVenteUnit = 0.0;
  double tva = 0.0;
  bool modeAchat = true;
  String modeAchatBool = "False";
  DateTime? date;
  String? telephone;
  String? succursale;
  String? nameBusiness;

  TextEditingController controlleridProduct = TextEditingController();
  TextEditingController controllerquantity = TextEditingController();
  TextEditingController controllerpriceAchatUnit = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();
  TextEditingController controllerUnite = TextEditingController();

  double pavTVA = 0.0;

  @override
  void dispose() {
    controlleridProduct.dispose();
    controllerquantity.dispose();
    controllerpriceAchatUnit.dispose();
    controllerPrixVenteUnit.dispose();
    controllerUnite.dispose();
    super.dispose();
  }

  void clear() {
    quantity == null;
    priceAchatUnit == null;
    date == null;
    telephone == null;
    succursale == null;
    nameBusiness == null;
    controlleridProduct.clear();
    controllerquantity.clear();
    controllerpriceAchatUnit.clear();
    controllerPrixVenteUnit.clear();
    controllerUnite.clear();
  }

  // Historique de ravitaillement
  void submit(StocksGlobalMOdel stock) async {
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
          qtyRavitailler: stock.qtyRavitailler,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: stock.created,
          business: InfoSystem().business(),
        sync: "new",
        async: "new",
      );
      await historyRavitaillementController.historyRavitaillementstore
          .insertData(historyRavitaillementModel)
          .then((value) {
        // Update stock global
        final stocksGlobalMOdel = StocksGlobalMOdel(
            id: stock.id!,
            idProduct: stock.idProduct,
            quantity: qtyDisponible.toString(),
            quantityAchat: qtyDisponible.toString(),
            priceAchatUnit: controllerpriceAchatUnit.text,
            prixVenteUnit: pavTVA.toString(),
            unite: stock.unite,
            modeAchat: modeAchat.toString(),
            tva: tva.toString(),
            qtyRavitailler: stock.qtyRavitailler,
            signature: profilController.user.matricule,
            created: DateTime.now(),
            business: stock.business,
          sync: "updated",
          async: "updated",
        );
        stockGlobalController.stockGlobalApi
            .updateData(stocksGlobalMOdel)
            .then((value) {
          clear();
          stockGlobalController.stockGlobalList;
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
