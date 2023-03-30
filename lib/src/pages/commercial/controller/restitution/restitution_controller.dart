import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/achat_api.dart';
import 'package:wm_com/src/global/api/commerciale/restitution_api.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/restitution_model.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_livraison.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/stock_global_controller.dart';
import 'package:wm_com/src/utils/info_system.dart'; 

class RestitutionController extends GetxController
    with StateMixin<List<RestitutionModel>> {
  final RestitutionApi restitutionApi = RestitutionApi();
  final AchatApi achatApi = AchatApi();
  final ProfilController profilController = Get.find();
  final StockGlobalController stockGlobalController =
      Get.put(StockGlobalController()); 
  final HistoryLivraisonController historyLivraisonController =
      Get.put(HistoryLivraisonController());

  var restitutionList = <RestitutionModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController quantityStockController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void refresh() {
    getList();
    super.refresh();
  }

  @override
  void dispose() {
    quantityStockController.dispose();
    super.dispose();
  }

  void clear() {
    quantityStockController.clear();
  }

  void getList() async {
    await restitutionApi.getAllData().then((response) {
      restitutionList.assignAll(response);
      change(restitutionList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await restitutionApi.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await restitutionApi.deleteData(id).then((value) {
        restitutionList.clear();
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

  void transfertProduit(AchatModel achat) async {
    try {
      double qtyRestante = 0.0;
      qtyRestante = double.parse(achat.quantity) -
          double.parse(quantityStockController.text);

      final restitutionModel = RestitutionModel(
          idProduct: achat.idProduct,
          quantity: quantityStockController.text,
          unite: achat.unite,
          firstName: profilController.user.nom.toString(),
          lastName: profilController.user.prenom.toString(),
          accuseReception: 'false',
          accuseReceptionFirstName: '-',
          accuseReceptionLastName: '-',
          role: profilController.user.role,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
        sync: "new",
        async: "new",
      );
      await restitutionApi.insertData(restitutionModel).then((value) async {
        //  Update AchatModel
        final achatModel = AchatModel(
            id: achat.id!,
            idProduct: achat.idProduct,
            quantity: qtyRestante.toString(),
            quantityAchat: achat.quantityAchat,
            priceAchatUnit: achat.priceAchatUnit,
            prixVenteUnit: achat.prixVenteUnit,
            unite: achat.unite,
            tva: achat.tva,
            remise: achat.remise,
            qtyRemise: achat.qtyRemise,
            qtyLivre: achat.qtyLivre,
            succursale: achat.succursale,
            signature: achat.signature,
            created: achat.created,
            business: achat.business,
          sync: "updated",
          async: "updated",
        );
        await achatApi.updateData(achatModel).then((value) {
          clear();
          restitutionList.clear();
          getList();
          Get.back();
          Get.snackbar("Le tranfert des l'article a réussi!",
              "Cet article a bien été transferé",
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check),
              snackPosition: SnackPosition.TOP);
          _isLoading.value = false;
        });
      });
    } catch (e) {
      Get.snackbar("Erreur de tranfert", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void receptionProduit(RestitutionModel data) async {
    try {
      var stockList = stockGlobalController.stockGlobalList
          .where((p0) => p0.idProduct == data.idProduct)
          .toSet()
          .toList();
      var stock = stockList.first;

      if (stockList.isNotEmpty) {
        var stockId = stock.id;
        var achatQty = stock.quantity;
        var quantityStockG = stock.quantityAchat;
        var pAU = stock.priceAchatUnit;
        var pVU = stock.prixVenteUnit;
        var uniteStock = stock.unite;
        var modeAchat = stock.modeAchat;
        var dateAchat = stock.created;
        var signatureAchat = stock.signature;
        var tvaAchat = stock.tva;
        var qtyRavitaillerStock = stock.qtyRavitailler;

        // Stocks global + qty restitué
        var qtyTransfert = double.parse(achatQty) + double.parse(data.quantity);

        final stocksGlobalMOdel = StocksGlobalMOdel(
            id: stockId,
            idProduct: data.idProduct,
            quantity: qtyTransfert.toString(),
            quantityAchat: quantityStockG,
            priceAchatUnit: pAU,
            prixVenteUnit: pVU,
            unite: uniteStock,
            modeAchat: modeAchat,
            tva: tvaAchat,
            qtyRavitailler: qtyRavitaillerStock,
            signature: signatureAchat,
            created: dateAchat,
            business: data.business,
          sync: "updated",
          async: "updated",
        );
        await stockGlobalController.stockGlobalApi
            .updateData(stocksGlobalMOdel)
            .then((value) async {
          final restitutionModel = RestitutionModel(
              id: data.id!,
              idProduct: data.idProduct,
              quantity: data.quantity,
              unite: data.unite,
              firstName: data.firstName,
              lastName: data.lastName,
              accuseReception: 'true',
              accuseReceptionFirstName: profilController.user.nom.toString(),
              accuseReceptionLastName: profilController.user.prenom.toString(),
              role: profilController.user.role.toString(),
              succursale: data.succursale,
              signature: profilController.user.matricule.toString(),
              created: DateTime.now(),
              business: data.business,
            sync: "updated",
            async: "updated",
          );
          await restitutionApi.updateData(restitutionModel).then((value) {
            clear();
            restitutionList.clear();
            Get.back();
            Get.snackbar("Livraison effectuée avec succès!",
                "La Livraison a bien été envoyée",
                backgroundColor: Colors.green,
                icon: const Icon(Icons.check),
                snackPosition: SnackPosition.TOP);
            _isLoading.value = false;
          });
        });
      } else {}
    } catch (e) {
      Get.snackbar("Erreur de tranfert", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
