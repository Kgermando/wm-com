// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/finance/caisse_name_model.dart';

class CaisseNameApi extends GetConnect {
  var client = http.Client();
  Future<List<CaisseNameModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(caisseNameUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CaisseNameModel> data = [];
      for (var u in bodyList) {
        data.add(CaisseNameModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CaisseNameModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/finances/transactions/caisses-name/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CaisseNameModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CaisseNameModel> insertData(CaisseNameModel name) async {
    Map<String, String> header = headers;

    var data = name.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCaisseNameUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CaisseNameModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(name);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CaisseNameModel> updateData(CaisseNameModel name) async {
    Map<String, String> header = headers;

    var data = name.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses-name/update-transaction-banque/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CaisseNameModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses-name/delete-transaction-banque/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
