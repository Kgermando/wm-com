import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/utils/info_system.dart';

class WMBindings extends Bindings {
  final getStorge = GetStorage();
  @override
  void dependencies() async {
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (idToken != null) {
      // Get.put<ProfilController>(ProfilController());
      // Get.put<DepartementNotifyCOntroller>(DepartementNotifyCOntroller());
      // Get.put<UsersController>(UsersController());
      // Commercial
      // Get.lazyPut(() => DashboardComController());

      // Reservation
      // Get.lazyPut(() => ReservationController());
      // Get.lazyPut(() => PaiementReservationController());

      // // RH
      // Get.lazyPut(() => PersonnelsController());
      // Get.lazyPut(() => UsersController());

      // // FINANCES
      // Get.lazyPut(() => CaisseController());
      // Get.lazyPut(() => CaisseNameController());

      // // MARKETING
      // Get.lazyPut(() => AgendaController());
      // Get.lazyPut(() => AnnuaireController());
    }
    // Get.put<LoginController>(LoginController());
    // Get.put<NetworkController>(NetworkController());
    // Get.put<SplashController>(SplashController());
    // Get.lazyPut(() => UpdateController());
  }
}
