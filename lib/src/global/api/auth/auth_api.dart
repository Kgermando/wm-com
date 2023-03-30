// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_com/src/global/api/auth/api_error.dart';
import 'package:wm_com/src/global/api/auth/token.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/helpers/get_local_storage.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';

class AuthApi extends GetConnect {
  var client = http.Client();

  Future<bool> login(String matricule, String passwordHash) async {
    var data = {
      'business': InfoSystem().business(),
      'matricule': matricule,
      'passwordHash': passwordHash
    };
    var body = jsonEncode(data);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var resp = await client.post(loginUrl, body: body, headers: headers);
    if (resp.statusCode == 200) {
      GetStorage box = GetStorage();
      box.erase();

      Token token = Token.fromJson(json.decode(resp.body));
      // Store the tokens

      // box.write(_keyIdToken, json.encode(token.id.toString())); // Id user
      // box.write(_keyAccessToken, json.encode(token.accessToken)); // accessToken
      // box.write( _keyRefreshToken, json.encode(token.refreshToken)); // refreshToken
      GetLocalStorage().saveIdToken(token.id.toString()); // Id user
      GetLocalStorage().saveAccessToken(token.accessToken);
      GetLocalStorage().saveRefreshToken(token.refreshToken);
      // GetLocalStorage().saveDateLogged(DateTime.now().toIso8601String());
      return true;
    } else {
      // throw ApiError.fromJson(json.decode(resp.body));
      return false;
    }
  }

  // Future<bool> isLoggedIn() async {
  //   String? accessToken = await GetLocalStorage().getAccessToken();
  //   if (accessToken != null && accessToken.isNotEmpty) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> refreshAccessToken() async {
    Map<String, String> header = headers;

    final box = GetStorage();
    String refreshTokenAccess = box.read(InfoSystem.keyRefreshToken);
    String refreshToken = jsonDecode(refreshTokenAccess);
    var data = {'refresh_token': refreshToken};
    var body = jsonEncode(data);
    var resp = await client.post(
      refreshTokenUrl,
      body: body,
      headers: header,
    );
    if (resp.statusCode == 200) {
      Token token = Token.fromJson(json.decode(resp.body));
      GetLocalStorage().saveAccessToken(token.accessToken);
      GetLocalStorage().saveRefreshToken(token.refreshToken);
    } else {
      GetLocalStorage().removeAccessToken();
      GetLocalStorage().removeRefreshToken();
      throw ApiError.fromJson(json.decode(resp.body));
    }
  }

  // A timer to refresh the access token one minute before it expires
  refreshAccessTokenTimer(int time) async {
    var newTime = time - 60000; // Renew 1min before it expires
    await Future.delayed(Duration(milliseconds: newTime));

    try {
      await refreshAccessToken();
    } catch (e) {
      // await refreshAccessToken();
      refreshAccessTokenTimer(time);
      debugPrint('un soucis $e');
    }
  }

  Future<UserModel> getUserInfo() async {
    Map<String, String> header = headers;

    var resp = await client.get(userUrl, headers: header);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<dynamic> getUserId() async {
    Map<String, String> header = headers;
    final box = GetStorage();

    String? idToken = box.read(InfoSystem.keyIdToken);
    int id = int.parse(jsonDecode(idToken!));
    if (kDebugMode) {
      print("getUserId: $id");
    }

    var userIdUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(userIdUrl, headers: header);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 404) {
      box.erase();
      return Get.offAllNamed(UserRoutes.login);
    } else if (resp.statusCode == 403) {
      box.erase();
      return Get.offAllNamed(UserRoutes.login);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<void> logout() async {
    Map<String, String> header = headers;
    try {
      var resp = await client.post(
        logoutUrl,
        headers: header,
      );
      if (resp.statusCode == 200) {
        box.remove(InfoSystem.keyIdToken);
        var idUser = GetLocalStorage().saveIdToken(null);
        GetLocalStorage().removeAccessToken();
        GetLocalStorage().removeRefreshToken();
      }
    } catch (e) {
      throw Exception(['message']);
    }
  }
}
