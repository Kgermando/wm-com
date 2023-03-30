// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/restaurant/courbe_vente_gain_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/vente_chart_restaurant_model.dart';

class VenteLivraisonApi extends GetConnect {
  var client = http.Client();

  Future<List<VenteChartRestaurantModel>> getVenteChart() async {
    Map<String, String> header = headers;

    var resp = await client.get(venteChartLivraisonUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<VenteChartRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(VenteChartRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataVenteDay() async {
    Map<String, String> header = headers;

    var resp = await client.get(venteChartDayLivraisonUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataVenteMouth() async {
    Map<String, String> header = headers;

    var resp = await client.get(venteChartMonthsLivraisonUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataVenteYear() async {
    Map<String, String> header = headers;

    var resp = await client.get(venteChartYearsLivraisonUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CourbeVenteRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(CourbeVenteRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }
}
