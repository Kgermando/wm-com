// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/gain_model.dart';
import 'package:http/http.dart' as http;

class GainApi extends GetConnect {
  var client = http.Client();

  Future<List<GainModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(gainsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<GainModel> data = [];
      for (var u in bodyList) {
        data.add(GainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<GainModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/gains/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return GainModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<GainModel> insertData(GainModel gainModel) async {
    Map<String, String> header = headers;

    var data = gainModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addGainsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return GainModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(gainModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<GainModel> updateData(GainModel gainModel) async {
    Map<String, String> header = headers;

    var data = gainModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/gains/update-gain/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return GainModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/gains/delete-gain/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
