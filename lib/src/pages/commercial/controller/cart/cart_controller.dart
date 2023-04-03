// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/store/commercial/cart_store.dart';
import 'package:wm_com/src/global/store/commercial/facture_creance_store.dart';
import 'package:wm_com/src/global/store/commercial/facture_store.dart';
import 'package:wm_com/src/global/store/commercial/gain_store.dart';
import 'package:wm_com/src/global/store/commercial/number_facture_store.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/global/store/commercial/vente_effectue_store.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:wm_com/src/models/commercial/gain_model.dart';
import 'package:wm_com/src/models/commercial/number_facture.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/factures/pdf_a6/creance_cart_a6_pdf.dart';
import 'package:wm_com/src/pages/commercial/components/factures/pdf_a6/facture_cart_a6_pdf.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class CartController extends GetxController with StateMixin<List<CartModel>> {
  final CartStore cartStore = CartStore();
  final StockStore stockStore = StockStore();
  final GainStore gainStore = GainStore();
  final FactureStore factureStore = FactureStore();
  final FactureCreanceStore factureCreanceStore = FactureCreanceStore();
  final NumberFactureStore numberFactureStore = NumberFactureStore();
  final VenteEffectueStore venteEffectueStore = VenteEffectueStore();

  final ProfilController profilController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final FactureCartPDFA6 factureCartPDFA6 = Get.put(FactureCartPDFA6());
  final CreanceCartPDFA6 creanceCartPDFA6 = Get.put(CreanceCartPDFA6());

  RxList<CartModel> cartList = <CartModel>[].obs;
  RxList<AchatModel> stockList = <AchatModel>[].obs;

  RxInt numberFacture = 0.obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isLoadingCancel = false.obs;
  bool get isLoadingCancel => _isLoadingCancel.value;

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
    cartList.value = [];
    stockList.value = [];
    fetchStockData();
    numberFactureData();
    getList();
    super.onInit();
  }

  // @override
  // void refresh() {
  //   fetchStockData();
  //   getList();
  //   super.refresh();
  // }

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

  getList() async {
    await cartStore.getAllData().then((response) {
      cartList.clear();
      cartList.addAll(response);
      change(cartList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await cartStore.getOneData(id);
    return data;
  }

  fetchStockData() async {
    stockStore.getAllData().then((dataList) => {stockList.value = dataList});
  }

  numberFactureData() async {
    numberFactureStore
        .getCount()
        .then((count) => {numberFacture.value = count});
  }

  void addCart(
      AchatModel achat, TextEditingController quantityCartController) async {
    try {
      _isLoading.value = true;
      final cartModel = CartModel(
          idProductCart: achat.idProduct,
          quantityCart:
              quantityCartController.text, // controllerQuantityCart.toString(),
          priceCart: achat.prixVenteUnit,
          priceAchatUnit: achat.priceAchatUnit,
          unite: achat.unite,
          tva: achat.tva,
          remise: achat.remise,
          qtyRemise: achat.qtyRemise,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          createdAt: achat.created,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await cartStore.insertData(cartModel).then((value) async {
        var qty = double.parse(achat.quantity) -
            double.parse(quantityCartController.text);
        final achatModel = AchatModel(
            id: achat.id!,
            idProduct: achat.idProduct,
            quantity: qty.toString(),
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
            sync: "update",
            async: "update");
        await stockStore.updateData(achatModel).then((value) {
          clear();
          cartList.clear();
          getList();
          // Get.back();
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

  Future<void> submitFacture(List<CartModel> cartListItem) async {
    try {
      _isFactureLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final factureCartModel = FactureCartModel(
          cart: cartListItem,
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
      await factureStore.insertData(factureCartModel).then((value) async {
        // Genere le numero de la facture
        numberFactureField(factureCartModel.client, factureCartModel.succursale,
            factureCartModel.signature);
        // Ajout des items dans historique
        venteHisotory(cartListItem);
        // Add Gain par produit
        gainVentes(cartListItem);
        // Vide de la panier
        cartStore.deleteAllData().then((value) {
          clear();
          Get.toNamed(ComRoutes.comVente);
        });
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
  Future<void> createFacturePDF(List<CartModel> cartListItem) async {
    try {
      _isFactureLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final factureCartModel = FactureCartModel(
          cart: cartListItem,
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
      List<FactureCartModel> factureList = [];
      factureList.add(factureCartModel);
      // ignore: unused_local_variable
      FactureCartModel? facture;
      for (var item in factureList) {
        facture = item;
      }
      factureCartPDFA6.generatePdf(facture!, monnaieStorage.monney);
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

  Future<void> submitFactureCreance(List<CartModel> cartListItem) async {
    try {
      _isCreanceLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceCartModel(
          cart: cartListItem,
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
      await factureCreanceStore.insertData(creanceCartModel).then((value) {
        numberFactureField(creanceCartModel.client, creanceCartModel.succursale,
            creanceCartModel.signature);
        // Ajout des items dans historique
        venteHisotory(cartListItem);
        // Add Gain par produit
        gainVentes(cartListItem);
        // Vide de la panier
        cartStore.deleteAllData().then((value) {
          clear();
          cartList.clear();
          Get.toNamed(ComRoutes.comVente);
        });
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
  Future<void> createPDFCreance(List<CartModel> cartListItem) async {
    try {
      _isCreanceLoading.value = true;
      // final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceCartModel(
          cart: cartListItem,
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

      List<CreanceCartModel> creanceList = [];
      creanceList.add(creanceCartModel);
      // ignore: unused_local_variable
      CreanceCartModel? creance;

      for (var item in creanceList) {
        creance = item;
      }
      creanceCartPDFA6.generatePdf(creance!, monnaieStorage.monney);
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

  Future<void> venteHisotory(List<CartModel> cartItemList) async {
    cartItemList.forEach((item) async {
      double priceTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.remise);
      } else {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.priceCart);
      }
      final venteCartModel = VenteCartModel(
          idProductCart: item.idProductCart,
          quantityCart: item.quantityCart,
          priceTotalCart: priceTotal.toString(),
          unite: item.unite,
          tva: item.tva,
          remise: item.remise,
          qtyRemise: item.qtyRemise,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created,
          createdAt: item.createdAt,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await venteEffectueStore.insertData(venteCartModel);
    });
  }

  Future<void> gainVentes(List<CartModel> cartItemList) async {
    cartItemList.forEach((item) async {
      double gainTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        gainTotal =
            (double.parse(item.remise) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      } else {
        gainTotal =
            (double.parse(item.priceCart) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      }
      final gainModel = GainModel(
          sum: gainTotal,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created,
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await gainStore.insertData(gainModel);
    });
  }

  updateAchat(CartModel cart) async {
    try {
      _isLoadingCancel.value = true;
      var achatQtyList =
          stockList.where((e) => e.idProduct == cart.idProductCart);

      final achatQty = achatQtyList
          .map(
              (e) => double.parse(e.quantity) + double.parse(cart.quantityCart))
          .first;

      final achatIdProduct = achatQtyList.map((e) => e.idProduct).first;
      final achatQuantityAchat = achatQtyList.map((e) => e.quantityAchat).first;
      final achatAchatUnit = achatQtyList.map((e) => e.priceAchatUnit).first;
      final achatPrixVenteUnit = achatQtyList.map((e) => e.prixVenteUnit).first;
      final achatUnite = achatQtyList.map((e) => e.unite).first;
      final achatId = achatQtyList.map((e) => e.id).first;
      final achattva = achatQtyList.map((e) => e.tva).first;
      final achatRemise = achatQtyList.map((e) => e.remise).first;
      final achatQtyRemise = achatQtyList.map((e) => e.qtyRemise).first;
      final achatQtyLivre = achatQtyList.map((e) => e.qtyLivre).first;
      final achatSuccursale = achatQtyList.map((e) => e.succursale).first;
      final achatSignature = achatQtyList.map((e) => e.signature).first;
      final achatCreated = achatQtyList.map((e) => e.created).first;

      final achatModel = AchatModel(
          id: achatId!,
          idProduct: achatIdProduct,
          quantity: achatQty.toString(),
          quantityAchat: achatQuantityAchat,
          priceAchatUnit: achatAchatUnit,
          prixVenteUnit: achatPrixVenteUnit,
          unite: achatUnite,
          tva: achattva,
          remise: achatRemise,
          qtyRemise: achatQtyRemise,
          qtyLivre: achatQtyLivre,
          succursale: achatSuccursale,
          signature: achatSignature,
          created: achatCreated,
          business: InfoSystem().business(),
          sync: "update",
          async: "update");
      await stockStore.updateData(achatModel);
      deleteData(cart);
      _isLoadingCancel.value = false;
    } catch (e) {
      _isLoadingCancel.value = false;
      Get.snackbar("Une Erreur ", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void deleteData(CartModel dataItem) {
    cartStore.deleteData(dataItem.id!).then((_) => cartList.remove(dataItem));
  }
}
