import 'package:get/get.dart';
import 'package:wm_com/src/pages/rh/controller/dashboard_rh_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';

class PersonnelBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashobardRHController>(DashobardRHController());
    Get.put<PersonnelsController>(PersonnelsController());
    Get.put<UsersController>(UsersController());
  }
}
