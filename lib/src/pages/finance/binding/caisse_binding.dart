import 'package:get/get.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_name_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/chart_caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/dashboard/dashboard_finance_controller.dart';

class CaisseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardFinanceController());
    Get.lazyPut(() => ChartCaisseController());
    Get.lazyPut(() => CaisseNameController());
    Get.lazyPut(() => CaisseController());
  }
}
