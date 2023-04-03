import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:wm_com/src/global/api/commerciale/bon_livraison_api.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart'; 

import '../../../../utils/info_system.dart';

class LivraisonComController extends GetxController {
  final StockStore stockStore = StockStore();
  final BonLivraisonApi bonLivraisonApi = BonLivraisonApi();
  final ProfilController profilController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String quantityStock = '0';
  double remise = 0.0;
  double qtyRemise = 0.0;
  double prixVenteUnit = 0.0;
  String? succursale;

  // TextEditingController quantityController = TextEditingController();
  // TextEditingController prixVenteUnitController = TextEditingController();

  void clear() {
    succursale = null;
    // quantityController.clear();
    // prixVenteUnitController.clear();
  }

  @override
  void dispose() {
    // quantityController.dispose();
    // prixVenteUnitController.dispose();
    super.dispose();
  }

  void submit(AchatModel stock) async {
    try {
      _isLoading.value = true;
      var qtyRestanteStockGlobal =
          double.parse(stock.quantity) - double.parse(quantityStock);

      var remisePourcent = (prixVenteUnit * remise) / 100;
      var remisePourcentToMontant = prixVenteUnit - remisePourcent;

      // Update quantity stock global
      final achatModel = AchatModel(
        id: stock.id!,
        idProduct: stock.idProduct,
        quantity: qtyRestanteStockGlobal.toString(),
        quantityAchat: stock.quantityAchat,
        priceAchatUnit: stock.priceAchatUnit,
        prixVenteUnit: stock.prixVenteUnit,
        unite: stock.unite,
        tva: stock.tva,
        remise: stock.remise,
        qtyRemise: stock.qtyRemise,
        qtyLivre: stock.qtyLivre,
        succursale: stock.succursale,
        signature: stock.signature,
        created: stock.created,
        business: stock.business,
        sync: "updated",
        async: "updated",
      );
      await stockStore.updateData(achatModel).then((value) async {
        // Generer le bon de livraison pour la succursale
        final bonLivraisonModel = BonLivraisonModel(
          idProduct: achatModel.idProduct,
          quantityAchat: quantityStock.toString(),
          priceAchatUnit: achatModel.priceAchatUnit,
          prixVenteUnit: prixVenteUnit.toString(),
          unite: achatModel.unite,
          firstName: profilController.user.prenom.toString(),
          lastName: profilController.user.nom.toString(),
          tva: achatModel.tva,
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
        await bonLivraisonApi
            .insertData(bonLivraisonModel)
            .then((value) {
          clear();
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
