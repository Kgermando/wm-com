// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/settings/monnaie_model.dart';

class MonnaieApi extends GetConnect {
  var client = http.Client();

  Future<List<MonnaieModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(monnaieUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<MonnaieModel> data = [];
      for (var u in bodyList) {
        data.add(MonnaieModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<MonnaieModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/settings/monnaies/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return MonnaieModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<MonnaieModel> insertData(MonnaieModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addMonnaieUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return MonnaieModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(dataItem);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<MonnaieModel> updateData(MonnaieModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/settings/monnaies/update-monnaie/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return MonnaieModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/settings/monnaies/delete-monnaie/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
