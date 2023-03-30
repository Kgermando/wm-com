// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/models/rh/agent_count_model.dart';

class ReservationApi extends GetConnect {
  var client = http.Client();

  Future<List<ReservationModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(reservationUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ReservationModel> data = [];
      for (var u in bodyList) {
        data.add(ReservationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<List<ReservationPieChartModel>> getChartPie() async {
    Map<String, String> header = headers;

    var resp = await client.get(reservationChartPieUrl, headers: header);
    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ReservationPieChartModel> data = [];
      for (var row in bodyList) {
        data.add(ReservationPieChartModel.fromJson(row));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ReservationModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/reservations/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ReservationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ReservationModel> insertData(ReservationModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addReservationUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ReservationModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(dataItem);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ReservationModel> updateData(ReservationModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/reservations/update-reservation/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ReservationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/reservations/delete-reservation/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
