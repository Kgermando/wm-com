import 'package:get/get.dart';
import 'package:wm_com/src/pages/screens/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SplashController());
    Get.put<SplashController>(SplashController());
  }
}
