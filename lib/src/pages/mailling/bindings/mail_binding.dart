import 'package:get/get.dart';
import 'package:wm_com/src/pages/mailling/controller/mailling_controller.dart';

class MailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MaillingController>(MaillingController());
  }
}
