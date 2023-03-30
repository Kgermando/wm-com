import 'package:get/get.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/dashboard_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/creance_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/facture_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/table_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/ventes_effectue_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/vip_controller.dart';

class VipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardVipController());
    Get.lazyPut(() => ProdModelVipController());
    Get.lazyPut(() => VipController());
    Get.lazyPut(() => TableVipController());
    Get.lazyPut(() => CreanceVipController());
    Get.lazyPut(() => FactureVipController());
    Get.lazyPut(() => VenteEffectueVipController());
  }
}
