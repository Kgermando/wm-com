// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/number_facture_store.dart';
import 'package:wm_com/src/global/store/livraison/creance_livraison_store.dart';
import 'package:wm_com/src/global/store/livraison/facture_livraison_store.dart';
import 'package:wm_com/src/global/store/livraison/vente_effectue_livraison_store.dart';
import 'package:wm_com/src/global/store/livraison/livraison_store.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/number_facture.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/models/restaurant/creance_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/facture_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/components/factures/pdf_a6/creance_livraison_a6_pdf.dart';
import 'package:wm_com/src/pages/restaurants/livraison/components/factures/pdf_a6/facture_livraison_a6_pdf.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class LivraisonController extends GetxController
    with StateMixin<List<RestaurantModel>> {
  final LivraisonStore livraisonStore = LivraisonStore();
  final CreanceLivraisonStore creancelivraisonStore = CreanceLivraisonStore();
  final FactureLivraisonStore facturelivraisonStore = FactureLivraisonStore();
  final VenteEffectueLivraisonStore venteEffectuelivraisonStore =
      VenteEffectueLivraisonStore();
  final NumberFactureStore numberFactureStore = NumberFactureStore();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final ProfilController profilController = Get.find();
  final CreanceLivraisonPDFA6 creancelivraisonPDFA6 =
      Get.put(CreanceLivraisonPDFA6());
  final FactureLivraisonPDFA6 facturelivraisonPDFA6 =
      Get.put(FactureLivraisonPDFA6());

  var restaurantList = <RestaurantModel>[].obs;

  final Rx<List<RestaurantModel>> _venteList = Rx<List<RestaurantModel>>([]);
  List<RestaurantModel> get venteList => _venteList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  RxInt numberFacture = 0.obs;
  final GlobalKey<FormState> factureFormKey = GlobalKey<FormState>();
  final _isFactureLoading = false.obs;
  bool get isFactureLoading => _isFactureLoading.value;

  final GlobalKey<FormState> creanceFormKey = GlobalKey<FormState>();
  final _isCreanceLoading = false.obs;
  bool get isCreanceLoading => _isCreanceLoading.value;

  // Au comptant
  TextEditingController nomClientController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  // A crédit
  TextEditingController nomClientAcreditController = TextEditingController();
  TextEditingController telephoneAcreditController = TextEditingController();
  TextEditingController addresseAcreditController = TextEditingController();
  DateTime? delaiPaiementAcredit;

  @override
  void onInit() {
    super.onInit();
    getList();
    numberFactureData();
  }

  @override
  void dispose() {
    // Facture
    nomClientController.dispose();
    telephoneController.dispose();
    // Facture creance
    nomClientAcreditController.dispose();
    telephoneAcreditController.dispose();
    addresseAcreditController.dispose();
    super.dispose();
  }

  void clear() {
    // Facture
    nomClientController.clear();
    telephoneController.clear();
    // Facture creance
    nomClientAcreditController.clear();
    telephoneAcreditController.clear();
    addresseAcreditController.clear();
  }

  void getList() async {
    livraisonStore.getAllData().then((response) {
      restaurantList.clear();

      restaurantList.addAll(response);

      restaurantList.refresh();
      change(restaurantList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) => livraisonStore.getOneData(id);

  numberFactureData() async {
    numberFactureStore
        .getCount()
        .then((count) => {numberFacture.value = count});
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await livraisonStore.deleteData(id).then((value) {
        restaurantList.clear();
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

  Future addCommande(ProductModel productModel,
      TextEditingController quantityCartController, String table) async {
    try {
      _isLoading.value = true;
      final dataItem = RestaurantModel(
          identifiant: productModel.identifiant,
          table: table.toString(),
          qty: quantityCartController.text,
          price: productModel.price,
          unite: productModel.unite,
          statutCommande: 'false',
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await livraisonStore.insertData(dataItem).then((value) async {
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

  Future statutSubmit(RestaurantModel restaurantModel, String statut) async {
    try {
      _isLoading.value = true;
      final dataItem = RestaurantModel(
          id: restaurantModel.id,
          identifiant: restaurantModel.identifiant,
          table: restaurantModel.table,
          qty: restaurantModel.qty,
          price: restaurantModel.price,
          unite: restaurantModel.unite,
          statutCommande: statut,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: restaurantModel.created,
          business: restaurantModel.business,
          sync: "update",
          async: "new");
      await livraisonStore.updateData(dataItem).then((value) {
        getList();
        // Get.back();
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

  Future<void> submitFacture(List<RestaurantModel> restaurants) async {
    try {
      _isFactureLoading.value = true;
      final factureCartModel = FactureRestaurantModel(
          cart: restaurants,
          client: '${numberFacture + 1}',
          nomClient:
              (nomClientController.text == '') ? '-' : nomClientController.text,
          telephone:
              (telephoneController.text == '') ? '-' : telephoneController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await facturelivraisonStore
          .insertData(factureCartModel)
          .then((value) async {
        // Genere le numero de la facture
        numberFactureField(factureCartModel.client, factureCartModel.succursale,
            factureCartModel.signature);
        // Ajout des items dans historique
        venteHisotory(restaurants);
        restaurants.clear();
        Get.toNamed(LivraisonRoutes.tableConsommationLivraison);
      });
      _isFactureLoading.value = false;
    } catch (e) {
      _isFactureLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  // PDF Generate Facture
  Future<void> createFacturePDF(List<RestaurantModel> restaurants) async {
    try {
      _isFactureLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final factureCartModel = FactureRestaurantModel(
          cart: restaurants,
          client: '${numberFacture + 1}',
          nomClient:
              (nomClientController.text == '') ? '-' : nomClientController.text,
          telephone:
              (telephoneController.text == '') ? '-' : telephoneController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      List<FactureRestaurantModel> factureList = [];
      factureList.add(factureCartModel);
      // ignore: unused_local_variable
      FactureRestaurantModel? facture;
      for (var item in factureList) {
        facture = item;
      }
      facturelivraisonPDFA6.generatePdf(facture!, monnaieStorage.monney);
      clear();
      _isFactureLoading.value = false;
    } catch (e) {
      _isFactureLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> submitFactureCreance(List<RestaurantModel> restaurants) async {
    try {
      _isCreanceLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceRestaurantModel(
          cart: restaurants,
          client: '${numberFacture + 1}',
          nomClient: (nomClientAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          telephone: (telephoneAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          addresse: (addresseAcreditController.text == '')
              ? '-'
              : addresseAcreditController.text,
          delaiPaiement: (delaiPaiementAcredit == null)
              ? DateTime.parse('2050-07-19 00:00:00')
              : delaiPaiementAcredit!,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await creancelivraisonStore.insertData(creanceCartModel).then((value) {
        numberFactureField(creanceCartModel.client, creanceCartModel.succursale,
            creanceCartModel.signature);
        // Ajout des items dans historique
        venteHisotory(restaurants);
        restaurants.clear();
        Get.toNamed(LivraisonRoutes.tableConsommationLivraison);
        _isCreanceLoading.value = false;
      });
    } catch (e) {
      _isCreanceLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  // PDF Generate Creance
  Future<void> createPDFCreance(List<RestaurantModel> restaurants) async {
    try {
      _isCreanceLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceRestaurantModel(
          cart: restaurants,
          client: '${numberFacture + 1}',
          nomClient: (nomClientAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          telephone: (telephoneAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          addresse: (addresseAcreditController.text == '')
              ? '-'
              : addresseAcreditController.text,
          delaiPaiement: (delaiPaiementAcredit == null)
              ? DateTime.parse('2050-07-19 00:00:00')
              : delaiPaiementAcredit!,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");

      List<CreanceRestaurantModel> creanceList = [];
      creanceList.add(creanceCartModel);
      // ignore: unused_local_variable
      CreanceRestaurantModel? creance;

      for (var item in creanceList) {
        creance = item;
      }
      creancelivraisonPDFA6.generatePdf(creance!, monnaieStorage.monney);
      // await CreanceCartPDFA6.generate(creance!, monnaieStorage);
      clear();
      _isCreanceLoading.value = false;
    } catch (e) {
      _isCreanceLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> numberFactureField(
      String number, String succursale, String signature) async {
    final numberFactureModel = NumberFactureModel(
        number: number,
        succursale: succursale,
        signature: signature,
        created: DateTime.now(),
        business: InfoSystem().business(),
        sync: "new",
        async: "new");
    await numberFactureStore.insertData(numberFactureModel);
  }

  Future<void> venteHisotory(List<RestaurantModel> restaurants) async {
    restaurants.forEach((item) async {
      double priceTotal = 0;
      priceTotal = double.parse(item.qty) * double.parse(item.price);
      final venteCartModel = VenteRestaurantModel(
          identifiant: item.identifiant,
          table: item.table,
          priceTotalCart: priceTotal.toString(),
          qty: item.qty,
          price: item.price,
          unite: item.unite,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await venteEffectuelivraisonStore
          .insertData(venteCartModel)
          .then((value) async {
        await livraisonStore.deleteData(item.id!);
      });
    });
  }
}
