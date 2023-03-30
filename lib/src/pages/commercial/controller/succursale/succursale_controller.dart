import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/commerciale/achat_api.dart';
import 'package:wm_com/src/global/api/commerciale/succursale_api.dart'; 
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
  final AchatApi achatApi = AchatApi();
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<String> provinceList = Province().provinces;

  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  String? province;
 

  @override
  void onInit() {
    achatList.value = [];
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
    nameController.dispose();
    adresseController.dispose(); 
    super.dispose();
  }

  void clear() {
    nameController.clear();
    adresseController.clear(); 
  }

  void getList() async {
    succursaleApi.getAllData().then((response) {
      succursaleList.clear();
      succursaleList.addAll(response);
      succursaleList.refresh();
      change(response, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  Future<void> getData(String name) async {
    achatList.value = await achatApi.getAllData();
    var getVenteChart = await succursaleApi.getVenteChart(name);

    var getAllDataVenteDay = await succursaleApi.getAllDataVenteDay(name);
    var getAllDataGainDay = await succursaleApi.getAllDataGainDay(name);

    var getAllDataVenteMouth = await succursaleApi.getAllDataVenteMouth(name);
    var getAllDataGainMouth = await succursaleApi.getAllDataGainMouth(name);

    var getAllDataVenteYear = await succursaleApi.getAllDataVenteYear(name);
    var getAllDataGainYear = await succursaleApi.getAllDataGainYear(name);

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
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await succursaleApi.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await succursaleApi.deleteData(id).then((value) {
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
      await succursaleApi.insertData(dataItem).then((value) {
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
      await succursaleApi.updateData(dataItem).then((value) {
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

   
}
