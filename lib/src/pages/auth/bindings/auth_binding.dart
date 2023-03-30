import 'package:get/get.dart';
import 'package:wm_com/src/pages/auth/controller/change_password_controller.dart';
import 'package:wm_com/src/pages/auth/controller/forgot_controller.dart';
import 'package:wm_com/src/pages/auth/controller/login_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ProfilController());
    Get.lazyPut(() => ChangePasswordController());
    Get.lazyPut(() => ForgotPasswordController());
  }
}
