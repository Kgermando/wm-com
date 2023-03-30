import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sembast/sembast.dart';
import 'package:wm_com/src/global/store/sembast_database.dart';
import 'package:wm_com/src/helpers/get_local_storage.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AuthStore {
  static final AuthStore _singleton = AuthStore._internal();
  factory AuthStore() {
    return _singleton;
  }
  AuthStore._internal();

  static const String tableName = 'users';
  final store = intMapStoreFactory.store(tableName);
  Future<Database> get _db async => await SembastDataBase.instance.database;

  final box = GetStorage();

  Future<bool> login(
      String matriculeController, String passwordHashController) async {
    final finder = Finder(
        filter: Filter.and([
      Filter.equals("business", InfoSystem().business()),
      Filter.equals("matricule", matriculeController),
      Filter.equals("passwordHash", passwordHashController)
    ]));
    final snapshot = await store.find(await _db, finder: finder);
    if (snapshot.isNotEmpty) {
      final user = snapshot.map((e) => UserModel.fromDatabase(e)).first;
      GetLocalStorage().saveIdToken(user.id.toString()); // Id user
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel> getUserId() async {
    String? idToken = box.read(InfoSystem.keyIdToken);
    int id = int.parse(jsonDecode(idToken!));
    if (kDebugMode) {
      print("getUserId store: $id");
    }
    final finder = Finder(filter: Filter.equals('id', id));
    var data = await store.findFirst(await _db, finder: finder);
    late UserModel dataItem = UserModel.fromJson(data!.value);
    return dataItem;
  }

  Future<void> logout() async {
    await box.remove(InfoSystem.keyIdToken);
  }
}
