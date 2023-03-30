import 'package:get/get.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/dashboard_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/creance_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/factures/facture_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/prod_model_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/table_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/ventes_effectue_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/livraison_controller.dart';

class LivraisonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardLivraisonController());
    Get.lazyPut(() => ProdModelLivraisonController());
    Get.lazyPut(() => LivraisonController());
    Get.lazyPut(() => TableLivraisonController());
    Get.lazyPut(() => CreanceLivraisonController());
    Get.lazyPut(() => FactureLivraisonController());
    Get.lazyPut(() => VenteEffectueLivraisonController());
  }
}
