import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';

class ProfilController extends GetxController with StateMixin<UserModel> {
  final AuthStore authStore = AuthStore();
  final getStorge = GetStorage();

  final _loadingProfil = false.obs;
  bool get isLoadingProfil => _loadingProfil.value;

  // late UserModel user;
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

  @override
  void onInit() async {
    _user.value = await userData();
    super.onInit();
    if (kDebugMode) {
      print("Profil user ${user.prenom}");
    }
  }

  Future<UserModel> userData() async {
    var userModel = UserModel(
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
    );

    String? idToken = getStorge.read(InfoSystem.keyIdToken);

    if (idToken != null) {
      _loadingProfil.value = true;
      await authStore.getUserId().then((response) {
        userModel = response;
        if (kDebugMode) {
          print("Profil user ${userModel.prenom}");
        }
        change(userModel, status: RxStatus.success());
        _loadingProfil.value = false;
      }, onError: (err) {
        change(null, status: RxStatus.error(err.toString()));
        _loadingProfil.value = false;
      });
    }

    return userModel;
  }
}
