import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/reservation/reservation_api.dart';
import 'package:wm_com/src/global/store/reservation/reservation_store.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/type_event_dropdown.dart';

class ReservationController extends GetxController
    with StateMixin<List<ReservationModel>> {
  ReservationStore reservationStore = ReservationStore();
  ReservationApi reservationApi = ReservationApi();
  final ProfilController profilController = Get.find();

  var reservationList = <ReservationModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final typeEvent = TypeEventDropdown().typeEvent;

  TextEditingController clientController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController nbrePersonneController = TextEditingController();
  TextEditingController dureeEventController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  String? background;
  String? eventName;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  @override
  void dispose() {
    clientController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    adresseController.dispose();
    nbrePersonneController.dispose();
    adresseController.dispose();
    dureeEventController.dispose();
    montantController.dispose();
    super.dispose();
  }

  void clear() {
    background = null;
    eventName = null;
    clientController.clear();
    telephoneController.clear();
    emailController.clear();
    adresseController.clear();
    nbrePersonneController.clear();
    adresseController.clear();
    dureeEventController.clear();
    montantController.clear();
  }

  void getList() async {
    reservationStore.getAllData().then((response) {
      reservationList.clear();
      reservationList.addAll(response);
      reservationList.refresh();
      change(reservationList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) => reservationStore.getOneData(id);

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await reservationStore.deleteData(id).then((value) {
        reservationList.clear();
        clear();
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

  Future submit(DateTime date) async {
    try {
      _isLoading.value = true;
      final dataItem = ReservationModel(
          client: clientController.text,
          telephone: telephoneController.text,
          email: emailController.text,
          adresse: adresseController.text,
          nbrePersonne: nbrePersonneController.text,
          dureeEvent: dureeEventController.text,
          createdDay: date,
          background: background.toString(),
          eventName: eventName.toString(),
          montant: montantController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await reservationStore.insertData(dataItem).then((value) async {
        clear();
        getList();
        Get.back();
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

  Future submitUpdate(ReservationModel reservationModel) async {
    try {
      _isLoading.value = true;
      final dataItem = ReservationModel(
          client: (clientController.text == '')
              ? reservationModel.client
              : clientController.text,
          telephone: (telephoneController.text == '')
              ? reservationModel.telephone
              : telephoneController.text,
          email: (emailController.text == '')
              ? reservationModel.email
              : emailController.text,
          adresse: (adresseController.text == '')
              ? reservationModel.adresse
              : adresseController.text,
          nbrePersonne: (nbrePersonneController.text == '')
              ? reservationModel.nbrePersonne
              : nbrePersonneController.text,
          dureeEvent: (dureeEventController.text == '')
              ? reservationModel.dureeEvent
              : dureeEventController.text,
          createdDay: reservationModel.createdDay,
          background: background.toString(),
          eventName: eventName.toString(),
          montant: montantController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: reservationModel.created,
          business: reservationModel.business,
          sync: "update",
          async: "new");
      await reservationStore.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.back();
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

  void syncDataDown() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await reservationApi.getAllData();
      dataCloudList.map((e) async {
        if (!reservationList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = ReservationModel(
              client: e.client,
              telephone: e.telephone,
              email: e.email,
              adresse: e.adresse,
              nbrePersonne: e.nbrePersonne,
              dureeEvent: e.dureeEvent,
              createdDay: e.createdDay,
              background: e.background,
              eventName: e.eventName,
              montant: e.montant,
              succursale: e.succursale,
              signature: e.signature,
              created: e.created,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            ); 
            await reservationStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down reservation ok');
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
