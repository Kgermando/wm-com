import 'package:get/get.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MonnaieStorage>(MonnaieStorage());
  }
}
