// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/number_facture.dart';
import 'package:http/http.dart' as http;

class NumberFactureApi extends GetConnect {
  var client = http.Client();

  Future<List<NumberFactureModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(numberFactsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<NumberFactureModel> data = [];
      for (var u in bodyList) {
        data.add(NumberFactureModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<NumberFactureModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/number-facts/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return NumberFactureModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<NumberFactureModel> insertData(
      NumberFactureModel numberFactureModel) async {
    Map<String, String> header = headers;

    var data = numberFactureModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addNumberFactsUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return NumberFactureModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(numberFactureModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<NumberFactureModel> updateData(
      NumberFactureModel numberFactureModel) async {
    Map<String, String> header = headers;

    var data = numberFactureModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/number-facts/update-number-fact/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return NumberFactureModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/number-facts/delete-number-fact/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
