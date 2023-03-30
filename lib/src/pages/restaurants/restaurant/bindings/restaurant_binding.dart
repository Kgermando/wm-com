import 'package:get/get.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/dashboard_rest_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/creance_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/facture_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/prod_model_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/table_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/ventes_effectue_rest_controller.dart';

class RestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardRestController());
    Get.lazyPut(() => ProdModelRestaurantController());
    Get.lazyPut(() => RestaurantController());
    Get.lazyPut(() => TableRestaurantController());
    Get.lazyPut(() => CreanceRestaurantController());
    Get.lazyPut(() => FactureRestaurantController());
    Get.lazyPut(() => VenteEffectueRestController());
  }
}
