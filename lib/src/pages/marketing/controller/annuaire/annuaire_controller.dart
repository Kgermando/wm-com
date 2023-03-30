import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wm_com/src/global/store/marketing/annuaire_store.dart';
import 'package:wm_com/src/models/marketing/annuaire_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AnnuaireController extends GetxController
    with StateMixin<List<AnnuaireModel>> {
  final AnnuaireStore annuaireStore = AnnuaireStore();

  final ProfilController profilController = Get.find();

  var annuaireList = <AnnuaireModel>[].obs;

  final Rx<List<AnnuaireModel>> _annuaireFilterList =
      Rx<List<AnnuaireModel>>([]);
  List<AnnuaireModel> get annuaireFilterList =>
      _annuaireFilterList.value; // For filter

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  bool hasCallSupport = false;
  // ignore: unused_field
  Future<void>? launched;

  TextEditingController nomPostnomPrenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobile1Controller = TextEditingController();
  TextEditingController mobile2Controller = TextEditingController();
  TextEditingController secteurActiviteController = TextEditingController();
  TextEditingController nomEntrepriseController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController adresseEntrepriseController = TextEditingController();

  String? categorie;

  // Filter
  TextEditingController filterController = TextEditingController();

  @override
  void onInit() {
    getList();
    onSearchText('');
    super.onInit();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  @override
  void dispose() {
    filterController.dispose();
    nomPostnomPrenomController.dispose();
    emailController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    secteurActiviteController.dispose();
    nomEntrepriseController.dispose();
    gradeController.dispose();
    adresseEntrepriseController.dispose();
    super.dispose();
  }

  void clear() {
    categorie = null;
    nomPostnomPrenomController.clear();
    emailController.clear();
    mobile1Controller.clear();
    mobile2Controller.clear();
    secteurActiviteController.clear();
    nomEntrepriseController.clear();
    gradeController.clear();
    adresseEntrepriseController.clear();
  }

  getList() async {
    await annuaireStore.getAllData().then((response) {
      annuaireList.clear();
      annuaireList.addAll(response);
      change(annuaireList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void onSearchText(String text) async {
    List<AnnuaireModel> results = [];
    if (text.isEmpty) {
      results = annuaireList;
    } else {
      results = annuaireList
          .where((element) =>
              element.categorie
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.nomPostnomPrenom
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.email
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.mobile1
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.secteurActivite
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.nomEntreprise
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.succursale
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList();
    }
    _annuaireFilterList.value = results;
  }

  detailView(int id) async {
    final data = await annuaireStore.getOneData(id);
    return data;
  }

  void deleteData(AnnuaireModel dataItem) {
    annuaireStore
        .deleteData(dataItem.id!)
        .then((_) => annuaireList.remove(dataItem));
  }

  void updateList(AnnuaireModel dataItem) async {
    var result = await getList();
    if (result != null) {
      final index = annuaireList.indexOf(dataItem);
      annuaireList[index] = dataItem;
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // ignore: deprecated_member_use
    await launch(launchUri.toString());
  }

  void submit() async {
    try {
      _isLoading.value = true;
      final dataItem = AnnuaireModel(
          categorie: categorie.toString(),
          nomPostnomPrenom: nomPostnomPrenomController.text,
          email: emailController.text,
          mobile1: mobile1Controller.text,
          mobile2: mobile2Controller.text,
          secteurActivite: secteurActiviteController.text,
          nomEntreprise: nomEntrepriseController.text,
          grade: gradeController.text,
          adresseEntreprise: adresseEntrepriseController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          updateCreated: DateTime.now(),
          sync: "new",
          async: "new");
      await annuaireStore.insertData(dataItem).then((value) {
        clear();
        updateList(dataItem);
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

  void updateData(AnnuaireModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = AnnuaireModel(
          id: data.id,
          categorie: categorie.toString(),
          nomPostnomPrenom: nomPostnomPrenomController.text,
          email: emailController.text,
          mobile1: mobile1Controller.text,
          mobile2: mobile2Controller.text,
          secteurActivite: secteurActiviteController.text,
          nomEntreprise: nomEntrepriseController.text,
          grade: gradeController.text,
          adresseEntreprise: adresseEntrepriseController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          updateCreated: DateTime.now(),
          sync: "update",
          async: "new");
      await annuaireStore.updateData(dataItem).then((value) {
        clear();
        updateList(dataItem);
        Get.back();
        Get.snackbar("Modification effectuée avec succès!", "",
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
