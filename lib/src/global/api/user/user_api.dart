// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/utils/info_system.dart';

class UserApi extends GetConnect {
  var client = http.Client();

  Future<List<UserModel>> getAllData() async {
    Map<String, String> header = headers;

    var userUrl = Uri.parse("$mainUrl/user/users/${InfoSystem().business()}/");
    var resp = await client.get(userUrl, headers: header); // userAllUrl

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<UserModel> data = [];
      for (var u in bodyList) {
        data.add(UserModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<UserModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var userUrl = Uri.parse("$mainUrl/user/$id");
    var resp = await client.get(userUrl, headers: header);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> insertData(UserModel userModel) async {
    Map<String, String> header = headers;

    var data = userModel.toJson(id: 0);
    var body = jsonEncode(data);

    var resp = await client.post(registerUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(userModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<UserModel> updateData(UserModel userModel) async {
    Map<String, String> header = headers;

    var data = userModel.toJson(id: userModel.id!);
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/user/update-user/");

    var resp = await client.put(updateAgentsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<UserModel> changePassword(UserModel userModel) async {
    Map<String, String> header = headers;

    var data = userModel.toJson(id: userModel.id!);
    var body = jsonEncode(data);
    var updateAgentsUrl = Uri.parse("$mainUrl/user/change-password/");

    var resp = await client.put(updateAgentsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteAgentsUrl = Uri.parse("$mainUrl/user/delete-user/$id");
    var res = await client.delete(deleteAgentsUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
