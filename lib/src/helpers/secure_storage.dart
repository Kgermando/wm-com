// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorage extends GetxController { 
//   static const _keyFormatPrint = 'formatPrint'; 

//   // Create storage
//   final storage = const FlutterSecureStorage();

//   // Read value
//   Future<String?> getData() async {
//     final data = await storage.read(key: _keyFormatPrint);
//     return data;
//   }

//   // Write value
//   save(value) async {  
//     await storage.write(key: _keyFormatPrint, value: json.encode(value));
//   }

//   remove() async {
//     await storage.delete(key: _keyFormatPrint);
//   }

//   // Delete all
//   removeAll() async {
//     await storage.deleteAll();
//   }
 
// }
