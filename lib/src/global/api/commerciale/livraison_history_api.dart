// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/livraiason_history_model.dart';
import 'package:http/http.dart' as http;

class LivraisonHistoryApi extends GetConnect {
  var client = http.Client();

  Future<List<LivraisonHistoryModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(historyLivraisonUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<LivraisonHistoryModel> data = [];
      for (var u in bodyList) {
        data.add(LivraisonHistoryModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<LivraisonHistoryModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/history-livraisons/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return LivraisonHistoryModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<LivraisonHistoryModel> insertData(
      LivraisonHistoryModel livraisonHistoryModel) async {
    Map<String, String> header = headers;

    var data = livraisonHistoryModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addHistoryLivraisonUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return LivraisonHistoryModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(livraisonHistoryModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<LivraisonHistoryModel> updateData(
      LivraisonHistoryModel livraisonHistoryModel) async {
    Map<String, String> header = headers;

    var data = livraisonHistoryModel.toJson();
    var body = jsonEncode(data);
    var updateUrl =
        Uri.parse("$mainUrl/history-livraisons/update-history_livraison/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return LivraisonHistoryModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl =
        Uri.parse("$mainUrl/history-livraisons/delete-history_livraison/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
