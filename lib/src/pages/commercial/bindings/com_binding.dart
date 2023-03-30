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
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_name_controller.dart';

class ComBinding extends Bindings {
  @override
  void dependencies() { 
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

    // Finance
    Get.lazyPut(() => CaisseController()); 
    Get.lazyPut(() => CaisseNameController()); 
 
  }
}
