import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/bon_livraison/bon_livraison_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/stock_global_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/succursale/succursale_controller.dart';

import '../../../../utils/info_system.dart';

class LivraisonController extends GetxController {
  final StockGlobalController stockGlobalController =
      Get.put(StockGlobalController());
  final SuccursaleController succursaleController =
      Get.put(SuccursaleController());
  final BonLivraisonController bonLivraisonController =
      Get.put(BonLivraisonController());
  final ProfilController profilController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<SuccursaleModel> succursaleList = [];

  String? quantityStock;
  double remise = 0.0;
  double qtyRemise = 0.0;
  double prixVenteUnit = 0.0;
  String? succursale;

  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerPrixVenteUnit = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  void clear() {
    quantityStock == null;
    succursale == null;
    controllerQuantity.clear();
    controllerPrixVenteUnit.clear();
  }

  @override
  void dispose() {
    controllerQuantity.dispose();
    // controllerPrixVenteUnit.dispose();
    super.dispose();
  }

  void getList() async {
    var succursales = await succursaleController.succursaleApi.getAllData();
    succursaleList = succursales.toList();
  }

  void submit(StocksGlobalMOdel stock) async {
    try {
      _isLoading.value = true;
      var qtyRestanteStockGlobal =
          double.parse(stock.quantity) - double.parse(quantityStock.toString());

      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      // Update quantity stock global
      final stocksGlobalMOdel = StocksGlobalMOdel(
          id: stock.id!,
          idProduct: stock.idProduct,
          quantity: qtyRestanteStockGlobal.toString(),
          quantityAchat: stock.quantityAchat,
          priceAchatUnit: stock.priceAchatUnit,
          prixVenteUnit: stock.prixVenteUnit,
          unite: stock.unite,
          modeAchat: stock.modeAchat,
          tva: stock.tva,
          qtyRavitailler: stock.qtyRavitailler,
          signature: stock.signature,
          created: stock.created,
          business: stock.business,
        sync: "updated",
        async: "updated",
      );
      await stockGlobalController.stockGlobalApi
          .updateData(stocksGlobalMOdel)
          .then((value) async {
        // Generer le bon de livraison pour la succursale
        final bonLivraisonModel = BonLivraisonModel(
            idProduct: value.idProduct,
            quantityAchat: quantityStock.toString(),
            priceAchatUnit: value.priceAchatUnit,
            prixVenteUnit: prixVenteUnit.toString(),
            unite: value.unite,
            firstName: profilController.user.prenom.toString(),
            lastName: profilController.user.nom.toString(),
            tva: value.tva,
            remise: remisePourcentToMontant.toString(),
            qtyRemise: qtyRemise.toString(),
            accuseReception: 'false',
            accuseReceptionFirstName: '-',
            accuseReceptionLastName: '-',
            succursale: succursale.toString(),
            signature: profilController.user.matricule.toString(),
            created: DateTime.now(),
            business: InfoSystem().business(),
          sync: "new",
          async: "new",
        );
        await bonLivraisonController.bonLivraisonApi
            .insertData(bonLivraisonModel)
            .then((value) {
          clear();
          stockGlobalController.stockGlobalList;
          Get.back();
          Get.snackbar("Livraison effectuée avec succès!",
              "La Livraison a bien été envoyée",
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
