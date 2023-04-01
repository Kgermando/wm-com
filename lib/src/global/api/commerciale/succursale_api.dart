// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/courbe_vente_gain_model.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/commercial/vente_chart_model.dart';
import 'package:wm_com/src/utils/info_system.dart';

class SuccursaleApi extends GetConnect {
  var client = http.Client();

  Future<List<SuccursaleModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(succursalesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<SuccursaleModel> data = [];
      for (var u in bodyList) {
        data.add(SuccursaleModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> insertData(SuccursaleModel succursaleModel) async {
    Map<String, String> header = headers;

    var data = succursaleModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addSuccursalesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(succursaleModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<SuccursaleModel> updateData(SuccursaleModel succursaleModel) async {
    Map<String, String> header = headers;

    var data = succursaleModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/succursales/update-succursale/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return SuccursaleModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/succursales/delete-succursale/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<List<VenteChartModel>> getVenteChart(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/vente-chart/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<VenteChartModel> data = [];
      for (var u in bodyList) {
        data.add(VenteChartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeVenteModel>> getAllDataVenteDay(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/vente-chart-day/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<CourbeVenteModel>> getAllDataVenteMouth(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/vente-chart-month/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<CourbeVenteModel>> getAllDataVenteYear(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/vente-chart-year/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeGainModel>> getAllDataGainDay(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/gain-chart-day/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeGainModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeGainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.body);
    }
  }

  Future<List<CourbeGainModel>> getAllDataGainMouth(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/gain-chart-month/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeGainModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeGainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.body);
    }
  }

  Future<List<CourbeGainModel>> getAllDataGainYear(String name) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/succursales/gain-chart-year/${InfoSystem().business()}/$name");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeGainModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeGainModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
