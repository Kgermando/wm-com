import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:wm_com/src/global/api/auth/auth_api.dart';
// import 'package:wm_com/src/global/api/user/user_api.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/auth/controller/login_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class ChangePasswordController extends GetxController {
  // final AuthApi authController = AuthApi();
  // final UserApi userController = UserApi();
  final LoginController controller = Get.put(LoginController());

  final _user = UserModel(
    nom: '-',
    prenom: '-',
    email: '-',
    telephone: '-',
    matricule: '-',
    departement: '-',
    servicesAffectation: '-',
    fonctionOccupe: '-',
    role: '5',
    isOnline: 'false',
    createdAt: DateTime.now(),
    passwordHash: '-',
    succursale: '-',
    business: InfoSystem().business(),
    sync: '-',
    async: '-',
  ).obs;

  UserModel get user => _user.value;

  final _loadingChangePassword = false.obs;
  bool get isLoadingChangePassword => _loadingChangePassword.value;

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  final TextEditingController changePasswordController =
      TextEditingController();

  @override
  void onClose() {
    changePasswordController.dispose();
    super.onClose();
  }

  // void submitChangePassword() async {
  //   try {
  //     _loadingChangePassword.value = true;
  //     authController.getUserId().then((userModel) async {
  //       _user.value = userModel;
  //       final user = UserModel(
  //           id: userModel.id,
  //           nom: userModel.nom,
  //           prenom: userModel.prenom,
  //           email: userModel.email,
  //           telephone: userModel.telephone,
  //           matricule: userModel.matricule,
  //           departement: userModel.departement,
  //           servicesAffectation: userModel.servicesAffectation,
  //           fonctionOccupe: userModel.fonctionOccupe,
  //           role: userModel.role,
  //           isOnline: userModel.isOnline,
  //           createdAt: userModel.createdAt,
  //           passwordHash: changePasswordController.text,
  //           succursale: userModel.succursale);
  //       await userController.changePassword(user).then((value) {
  //         controller.logout();
  //         Get.snackbar(
  //             "Mot de passe modifié avec succès!", "Vieillez vous reconnectez.",
  //             backgroundColor: Colors.green,
  //             icon: const Icon(Icons.check),
  //             snackPosition: SnackPosition.TOP);
  //       });
  //     });
  //   } catch (e) {
  //     _loadingChangePassword.value = false;
  //     Get.snackbar(
  //       "Une erreur s'est produite",
  //       "$e",
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }
}
