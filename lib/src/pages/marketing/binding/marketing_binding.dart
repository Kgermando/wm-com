import 'package:get/get.dart';
import 'package:wm_com/src/pages/marketing/controller/agenda/agenda_controller.dart';
import 'package:wm_com/src/pages/marketing/controller/annuaire/annuaire_controller.dart';

class MarketingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AgendaController>(AgendaController());
    Get.put<AnnuaireController>(AnnuaireController());
  }
}
