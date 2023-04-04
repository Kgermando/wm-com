import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';

class VenteEffectueComXlsx {
  Future<void> exportToExcel(String name, List<VenteCartModel> dataList, String money) async {
    try {
      var excel = Excel.createExcel();
      String title = "Rapport de ventes $name";
      Sheet sheetObject = excel[title];
      sheetObject.insertRowIterables([
        "Date",
        "Quantité",
        "Designation",
        "Prix",
        "Prix total",
        "Devise",
        "Signature"
      ], 0);

      for (int i = 0; i < dataList.length; i++) {
        double price = double.parse(dataList[i].priceTotalCart) /
            double.parse(dataList[i].quantityCart);
        List<String> data = [
          DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
          "${dataList[i].quantityCart} ${dataList[i].unite}",
          dataList[i].idProductCart,
          "$price",
          dataList[i].priceTotalCart,
          money,
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
