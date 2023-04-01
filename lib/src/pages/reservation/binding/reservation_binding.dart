import 'package:get/get.dart';
import 'package:wm_com/src/pages/reservation/controller/dashboard_reservation_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/reservation_controller.dart';

class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardReservationController());
    Get.lazyPut(() => ReservationController());
    Get.lazyPut(() => PaiementReservationController());
  }
}
