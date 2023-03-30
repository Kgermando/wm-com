// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:http/http.dart' as http;

class FactureApi extends GetConnect {
  var client = http.Client();

  Future<List<FactureCartModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(facturesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<FactureCartModel> data = [];
      for (var u in bodyList) {
        data.add(FactureCartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<FactureCartModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/factures/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return FactureCartModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<FactureCartModel> insertData(FactureCartModel factureCartModel) async {
    Map<String, String> header = headers;

    var data = factureCartModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addFacturesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return FactureCartModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(factureCartModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<FactureCartModel> updateData(FactureCartModel factureCartModel) async {
    Map<String, String> header = headers;

    var data = factureCartModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/factures/update-facture/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return FactureCartModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/factures/delete-facture/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
