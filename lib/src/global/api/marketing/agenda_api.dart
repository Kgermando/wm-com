// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';

class AgendaApi extends GetConnect {
  var client = http.Client();

  Future<List<AgendaModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(agendasUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<AgendaModel> data = [];
      for (var u in bodyList) {
        data.add(AgendaModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<AgendaModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/agendas/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AgendaModel> insertData(AgendaModel agendaModel) async {
    Map<String, String> header = headers;

    var data = agendaModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addAgendasUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(agendaModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<AgendaModel> updateData(AgendaModel agendaModel) async {
    Map<String, String> header = headers;

    var data = agendaModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/agendas/update-agenda/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return AgendaModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/agendas/delete-agenda/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
