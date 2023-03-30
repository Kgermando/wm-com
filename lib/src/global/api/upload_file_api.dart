// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:wm_com/src/global/api/route_api.dart';

class FileApi {
  var client = http.Client();

  Future<String> uploadFiled(String fileName) async {
    String urlApi = '$baseUrl:3000/uploadfile/upload';
    var request = http.MultipartRequest('POST', Uri.parse(urlApi));

    request.files.add(http.MultipartFile('application',
        File(fileName).readAsBytes().asStream(), File(fileName).lengthSync(),
        filename: fileName.split("/").last));
    var res = await request.send();
    // Extract String from Streamed Response
    var responseString = await res.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    return decodedMap['url'];
  }
}
