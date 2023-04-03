import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/controllers/network_controller.dart';
import 'package:wm_com/src/global/api/mails/mails_notify_api.dart';
import 'package:wm_com/src/global/store/commercial/cart_store.dart';
import 'package:wm_com/src/global/store/marketing/agenda_store.dart';
import 'package:wm_com/src/global/store/marketing/annuaire_store.dart';
import 'package:wm_com/src/models/notify/notify_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/numero_facture_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/gains/gain_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/succursale/succursale_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/vente_effectue/ventes_effectue_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_name_controller.dart';
import 'package:wm_com/src/pages/marketing/controller/agenda/agenda_controller.dart';
import 'package:wm_com/src/pages/marketing/controller/annuaire/annuaire_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/creance_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/facture_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/prod_model_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/ventes_effectue_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/creance_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/facture_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/prod_model_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/ventes_effectue_rest_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/creance_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/facture_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/prod_model_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/ventes_effectue_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/creance_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/facture_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/ventes_effectue_vip_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class DepartementNotifyCOntroller extends GetxController {
  Timer? timerCommercial;
  final getStorge = GetStorage();
  final ProfilController profilController = Get.put(ProfilController());
  final NetworkController networkController = Get.put(NetworkController());

  // Commercial
  final AchatController achatController = Get.put(AchatController());
  final SuccursaleController succursaleController = Get.put(SuccursaleController());
  final VenteEffectueController venteEffectueController = Get.put(VenteEffectueController());
  final ProduitModelController produitModelController = Get.put(ProduitModelController());
  final FactureController factureController =
      Get.put(FactureController());
  final FactureCreanceController factureCreanceController =
      Get.put(FactureCreanceController());
  final GainCartController gainCartController =
      Get.put(GainCartController());
  final NumeroFactureController numeroFactureController =
      Get.put(NumeroFactureController());
  final HistoryRavitaillementController historyRavitaillementController =
      Get.put(HistoryRavitaillementController());

  // RH
  final PersonnelsController personnelsController = Get.put(PersonnelsController());
  final UsersController usersController = Get.put(UsersController());

  // Finances
  final CaisseNameController caisseNameController =
      Get.put(CaisseNameController());
  final CaisseController caisseController = Get.put(CaisseController());

    // Reservations
  final ReservationController reservationController =
      Get.put(ReservationController());
  final PaiementReservationController paiementReservationController = Get.put(PaiementReservationController());

  // Marketing
  final AgendaController agendaController =
      Get.put(AgendaController());
  final AnnuaireController annuaireController =
      Get.put(AnnuaireController());


   // Reservations

  //  Livraison
  final CreanceLivraisonController creanceLivraisonController = Get.put(CreanceLivraisonController());
  final FactureLivraisonController factureLivraisonController = Get.put(FactureLivraisonController());
  final ProdModelLivraisonController prodModelLivraisonController = Get.put(ProdModelLivraisonController());
  final VenteEffectueLivraisonController venteEffectueLivraisonController = Get.put(VenteEffectueLivraisonController());
  
  // Restaurant
  final CreanceRestaurantController creanceRestaurantController = Get.put(CreanceRestaurantController());
  final FactureRestaurantController factureRestaurantController = Get.put(FactureRestaurantController());
  final ProdModelRestaurantController prodModelRestaurantController = Get.put(ProdModelRestaurantController());
  final VenteEffectueRestController venteEffectueRestController = Get.put(VenteEffectueRestController());

  // Terrasse
  final CreanceTerrasseController creanceTerrasseController = Get.put(CreanceTerrasseController());
  final FactureTerrasseController factureTerrasseController = Get.put(FactureTerrasseController());
  final ProdModelTerrasseController prodModelTerrasseController =
      Get.put(ProdModelTerrasseController());
  final VenteEffectueTerrasseController venteEffectueTerrasseController =
      Get.put(VenteEffectueTerrasseController());

  // Vip
  final CreanceVipController creanceVipController = Get.put(CreanceVipController());
  final FactureVipController factureVipController = Get.put(FactureVipController());
  final ProdModelVipController prodModelVipController =
      Get.put(ProdModelVipController()); 
  final VenteEffectueVipController venteEffectueVipController = Get.put(VenteEffectueVipController()); 


  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Header
  CartStore cartStore = CartStore();
  MailsNotifyApi mailsNotifyApi = MailsNotifyApi();
  AgendaStore agendaStore = AgendaStore();
  AnnuaireStore annuaireStore = AnnuaireStore();

  // Header
  final _cartItemCount = 0.obs;
  int get cartItemCount => _cartItemCount.value;

  final _mailsItemCount = 0.obs;
  int get mailsItemCount => _mailsItemCount.value;

  final _agendaItemCount = 0.obs;
  int get agendaItemCount => _agendaItemCount.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    getDataNotify();
  }

  @override
  void dispose() {
    timerCommercial!.cancel();
    super.dispose();
  }

  void getDataNotify() async {
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (idToken != null) {
      timerCommercial = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (kDebugMode) {
          print("notify Commercial");
        }
        getCountMail();
        getCountAgenda();
        getCountCart();
      });
    }
  }

  // Header
  void getCountCart() async {
    int count = await cartStore.getCount(profilController.user.matricule);
    _cartItemCount.value = count;
    update();
  }

  void getCountMail() async {
    if (!GetPlatform.isWeb) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        NotifyModel notifySum =
            await mailsNotifyApi.getCount(profilController.user.matricule);
        _mailsItemCount.value = notifySum.count;
      } else {
        NotifyModel notifySum = const NotifyModel(count: 0);
        _mailsItemCount.value = notifySum.count;
      }
    }
    if (!GetPlatform.isWeb) {
      NotifyModel notifySum =
          await mailsNotifyApi.getCount(profilController.user.matricule);
      _mailsItemCount.value = notifySum.count;
    }

    update();
  }

  void getCountAgenda() async {
    int count = await agendaStore.getCount(profilController.user.matricule);
    _agendaItemCount.value = count;
    update();
  }

  void syncData() async {
    _isLoading.value = true;
    print("tap syncData");

    // Commercial
    achatController.syncData();
    succursaleController.syncData();
    venteEffectueController.syncData();
    produitModelController.syncData();
    factureController.syncData();
    factureCreanceController.syncData();
    gainCartController.syncData();
    numeroFactureController.syncData();
    historyRavitaillementController.syncData(); 

    // RH
    personnelsController.syncData(); 
    usersController.syncData();  

    // Finances
    caisseNameController.syncData();  
    caisseController.syncData();   

    // Reservation
    reservationController.syncData();   
    paiementReservationController.syncData();   
 
    // Marketing
    agendaController.syncData();   
    annuaireController.syncData();   

    // Restaurants
    creanceLivraisonController.syncData();
    factureLivraisonController.syncData();
    prodModelLivraisonController.syncData();
    venteEffectueLivraisonController.syncData();

    creanceRestaurantController.syncData();
    factureRestaurantController.syncData();
    prodModelRestaurantController.syncData();
    venteEffectueRestController.syncData();

    creanceTerrasseController.syncData();
    factureTerrasseController.syncData();
    prodModelTerrasseController.syncData();
    
    creanceVipController.syncData();
    factureVipController.syncData();
    prodModelVipController.syncData(); 
    venteEffectueVipController.syncData();

     _isLoading.value = false;
  }
}
