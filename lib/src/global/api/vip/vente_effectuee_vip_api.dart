// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';

class VenteEffectueVipApi extends GetConnect {
  var client = http.Client();

  Future<List<VenteRestaurantModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(venteEffectueeVipUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<VenteRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(VenteRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<VenteRestaurantModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/vente-effectuee-vips/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return VenteRestaurantModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<VenteRestaurantModel> insertData(VenteRestaurantModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addVenteEffectueeVipUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return VenteRestaurantModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(dataItem);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<VenteRestaurantModel> updateData(VenteRestaurantModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/vente-effectuee-vips/update-vente/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return VenteRestaurantModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/vente-effectuee-vips/delete-vente/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
