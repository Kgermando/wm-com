// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/mail/mail_model.dart';
import 'package:http/http.dart' as http;

class MailApi extends GetConnect {
  var client = http.Client();

  Future<List<MailModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(mailsUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<MailModel> data = [];
      for (var u in bodyList) {
        data.add(MailModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<MailModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/mails/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return MailModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<MailModel> insertData(MailModel mailModel) async {
    Map<String, String> header = headers;

    var data = mailModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addMailUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return MailModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(mailModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<MailModel> updateData(MailModel mailModel) async {
    Map<String, String> header = headers;

    var data = mailModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/mails/update-mail/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return MailModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/mails/delete-mail/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
