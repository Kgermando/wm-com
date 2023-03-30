import 'package:get/get.dart';
import 'package:wm_com/src/pages/update/controller/update_controller.dart';

class UpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UpdateController>(UpdateController());
  }
}
