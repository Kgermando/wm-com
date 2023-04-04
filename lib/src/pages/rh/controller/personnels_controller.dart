import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:intl/intl.dart';
import 'package:wm_com/src/global/api/rh/personnels_api.dart';
import 'package:wm_com/src/global/api/upload_file_api.dart';
import 'package:wm_com/src/global/store/rh/personnel_store.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/models/rh/agent_count_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/utils/country.dart';
import 'package:wm_com/src/utils/dropdown.dart';
import 'package:wm_com/src/utils/fonction_occupe.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/service_affectation.dart';

class PersonnelsController extends GetxController
    with StateMixin<List<AgentModel>> {
  PersonnelStore personnelStore = PersonnelStore();
  PersonnelsApi personnelsApi = PersonnelsApi();
  final ProfilController profilController = Get.find();

  var personnelsList = <AgentModel>[].obs;
  var agentPieChartList = <AgentPieChartModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  List<String> typeContratList = Dropdown().typeContrat;
  List<String> sexeList = Dropdown().sexe;
  List<String> world = Country().world;

  // Service d'affectation
  List<String> servAffectList = ServiceAffectation().serviceAffectationDropdown;
  List<String> fonctionList = FonctionOccupee().fonctionDropdown;

  TextEditingController nomController = TextEditingController();
  TextEditingController postNomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  DateTime? dateNaissanceController;
  TextEditingController lieuNaissanceController = TextEditingController();
  DateTime? dateDebutContratController;
  DateTime? dateFinContratController;
  TextEditingController salaireController = TextEditingController();

  flutter_quill.QuillController competanceController =
      flutter_quill.QuillController.basic();
  // flutter_quill.QuillController experienceController = flutter_quill.QuillController.basic();

  int identifiant = 1;
  String matricule = "";
  String? sexe;
  String? role;
  String? nationalite;
  // String? departement;
  String? typeContrat;
  String? servicesAffectation;
  String? fonctionOccupe;

  final _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  final _isUploadingDone = false.obs;
  bool get isUploadingDone => _isUploadingDone.value;

  final _uploadedFileUrl = ''.obs;
  String get uploadedFileUrl => _uploadedFileUrl.value;

  void uploadFile(String file) async {
    _isUploading.value = true;
    await FileApi().uploadFiled(file).then((value) {
      _uploadedFileUrl.value = value;
      _isUploading.value = false;
      _isUploadingDone.value = true;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getList();
    // agentPieChart();
  }

  // @override
  // void refresh() {
  //   getList();
  //   super.refresh();
  // }

  @override
  void dispose() {
    nomController.dispose();
    postNomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    lieuNaissanceController.dispose();
    salaireController.dispose();

    super.dispose();
  }

  void clear() {
    nomController.clear();
    postNomController.clear();
    prenomController.clear();
    emailController.clear();
    telephoneController.clear();
    adresseController.clear();
    lieuNaissanceController.clear();
    salaireController.clear();
  }

  void getList() async {
    await personnelStore.getAllData().then((response) {
      personnelsList.clear();
      identifiant = response.length + 1;
      personnelsList.addAll(response);
      personnelsList.refresh();
      change(personnelsList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    _isLoading.value = true;
    final data = await personnelStore.getOneData(id);
    _isLoading.value = false;
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await personnelStore.deleteData(id).then((value) {
        clear();
        personnelsList.clear();
        getList();
        // Get.back();
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

  Future submit() async {
    try {
      _isLoading.value = true;
      String prefix = InfoSystem().prefix();
      final date = DateFormat("yy").format(DateTime.now());

      String numero = '';
      if (identifiant < 10) {
        numero = "00$identifiant";
      } else if (identifiant < 99) {
        numero = "0$identifiant";
      } else {
        numero = "$identifiant";
      }
      // var departement = jsonEncode(["Commercial"]);
      var detailPersonnelJson =
          jsonEncode(competanceController.document.toDelta().toJson());
      final agentModel = AgentModel(
          nom: (nomController.text == '') ? '-' : nomController.text,
          postNom:
              (postNomController.text == '') ? '-' : postNomController.text,
          prenom: (prenomController.text == '') ? '-' : prenomController.text,
          email: (emailController.text == '') ? '-' : emailController.text,
          telephone:
              (telephoneController.text == '') ? '-' : telephoneController.text,
          adresse:
              (adresseController.text == '') ? '-' : adresseController.text,
          sexe: (sexe.toString() == '') ? '-' : sexe.toString(),
          role: (role.toString() == '') ? '-' : role.toString(),
          matricule: "${prefix}COM$date-$numero",
          dateNaissance: (dateNaissanceController == null)
              ? DateTime.now()
              : dateNaissanceController!,
          lieuNaissance: (lieuNaissanceController.text == '')
              ? '-'
              : lieuNaissanceController.text,
          nationalite:
              (nationalite.toString() == '') ? '-' : nationalite.toString(),
          typeContrat:
              (typeContrat.toString() == '') ? '-' : typeContrat.toString(),
          departement: "Commercial",
          servicesAffectation: (servicesAffectation.toString() == '')
              ? '-'
              : servicesAffectation.toString(),
          dateDebutContrat: (dateDebutContratController == null)
              ? DateTime.now()
              : dateDebutContratController!,
          dateFinContrat: (dateFinContratController == null)
              ? DateTime.now()
              : dateFinContratController!,
          fonctionOccupe: (fonctionOccupe.toString() == '')
              ? '-'
              : fonctionOccupe.toString(),
          detailPersonnel: detailPersonnelJson,
          statutAgent: 'Inactif',
          createdAt: DateTime.now(),
          photo: (uploadedFileUrl == '')
              ? 'assets/images/avatar.jpg'
              : uploadedFileUrl.toString(),
          salaire:
              (salaireController.text == '') ? '-' : salaireController.text,
          signature: profilController.user.matricule,
          created: DateTime.now(),
          isDelete: 'true',
          business: InfoSystem().business(),
          sync: "new",
          async: "new");
      await personnelStore.insertData(agentModel).then((value) async {
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

  Future submitUpdate(AgentModel personne) async {
    try {
      _isLoading.value = true;
      var detailPersonnelJson =
          jsonEncode(competanceController.document.toDelta().toJson());

      final agentModel = AgentModel(
          id: personne.id,
          nom: (nomController.text == '') ? personne.nom : nomController.text,
          postNom: (postNomController.text == '')
              ? personne.postNom
              : postNomController.text,
          prenom: (prenomController.text == '')
              ? personne.prenom
              : prenomController.text,
          email: (emailController.text == '')
              ? personne.email
              : emailController.text,
          telephone: (telephoneController.text == '')
              ? personne.telephone
              : telephoneController.text,
          adresse: (adresseController.text == '')
              ? personne.adresse
              : adresseController.text,
          sexe: (sexe.toString() == '') ? personne.sexe : sexe.toString(),
          role: (role.toString() == '') ? personne.role : role.toString(),
          matricule: personne.matricule,
          dateNaissance: (dateNaissanceController == null)
              ? personne.dateNaissance
              : dateNaissanceController!,
          lieuNaissance: (lieuNaissanceController.text == '')
              ? personne.lieuNaissance
              : lieuNaissanceController.text,
          nationalite: (nationalite.toString() == '')
              ? personne.nationalite
              : nationalite.toString(),
          typeContrat: (typeContrat.toString() == '')
              ? personne.typeContrat
              : typeContrat.toString(),
          departement: personne.departement,
          servicesAffectation: (servicesAffectation.toString() == '')
              ? personne.servicesAffectation
              : servicesAffectation.toString(),
          dateDebutContrat: (dateDebutContratController == null)
              ? personne.dateDebutContrat
              : dateDebutContratController!,
          dateFinContrat: (dateFinContratController == null)
              ? personne.dateFinContrat
              : dateFinContratController!,
          fonctionOccupe: (fonctionOccupe.toString() == '')
              ? personne.fonctionOccupe
              : fonctionOccupe.toString(),
          detailPersonnel: detailPersonnelJson,
          statutAgent:
              "Inactif", // Modification du profil est automatiquement Inactif
          createdAt: personne.createdAt,
          photo: (uploadedFileUrl == '')
              ? personne.photo
              : uploadedFileUrl.toString(),
          salaire: (salaireController.text == '')
              ? personne.salaire
              : salaireController.text,
          signature: profilController.user.matricule.toString(),
          created: DateTime.now(),
          isDelete: personne.isDelete,
          business: personne.business,
          sync: "update",
          async: "new");
      await personnelStore.updateData(agentModel).then((value) {
        clear();
        personnelsList.clear();
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

  void updateStatus(AgentModel personne, String statutPersonel) async {
    try {
      _isLoading.value = true;
      final agentModel = AgentModel(
          id: personne.id,
          nom: personne.nom,
          postNom: personne.postNom,
          prenom: personne.prenom,
          email: personne.email,
          telephone: personne.telephone,
          adresse: personne.adresse,
          sexe: personne.sexe,
          role: personne.role,
          matricule: personne.matricule,
          dateNaissance: personne.dateNaissance,
          lieuNaissance: personne.lieuNaissance,
          nationalite: personne.nationalite,
          typeContrat: personne.typeContrat,
          departement: personne.departement,
          servicesAffectation: personne.servicesAffectation,
          dateDebutContrat: personne.dateDebutContrat,
          dateFinContrat: personne.dateFinContrat,
          fonctionOccupe: personne.fonctionOccupe,
          detailPersonnel: personne.detailPersonnel,
          statutAgent: statutPersonel,
          createdAt: personne.createdAt,
          photo: personne.photo,
          salaire: personne.salaire,
          signature: personne.signature,
          created: personne.created,
          isDelete: personne.isDelete,
          business: personne.business,
          sync: "update",
          async: "new");
      await personnelStore.updateData(agentModel).then((value) {
        clear();
        Get.back();
        Get.snackbar("Modification du statut effectué!",
            "Le document a bien été mise à jour.",
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

  void isDeleteProfile(AgentModel personne) async {
    try {
      _isLoading.value = true;
      final agentModel = AgentModel(
          id: personne.id,
          nom: personne.nom,
          postNom: personne.postNom,
          prenom: personne.prenom,
          email: personne.email,
          telephone: personne.telephone,
          adresse: personne.adresse,
          sexe: personne.sexe,
          role: personne.role,
          matricule: personne.matricule,
          dateNaissance: personne.dateNaissance,
          lieuNaissance: personne.lieuNaissance,
          nationalite: personne.nationalite,
          typeContrat: personne.typeContrat,
          departement: personne.departement,
          servicesAffectation: personne.servicesAffectation,
          dateDebutContrat: personne.dateDebutContrat,
          dateFinContrat: personne.dateFinContrat,
          fonctionOccupe: personne.fonctionOccupe,
          detailPersonnel: personne.detailPersonnel,
          statutAgent: personne.statutAgent,
          createdAt: personne.createdAt,
          photo: personne.photo,
          salaire: personne.salaire,
          signature: personne.signature,
          created: personne.created,
          isDelete: 'false',
          business: personne.business,
          sync: "update",
          async: "new");
      await personnelStore.updateData(agentModel).then((value) {
        clear();
        Get.back();
        Get.snackbar("Modification du statut effectué!",
            "Le document a bien été mise à jour.",
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
      var dataCloudList = await personnelsApi.getAllData();
      dataCloudList.map((e) async {
        if (!personnelsList.contains(e)) {
          if (dataCloudList.isNotEmpty) {
            final dataItem = AgentModel(
              id: e.id,
              nom: e.nom,
              postNom: e.postNom,
              prenom: e.prenom,
              email: e.email,
              telephone: e.telephone,
              adresse: e.adresse,
              sexe: e.sexe,
              role: e.role,
              matricule: e.matricule,
              dateNaissance: e.dateNaissance,
              lieuNaissance: e.lieuNaissance,
              nationalite: e.nationalite,
              typeContrat: e.typeContrat,
              departement: e.departement,
              servicesAffectation: e.servicesAffectation,
              dateDebutContrat: e.dateDebutContrat,
              dateFinContrat: e.dateFinContrat,
              fonctionOccupe: e.fonctionOccupe,
              detailPersonnel: e.detailPersonnel,
              statutAgent: e.statutAgent,
              createdAt: e.createdAt,
              photo: e.photo,
              salaire: e.salaire,
              signature: e.signature,
              created: e.created,
              isDelete: e.isDelete,
              business: e.business,
              sync: e.sync,
              async: 'saved',
            );
            await personnelStore.insertData(dataItem).then((value) {
              getList();
              if (kDebugMode) {
                print('Sync Down personne ok');
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

  void syncData() async {
    try {
      _isLoading.value = true;
      var dataCloudList = await personnelsApi.getAllData();
      var dataList = personnelsList.where((p0) => p0.sync == "new").toList();
      var dataUpdateList =
          personnelsList.where((p0) => p0.sync == "update").toList();
      if (dataCloudList.isEmpty) {
        if (dataList.isNotEmpty) {
          for (var element in dataList) {
            final dataItem = AgentModel(
              nom: element.nom,
              postNom: element.postNom,
              prenom: element.prenom,
              email: element.email,
              telephone: element.telephone,
              adresse: element.adresse,
              sexe: element.sexe,
              role: element.role,
              matricule: element.matricule,
              dateNaissance: element.dateNaissance,
              lieuNaissance: element.lieuNaissance,
              nationalite: element.nationalite,
              typeContrat: element.typeContrat,
              departement: element.departement,
              servicesAffectation: element.servicesAffectation,
              dateDebutContrat: element.dateDebutContrat,
              dateFinContrat: element.dateFinContrat,
              fonctionOccupe: element.fonctionOccupe,
              statutAgent: element.statutAgent,
              createdAt: element.createdAt,
              salaire: element.salaire,
              signature: element.signature,
              created: element.created,
              isDelete: element.isDelete,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await personnelsApi.insertData(dataItem).then((value) async {
              AgentModel dataModel = dataList
                  .where((p0) => p0.matricule == value.matricule).first;
              final dataItem = AgentModel(
                id: dataModel.id,
                nom: dataModel.nom,
                postNom: dataModel.postNom,
                prenom: dataModel.prenom,
                email: dataModel.email,
                telephone: dataModel.telephone,
                adresse: dataModel.adresse,
                sexe: dataModel.sexe,
                role: dataModel.role,
                matricule: dataModel.matricule,
                dateNaissance: dataModel.dateNaissance,
                lieuNaissance: dataModel.lieuNaissance,
                nationalite: dataModel.nationalite,
                typeContrat: dataModel.typeContrat,
                departement: dataModel.departement,
                servicesAffectation: dataModel.servicesAffectation,
                dateDebutContrat: dataModel.dateDebutContrat,
                dateFinContrat: dataModel.dateFinContrat,
                fonctionOccupe: dataModel.fonctionOccupe,
                statutAgent: dataModel.statutAgent,
                createdAt: dataModel.createdAt,
                salaire: dataModel.salaire,
                signature: dataModel.signature,
                created: dataModel.created,
                isDelete: dataModel.isDelete,
                business: dataModel.business,
                sync: "sync",
                async: dataModel.async,
              );
              await personnelStore.updateData(dataItem).then((value) {
                personnelsList.clear();
                getList();
                if (kDebugMode) {
                  print('Sync up personnelsList ok');
                }
              });
            });
          }
        }
      } else {
        // print('Sync up dataUpdateList $dataUpdateList');
        if (personnelsList.isEmpty) {
          for (var element in dataCloudList) {
            final dataItem = AgentModel(
              nom: element.nom,
              postNom: element.postNom,
              prenom: element.prenom,
              email: element.email,
              telephone: element.telephone,
              adresse: element.adresse,
              sexe: element.sexe,
              role: element.role,
              matricule: element.matricule,
              dateNaissance: element.dateNaissance,
              lieuNaissance: element.lieuNaissance,
              nationalite: element.nationalite,
              typeContrat: element.typeContrat,
              departement: element.departement,
              servicesAffectation: element.servicesAffectation,
              dateDebutContrat: element.dateDebutContrat,
              dateFinContrat: element.dateFinContrat,
              fonctionOccupe: element.fonctionOccupe,
              statutAgent: element.statutAgent,
              createdAt: element.createdAt,
              salaire: element.salaire,
              signature: element.signature,
              created: element.created,
              isDelete: element.isDelete,
              business: element.business,
              sync: "sync",
              async: element.async,
            );
            await personnelStore.insertData(dataItem).then((value) {
              if (kDebugMode) {
                print("download personnelsList ok");
              }
            });
          }
        } else {
          dataCloudList.map((e) async {
            if (dataUpdateList.isNotEmpty) {
              for (var element in dataUpdateList) {
                // print('Sync up stock ${element.sync}');
                if (e.created.millisecondsSinceEpoch ==
                    element.created.millisecondsSinceEpoch) {
                  final dataItem = AgentModel(
                    id: e.id,
                    nom: element.nom,
                    postNom: element.postNom,
                    prenom: element.prenom,
                    email: element.email,
                    telephone: element.telephone,
                    adresse: element.adresse,
                    sexe: element.sexe,
                    role: element.role,
                    matricule: element.matricule,
                    dateNaissance: element.dateNaissance,
                    lieuNaissance: element.lieuNaissance,
                    nationalite: element.nationalite,
                    typeContrat: element.typeContrat,
                    departement: element.departement,
                    servicesAffectation: element.servicesAffectation,
                    dateDebutContrat: element.dateDebutContrat,
                    dateFinContrat: element.dateFinContrat,
                    fonctionOccupe: element.fonctionOccupe,
                    statutAgent: element.statutAgent,
                    createdAt: element.createdAt,
                    salaire: element.salaire,
                    signature: element.signature,
                    created: element.created,
                    isDelete: element.isDelete,
                    business: element.business,
                    sync: "sync",
                    async: element.async,
                  );
                  await personnelsApi.updateData(dataItem).then((value) async {
                    AgentModel dataModel = dataUpdateList
                        .where((p0) => p0.matricule == value.matricule)
                        .first;
                    final dataItem = AgentModel(
                      id: dataModel.id,
                      nom: dataModel.nom,
                      postNom: dataModel.postNom,
                      prenom: dataModel.prenom,
                      email: dataModel.email,
                      telephone: dataModel.telephone,
                      adresse: dataModel.adresse,
                      sexe: dataModel.sexe,
                      role: dataModel.role,
                      matricule: dataModel.matricule,
                      dateNaissance: dataModel.dateNaissance,
                      lieuNaissance: dataModel.lieuNaissance,
                      nationalite: dataModel.nationalite,
                      typeContrat: dataModel.typeContrat,
                      departement: dataModel.departement,
                      servicesAffectation: dataModel.servicesAffectation,
                      dateDebutContrat: dataModel.dateDebutContrat,
                      dateFinContrat: dataModel.dateFinContrat,
                      fonctionOccupe: dataModel.fonctionOccupe,
                      statutAgent: dataModel.statutAgent,
                      createdAt: dataModel.createdAt,
                      salaire: dataModel.salaire,
                      signature: dataModel.signature,
                      created: dataModel.created,
                      isDelete: dataModel.isDelete,
                      business: dataModel.business,
                      sync: "sync",
                      async: dataModel.async,
                    ); 
                    await personnelStore.updateData(dataItem).then((value) {
                      personnelsList.clear();
                      getList();
                      if (kDebugMode) {
                        print('Sync up personnelsList ok');
                      }
                    });
                  });
                }
              }
            }
          }).toList();
        }

        _isLoading.value = false;
      }
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de la synchronisation", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
