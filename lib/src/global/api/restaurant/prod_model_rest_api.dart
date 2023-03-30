// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_com/src/global/api/header_http.dart';
import 'package:wm_com/src/global/api/route_api.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:http/http.dart' as http;

class ProduitModelRestApi extends GetConnect {
  var client = http.Client();

  Future<List<ProductModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(prodModelRestUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ProductModel> data = [];
      for (var u in bodyList) {
        data.add(ProductModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<ProductModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/prod-mode-rests/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ProductModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ProductModel> insertData(ProductModel productModel) async {
    Map<String, String> header = headers;

    var data = productModel.toJson();
    var body = jsonEncode(data);

    var resp =
        await client.post(addProdModelRestUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ProductModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(productModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<ProductModel> updateData(ProductModel productModel) async {
    Map<String, String> header = headers;

    var data = productModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/prod-mode-rests/update-produit-model/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ProductModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl =
        Uri.parse("$mainUrl/prod-mode-rests/delete-produit-model/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
