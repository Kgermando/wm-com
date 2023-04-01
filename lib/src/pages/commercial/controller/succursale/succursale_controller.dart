import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/global/api/commerciale/creance_facture_api.dart';
import 'package:wm_com/src/global/api/commerciale/gain_api.dart';
import 'package:wm_com/src/global/api/commerciale/succursale_api.dart';
import 'package:wm_com/src/global/api/commerciale/vente_cart_api.dart';
import 'package:wm_com/src/global/store/commercial/stock_store.dart';
import 'package:wm_com/src/global/store/commercial/succursale_store.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/courbe_vente_gain_model.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/models/commercial/vente_chart_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/province.dart';

class SuccursaleController extends GetxController
    with StateMixin<List<SuccursaleModel>> {
  final SuccursaleApi succursaleApi = SuccursaleApi();
  final SuccursaleStore succursaleStore = SuccursaleStore();
  final StockStore achatStore = StockStore();
  final GainApi gainApi = GainApi();
  final CreanceFactureApi creanceFactureApi = CreanceFactureApi();
  final VenteCartApi venteCartApi = VenteCartApi();
  final ProfilController profilController = Get.find();

  var succursaleList = <SuccursaleModel>[].obs;

  var achatList = <AchatModel>[].obs;

  // 10 produits le plus vendu
  var venteChartList = <VenteChartModel>[].obs;

  var venteDayList = <CourbeVenteModel>[].obs;
  var gainDayList = <CourbeGainModel>[].obs;

  var venteMouthList = <CourbeVenteModel>[].obs;
  var gainMouthList = <CourbeGainModel>[].obs;

  var venteYearList = <CourbeVenteModel>[].obs;
  var gainYearList = <CourbeGainModel>[].obs;

  final _sumGain = 0.0.obs;
  double get sumGain => _sumGain.value;
  final _sumVente = 0.0.obs;
  double get sumVente => _sumVente.value;
  final _sumDCreance = 0.0.obs;
  double get sumDCreance => _sumDCreance.value;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<String> provinceList = Province().provinces;

  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  String? province;

  @override
  void onInit() async {
    super.onInit();
    achatList.value = [];
    getList();
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        getData();
      }
    }
    if (GetPlatform.isWeb) {
      getData();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  void clear() {
    nameController.clear();
    adresseController.clear();
  }

  void getList() async {
    succursaleStore.getAllData().then((response) {
      succursaleList.clear();
      succursaleList.addAll(response);
      succursaleList.refresh();
      change(response, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  Future<void> getData() async {
    achatList.value = await achatStore.getAllData();
    var gains = await gainApi.getAllData();
    var ventes = await venteCartApi.getAllData();
    // var factureCreance =
    //     await creanceFactureApi.getAllData();
    var getVenteChart =
        await succursaleApi.getVenteChart(profilController.user.succursale);

    var getAllDataVenteDay = await succursaleApi
        .getAllDataVenteDay(profilController.user.succursale);
    var getAllDataGainDay =
        await succursaleApi.getAllDataGainDay(profilController.user.succursale);

    var getAllDataVenteMouth = await succursaleApi
        .getAllDataVenteMouth(profilController.user.succursale);
    var getAllDataGainMouth = await succursaleApi
        .getAllDataGainMouth(profilController.user.succursale);

    var getAllDataVenteYear = await succursaleApi
        .getAllDataVenteYear(profilController.user.succursale);
    var getAllDataGainYear = await succursaleApi
        .getAllDataGainYear(profilController.user.succursale);

    venteChartList.clear();
    venteDayList.clear();
    gainDayList.clear();
    gainMouthList.clear();
    gainMouthList.clear();
    venteYearList.clear();
    gainYearList.clear();

    venteChartList.addAll(getVenteChart);
    venteDayList.addAll(getAllDataVenteDay);
    gainDayList.addAll(getAllDataGainDay);
    venteMouthList.addAll(getAllDataVenteMouth);
    gainMouthList.addAll(getAllDataGainMouth);
    venteYearList.addAll(getAllDataVenteYear);
    gainYearList.addAll(getAllDataGainYear);

    venteChartList.refresh();
    venteDayList.refresh();
    gainDayList.refresh();
    venteMouthList.refresh();
    gainMouthList.refresh();
    venteYearList.refresh();
    gainYearList.refresh();

    // Gain
    var dataGain = gains
        .where((element) => element.created.day == DateTime.now().day &&
            element.succursale == profilController.user.succursale)
        .map((e) => e.sum)
        .toList();
    for (var data in dataGain) {
      _sumGain.value += data;
    }

    // Ventes
    var dataPriceVente = ventes
        .where((element) =>
            element.created.day == DateTime.now().day &&
            element.succursale == profilController.user.succursale)
        .map((e) => double.parse(e.priceTotalCart))
        .toList();
    for (var data in dataPriceVente) {
      _sumVente.value += data;
    }

    // // Créances
    // for (var item in factureCreance) {
    //   final cartItem = jsonDecode(item.cart) as List;
    //   List<CartModel> cartItemList = [];

    //   for (var element in cartItem) {
    //     cartItemList.add(CartModel.fromJson(element));
    //   }

    //   for (var data in cartItemList) {
    //     if (double.parse(data.quantityCart) >= double.parse(data.qtyRemise)) {
    //       double total =
    //           double.parse(data.remise) * double.parse(data.quantityCart);
    //       _sumDCreance.value += total;
    //     } else {
    //       double total =
    //           double.parse(data.priceCart) * double.parse(data.quantityCart);
    //       _sumDCreance.value += total;
    //     }
    //   }
    // }

    update();
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await succursaleStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await succursaleStore.deleteData(id).then((value) {
        succursaleList.clear();
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

  Future<void> submit() async {
    try {
      final dataItem = SuccursaleModel(
        name: nameController.text,
        adresse: (adresseController.text == '') ? '-' : adresseController.text,
        province: province.toString(),
        signature: profilController.user.matricule,
        created: DateTime.now(),
        business: InfoSystem().business(),
        sync: 'new',
        async: 'new',
      );
      await succursaleStore.insertData(dataItem).then((value) {
        clear();
        getList();
        Get.back();
        Get.snackbar(
            "Succursale ajoutée avec succès!", "Le document a bien été soumis",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> submitUpdate(SuccursaleModel data) async {
    try {
      final dataItem = SuccursaleModel(
        id: data.id,
        name: (nameController.text == '') ? data.name : nameController.text,
        adresse: (adresseController.text == '')
            ? data.adresse
            : adresseController.text,
        province: province.toString(),
        signature: profilController.user.matricule,
        created: data.created,
        business: data.business,
        sync: 'updated',
        async: 'updated',
      );
      await succursaleStore.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.back();
        Get.snackbar(
            "Succursale ajoutée avec succès!", "Le document a bien été soumis",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void syncDataDown() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await succursaleApi.getAllData();
      dataCloudList.map((e) async {
        if (!succursaleList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = SuccursaleModel(
              name: e.name,
              adresse: e.adresse,
              province: e.province,
              signature: e.signature,
              created: e.created,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            );
            await succursaleStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down succursale ok');
              }
            });
          }
        }
      }).toList();
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
