import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';

class GetLocalStorage extends GetxController {
  GetStorage box = GetStorage();

  final _id = ''.obs;
  String get id => _id.value;

  final _token = ''.obs;
  String get token => _token.value;

  Future<UserModel> read() async {
    final prefs = box.read(InfoSystem.keyUser);
    if (prefs != null) {
      UserModel user = UserModel.fromJson(jsonDecode(prefs));
      return user;
    } else {
      UserModel user = UserModel(
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
          business: '-',
          sync: '-',
          async: '-');
      return user;
    }
  }

  saveUser(value) async {
    box.write(InfoSystem.keyUser, json.encode(value));
  }

  removeUser() async {
    await box.remove(InfoSystem.keyUser);
  }

  // ID User
  getIdToken() {
    // box.read(_keyIdToken);
    final data = box.read(InfoSystem.keyIdToken);
    _id.value = data;
  }

  saveIdToken(value) {
    box.write(InfoSystem.keyIdToken, json.encode(value));
  }

  removeIdToken() {
    box.remove(InfoSystem.keyIdToken);
  }

  // AccessToken
  getAccessToken() {
    final data = box.read(InfoSystem.keyAccessToken);
    _token.value = json.decode(data);
  }

  saveAccessToken(value) {
    box.write(InfoSystem.keyAccessToken, json.encode(value));
  }

  removeAccessToken() {
    box.remove(InfoSystem.keyAccessToken);
  }

  // RefreshToken
  getRefreshToken() {
    box.read(InfoSystem.keyRefreshToken);
  }

  saveRefreshToken(value) {
    box.write(InfoSystem.keyRefreshToken, json.encode(value));
  }

  removeRefreshToken() async {
    box.remove(InfoSystem.keyRefreshToken);
  }

  // Date Islogged
  getDateLogged() {
    box.read(InfoSystem.keyDateLogged);
  }

  saveDateLogged(value) {
    box.write(InfoSystem.keyDateLogged, json.encode(value));
  }

  removeDateLogged() async {
    box.remove(InfoSystem.keyDateLogged);
  }
}
