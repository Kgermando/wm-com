import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/global/api/reservation/paiement_reservation_api.dart';
import 'package:wm_com/src/global/store/reservation/paiement_reservation_store.dart';
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class PaiementReservationController extends GetxController
    with StateMixin<List<PaiementReservationModel>> {
  PaiementReservationStore paiementReservationStore =
      PaiementReservationStore();
  PaiementReservationApi paiementReservationApi =
      PaiementReservationApi();
  final ProfilController profilController = Get.find();

  var paiementReservationList = <PaiementReservationModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController montantController = TextEditingController();
  TextEditingController motifController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    montantController.dispose();
    motifController.dispose();
    super.dispose();
  }

  void clear() {
    montantController.clear();
    motifController.clear();
  }

  void getList() async {
    paiementReservationStore.getAllData().then((response) {
      paiementReservationList.clear();
      paiementReservationList.addAll(response);
      paiementReservationList.refresh();
      change(paiementReservationList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) => paiementReservationStore.getOneData(id);

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await paiementReservationStore.deleteData(id).then((value) {
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

  Future submit(ReservationModel reservationModel) async {
    try {
      _isLoading.value = true;
      final dataItem = PaiementReservationModel(
          reference: reservationModel.id!,
          client: reservationModel.client,
          motif: motifController.text,
          montant: montantController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await paiementReservationStore.insertData(dataItem).then((value) async {
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

  Future submitUpdate(PaiementReservationModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = PaiementReservationModel(
          reference: data.reference,
          client: data.client,
          motif:
              (motifController.text == '') ? data.motif : motifController.text,
          montant: (montantController.text == '')
              ? data.montant
              : montantController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: data.created,
          business: data.business,
          sync: "new",
          async: "new");
      await paiementReservationStore.updateData(dataItem).then((value) {
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
      var dataCloudList = await paiementReservationApi.getAllData();
      dataCloudList.map((e) async {
        if (!paiementReservationList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = PaiementReservationModel(
              reference: e.reference,
              client: e.client,
              motif: e.motif,
              montant: e.montant,
              succursale: e.succursale,
              signature: e.signature,
              created: e.created,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            );
            await paiementReservationStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down paiementReservation ok');
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
