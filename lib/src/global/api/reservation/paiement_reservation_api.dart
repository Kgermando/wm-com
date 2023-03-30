// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';

class PaiementReservationApi extends GetConnect {
  var client = http.Client();

  Future<List<PaiementReservationModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(paiementReservationUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<PaiementReservationModel> data = [];
      for (var u in bodyList) {
        data.add(PaiementReservationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementReservationModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/reservations-paiements/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return PaiementReservationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementReservationModel> insertData(
      PaiementReservationModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addPaiementReservationUrl,
        headers: header, body: body);
    if (resp.statusCode == 200) {
      return PaiementReservationModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(dataItem);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<PaiementReservationModel> updateData(
      PaiementReservationModel dataItem) async {
    Map<String, String> header = headers;

    var data = dataItem.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse(
        "$mainUrl/reservations-paiements/update-reservation-paiement/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return PaiementReservationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse(
        "$mainUrl/reservations-paiements/delete-reservation-paiement/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
