// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/restaurant/creance_restaurant_model.dart';

class CreanceVipApi extends GetConnect {
  var client = http.Client();

  Future<List<CreanceRestaurantModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(creanceVipUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<CreanceRestaurantModel> data = [];
      for (var u in bodyList) {
        data.add(CreanceRestaurantModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<CreanceRestaurantModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/creance-vips/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return CreanceRestaurantModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<CreanceRestaurantModel> insertData(
      CreanceRestaurantModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addCreanceVipUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return CreanceRestaurantModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(dataItem);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<CreanceRestaurantModel> updateData(
      CreanceRestaurantModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/creance-vips/update-creance/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return CreanceRestaurantModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/creance-vips/delete-creance/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
