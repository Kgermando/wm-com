import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';

class VenteEffectueTerrasseXlsx {
  Future<void> exportToExcel(List<VenteRestaurantModel> dataList) async {
    try {
      // Create a new Excel Document.
      // final Workbook workbook = Workbook();

      // // Accessing worksheet via index.
      // final Worksheet sheet = workbook.worksheets[0];

      // // Set the text value.
      // sheet.getRangeByName('A1').setText('Hello World!');

      // // Save and dispose the document.
      // final List<int> bytes = workbook.saveAsStream();
      // workbook.dispose();

      var excel = Excel.createExcel();
      String title = "Rapport de ventes";
      Sheet sheetObject = excel[title];
      sheetObject.insertRowIterables([
        "Date",
        "Quantité",
        "Designation",
        "Prix",
        "Prix total",
        "Signature"
      ], 0);

      for (int i = 0; i < dataList.length; i++) {
        double total =
            double.parse(dataList[i].qty) * double.parse(dataList[i].price);
        List<String> data = [
          DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
          "${dataList[i].qty} ${dataList[i].unite}",
          dataList[i].identifiant,
          dataList[i].price,
          "$total",
          dataList[i].signature
        ];
        sheetObject.insertRowIterables(data, i + 1);
      }
      excel.setDefaultSheet(title);
      final dir = await getApplicationDocumentsDirectory();
      final dateTime = DateTime.now();
      final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
      var onValue = excel.encode();
      File('${dir.path}/$title$date.xlsx')
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue!);

      Get.snackbar("Extraction reussie!", "Le document a bien été extrait",
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("Erreur d'extraction", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
