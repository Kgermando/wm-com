import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';

class ProdModelXlsx {
  Future<void> exportToExcel(List<ProductModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Identifiant Produits";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables(
        ["Identifiant", "Unite de vente", "Prix", "signature", "created"], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].idProduct,
        dataList[i].unite,
        dataList[i].price,
        dataList[i].signature,
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created)
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
  }
}
