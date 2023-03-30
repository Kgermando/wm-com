import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart'; 
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_com/src/pages/auth/controller/change_password_controller.dart';
import 'package:wm_com/src/pages/auth/controller/forgot_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart'; 
import 'package:wm_com/src/pages/home/controller/home_controller.dart';
import 'package:wm_com/src/pages/mailling/controller/mailling_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class LoginController extends GetxController {
  final AuthStore authStore = AuthStore();
  // final UserApi userApi = UserApi();

  GetStorage getStorge = GetStorage();

  final _loadingLogin = false.obs;
  bool get isLoadingLogin => _loadingLogin.value;

  final _loadingLogOut = false.obs;
  bool get loadingLogOut => _loadingLogOut.value;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    matriculeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clear() {
    matriculeController.clear();
    passwordController.clear();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void login() async {
    String? idToken;
    idToken = getStorge.read(InfoSystem.keyIdToken);
    if (kDebugMode) {
      print("login IDUser $idToken");
    }
    // final UsersController usersController = Get.put(UsersController());
    // if (usersController.usersList.isEmpty) {
    //   if (!GetPlatform.isWeb) {
    // bool result = await InternetConnectionChecker().hasConnection;
    //     if (result == true) {
    //         var users = await userApi.getAllData();
    //       var userList =
    //           users.where((element) => element.async == 'async').toList();
    //       if (userList.isNotEmpty) {
    //         for (var element in userList) {
    //           final user = UserModel(
    //             photo: "-",
    //             nom: element.nom,
    //             prenom: element.prenom,
    //             email: element.email,
    //             telephone: element.telephone,
    //             matricule: element.matricule,
    //             departement: element.departement,
    //             servicesAffectation: element.servicesAffectation,
    //             fonctionOccupe: element.fonctionOccupe,
    //             role: element.role,
    //             isOnline: element.isOnline,
    //             createdAt: element.createdAt,
    //             passwordHash: element.passwordHash,
    //             succursale: element.succursale,
    //             business: element.business,
    //             sync: element.sync,
    //             async: 'saved',
    //           );
    //           await usersController.usersStore.insertData(user);
    //         }
    //       }
    //     }
    //   }
    //   if (GetPlatform.isWeb) {
    //     var users = await userApi.getAllData();
    //     var userList =
    //         users.where((element) => element.async == 'async').toList();
    //     if (userList.isNotEmpty) {
    //       for (var element in userList) {
    //         final user = UserModel(
    //           photo: "-",
    //           nom: element.nom,
    //           prenom: element.prenom,
    //           email: element.email,
    //           telephone: element.telephone,
    //           matricule: element.matricule,
    //           departement: element.departement,
    //           servicesAffectation: element.servicesAffectation,
    //           fonctionOccupe: element.fonctionOccupe,
    //           role: element.role,
    //           isOnline: element.isOnline,
    //           createdAt: element.createdAt,
    //           passwordHash: element.passwordHash,
    //           succursale: element.succursale,
    //           business: element.business,
    //           sync: element.sync,
    //           async: 'saved',
    //         );
    //         await usersController.usersStore.insertData(user);
    //       }
    //     }
    //   }

    // }

    final UsersController usersController = Get.put(UsersController());
    if (usersController.usersList.isEmpty) {
      final user = UserModel(
        id: 1,
        photo: "-",
        nom: "admin",
        prenom: "admin",
        email: "admin@eventdrc.com",
        telephone: "0000000000",
        matricule: "admin",
        departement: "Commercial",
        servicesAffectation: "Support",
        fonctionOccupe: "Support",
        role: "1",
        isOnline: "true",
        createdAt: DateTime.parse("2023-01-05T11:30:06.571153Z"),
        passwordHash: "1234",
        succursale: "-",
        business: "ivanna",
        sync: 'new',
        async: 'new',
      );
      usersController.usersStore.insertData(user);
      if (kDebugMode) {
        print("login user $user");
      }
    }
    final form = loginFormKey.currentState!;
    if (form.validate()) {
      try {
        _loadingLogin.value = true;
        await authStore
            .login(matriculeController.text, passwordController.text)
            .then((value) async {
          clear();
          _loadingLogin.value = false;
          if (value) {
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
 

            // Update Version
            // Get.lazyPut(() => UpdateController());

            GetStorage box = GetStorage();
            idToken = box.read(InfoSystem.keyIdToken);

            if (idToken != null) {
              await authStore.getUserId().then((userData) async {
                // box.write('userModel', json.encode(userData));
                // var departement = jsonDecode(userData.departement);
                if (userData.departement == "Commercial") {
                  Get.offAndToNamed(HomeRoutes.home);
                }
                _loadingLogin.value = false;
                Get.snackbar("Authentification réussie",
                    "Bienvenue ${userData.prenom} dans l'interface ${InfoSystem().name()}",
                    backgroundColor: Colors.green,
                    icon: const Icon(Icons.check),
                    snackPosition: SnackPosition.TOP);
              });
            }
          } else {
            _loadingLogin.value = false;
            Get.snackbar("Echec d'authentification",
                "Vérifier votre matricule et mot de passe",
                backgroundColor: Colors.red,
                icon: const Icon(Icons.close),
                snackPosition: SnackPosition.TOP);
          }
        });
      } catch (e) {
        _loadingLogin.value = false;
        Get.snackbar("Erreur lors de la connection", "$e",
            backgroundColor: Colors.red,
            icon: const Icon(Icons.close),
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  Future<void> logout() async {
    try {
      _loadingLogOut.value = true;
      await authStore.logout();
      Get.offAllNamed(UserRoutes.logout);
      Get.snackbar("Déconnexion réussie!", "",
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
      _loadingLogOut.value = false;
    } catch (e) {
      _loadingLogOut.value = false;
      Get.snackbar("Erreur lors de la connection", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.close),
          snackPosition: SnackPosition.TOP);
    }
  }
}
