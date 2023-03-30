import 'package:get/get.dart';
import 'package:wm_com/src/pages/commercial/components/factures/pdf_a6/creance_cart_a6_pdf.dart';
import 'package:wm_com/src/pages/commercial/components/factures/pdf_a6/facture_cart_a6_pdf.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/ravitaillement_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/dashboard/dashboard_com_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/numero_facture_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/gains/gain_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_vente_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/vente_effectue/ventes_effectue_controller.dart';
import 'package:wm_com/src/pages/home/controller/home_controller.dart'; 
import 'package:wm_com/src/pages/restaurants/livraison/controller/dashboard_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/creance_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/facture_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/prod_model_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/table_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/ventes_effectue_livraison_controller.dart';  
import 'package:wm_com/src/pages/restaurants/restaurant/controller/dashboard_rest_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/creance_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/facture_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/prod_model_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/table_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/ventes_effectue_rest_controller.dart'; 
import 'package:wm_com/src/pages/restaurants/terrasse/controller/dashboard_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/creance_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/facture_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/prod_model_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/table_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/ventes_effectue_terrasse_controller.dart'; 
import 'package:wm_com/src/pages/restaurants/vip/controller/dashboard_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/creance_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/facture_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/table_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/ventes_effectue_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/vip_controller.dart'; 

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);

    // Commercial
    Get.lazyPut(() => DashboardComController());
    Get.lazyPut(() => AchatController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => FactureController());
    Get.lazyPut(() => FactureCreanceController());
    Get.lazyPut(() => GainCartController());
    Get.lazyPut(() => HistoryRavitaillementController());
    Get.lazyPut(() => NumeroFactureController());
    Get.lazyPut(() => ProduitModelController());
    Get.lazyPut(() => RavitaillementController());
    Get.lazyPut(() => VenteCartController());
    Get.lazyPut(() => VenteEffectueController());

    // PDF
    Get.lazyPut(() => FactureCartPDFA6());
    Get.lazyPut(() => CreanceCartPDFA6());
 

    // Restauration
    Get.lazyPut(() => DashboardRestController());
    Get.lazyPut(() => ProdModelRestaurantController());
    Get.lazyPut(() => RestaurantController());
    Get.lazyPut(() => TableRestaurantController());
    Get.lazyPut(() => CreanceRestaurantController());
    Get.lazyPut(() => FactureRestaurantController());
    Get.lazyPut(() => VenteEffectueRestController());

    // VIP
    Get.lazyPut(() => DashboardVipController());
    Get.lazyPut(() => ProdModelVipController());
    Get.lazyPut(() => VipController());
    Get.lazyPut(() => TableVipController());
    Get.lazyPut(() => CreanceVipController());
    Get.lazyPut(() => FactureVipController());
    Get.lazyPut(() => VenteEffectueVipController());

    // Terrasse
    Get.lazyPut(() => DashboardTerrasseController());
    Get.lazyPut(() => ProdModelTerrasseController());
    Get.lazyPut(() => TerrasseController());
    Get.lazyPut(() => TableTerrasseController());
    Get.lazyPut(() => CreanceTerrasseController());
    Get.lazyPut(() => FactureTerrasseController());
    Get.lazyPut(() => VenteEffectueTerrasseController());

    // Livraison
    Get.lazyPut(() => DashboardLivraisonController());
    Get.lazyPut(() => ProdModelLivraisonController());
    Get.lazyPut(() => LivraisonController());
    Get.lazyPut(() => TableLivraisonController());
    Get.lazyPut(() => CreanceLivraisonController());
    Get.lazyPut(() => FactureLivraisonController());
    Get.lazyPut(() => VenteEffectueLivraisonController());
  }
}
