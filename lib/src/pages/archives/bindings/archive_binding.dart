import 'package:get/get.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart'; 
import 'package:wm_com/src/pages/archives/controller/archive_folder_controller.dart';

class ArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArchiveController>(ArchiveController());
    Get.put<ArchiveFolderController>(ArchiveFolderController());
  }
}
