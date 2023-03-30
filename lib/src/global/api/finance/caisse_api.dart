// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/finance/caisse_model.dart';
import 'package:wm_com/src/models/finance/chart_multi.dart';

class CaisseApi extends GetConnect {
  var client = http.Client();

  Future<List<CaisseModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(caisseUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CaisseModel> data = [];
      for (var u in bodyList) {
        data.add(CaisseModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<ChartFinanceModel>> getAllDataChart() async {
    Map<String, String> header = headers;

    var resp = await client.get(caisseChartUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ChartFinanceModel> data = [];
      for (var u in bodyList) {
        data.add(ChartFinanceModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CaisseModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/finances/transactions/caisses/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CaisseModel> insertData(CaisseModel caisseModel) async {
    Map<String, String> header = headers;

    var data = caisseModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCaisseUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(caisseModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CaisseModel> updateData(CaisseModel caisseModel) async {
    Map<String, String> header = headers;

    var data = caisseModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/update-transaction-caisse/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CaisseModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse(
        "$mainUrl/finances/transactions/caisses/delete-transaction-caisse/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
