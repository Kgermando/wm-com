import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/controllers/network_controller.dart';
import 'package:wm_com/src/global/api/user/user_api.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_com/src/pages/auth/controller/change_password_controller.dart';
import 'package:wm_com/src/pages/auth/controller/forgot_controller.dart';
import 'package:wm_com/src/pages/auth/controller/login_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart'; 
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_name_controller.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/chart_caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/dashboard/dashboard_finance_controller.dart';
import 'package:wm_com/src/pages/home/controller/home_controller.dart';
import 'package:wm_com/src/pages/mailling/controller/mailling_controller.dart'; 
import 'package:wm_com/src/pages/rh/controller/dashboard_rh_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart'; 
import 'package:wm_com/src/pages/update/controller/update_controller.dart'; 
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class SplashController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  final UsersController usersController = Get.put(UsersController());
  final HomeController homeController = Get.put(HomeController());

  final getStorge = GetStorage();

  @override
  void onReady() {
    super.onReady();
    // getStorge.erase();
    // isBackUp();
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (idToken != null) {
      if (!GetPlatform.isWeb) {
        Get.lazyPut(() => NetworkController());
      }
      Get.lazyPut(() => ProfilController());
      Get.lazyPut(() => HomeController(), fenix: true);
      Get.lazyPut(() => ChangePasswordController());
      Get.lazyPut(() => ForgotPasswordController());

      Get.lazyPut(() => DepartementNotifyCOntroller());

      // Mail
      Get.lazyPut(() => MaillingController());

      // Archive
      Get.lazyPut(() => ArchiveFolderController());
      Get.lazyPut(() => ArchiveController());

      // RH
      Get.put<DashobardRHController>(DashobardRHController());
      Get.put<PersonnelsController>(PersonnelsController());

      

      // FInance
      Get.lazyPut(() => DashboardFinanceController());
      Get.lazyPut(() => ChartCaisseController());
      Get.lazyPut(() => CaisseNameController());
      Get.lazyPut(() => CaisseController());
 

      // Update Version
      if (GetPlatform.isWindows) {
        final NetworkController networkController =
            Get.put(NetworkController());
        if (networkController.connectionStatus == 1) {
          Get.lazyPut(() => UpdateController());
        }
      }

      isLoggIn();
    } else {
      Get.offAllNamed(UserRoutes.login);
    }
  }

  void isLoggIn() async {
    await loginController.authStore.getUserId().then((userData) async {
      if (userData.departement == "Commercial") {
        Get.offAndToNamed(HomeRoutes.home);
      }
    });
  }

  void isBackUp() async {
    final UserApi userApi = UserApi();
    final UsersController usersController = Get.put(UsersController());
    if (usersController.usersList.isEmpty) {
      if (!GetPlatform.isWeb) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          var users = await userApi.getAllData();
          var userList =
              users.where((element) => element.async == 'async').toList();
          if (userList.isNotEmpty) {
            for (var element in userList) {
              for (var e in usersController.usersList) {
                if (element.matricule == e.matricule) {
                  break;
                }
                final user = UserModel(
                  nom: element.nom,
                  prenom: element.prenom,
                  email: element.email,
                  telephone: element.telephone,
                  matricule: element.matricule,
                  departement: element.departement,
                  servicesAffectation: element.servicesAffectation,
                  fonctionOccupe: element.fonctionOccupe,
                  role: element.role,
                  isOnline: element.isOnline,
                  createdAt: element.createdAt,
                  passwordHash: element.passwordHash,
                  succursale: element.succursale,
                  business: element.business,
                  sync: element.sync,
                  async: 'saved',
                );
                await usersController.usersStore.insertData(user).then((value) {
                  if (kDebugMode) {
                    print("A Sync done");
                  }
                });
              }
            }
          }
        }
      }
      if (GetPlatform.isWeb) {
        var users = await userApi.getAllData();
        var userList =
            users.where((element) => element.async == 'async').toList();
        if (userList.isNotEmpty) {
          for (var element in userList) {
            final user = UserModel(
              nom: element.nom,
              prenom: element.prenom,
              email: element.email,
              telephone: element.telephone,
              matricule: element.matricule,
              departement: element.departement,
              servicesAffectation: element.servicesAffectation,
              fonctionOccupe: element.fonctionOccupe,
              role: element.role,
              isOnline: element.isOnline,
              createdAt: element.createdAt,
              passwordHash: element.passwordHash,
              succursale: element.succursale,
              business: element.business,
              sync: element.sync,
              async: 'saved',
            );
            await usersController.usersStore.insertData(user);
          }
        }
      }
    }
  }
}
