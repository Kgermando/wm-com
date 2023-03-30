// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/models/restaurant/creance_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/restaurant_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class CreanceTerrassePDFA6 extends GetxController {
  generatePdf(
      CreanceRestaurantModel creanceRestaurantModel, String monnaie) async {
    await Printing.layoutPdf(
        onLayout: (format) => _generatePdf(creanceRestaurantModel, monnaie));
  }

  Future<Uint8List> _generatePdf(
      CreanceRestaurantModel creanceRestaurantModel, monnaie) async {
    final pdf = Document();

    final user = await AuthStore().getUserId();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(0.0),
      pageFormat: PdfPageFormat.a6,
      build: (context) => [
        buildInvoiceInfo(creanceRestaurantModel, user, monnaie),
        buildTitle(),
        buildInvoice(creanceRestaurantModel, monnaie),
        Divider(),
        buildTotal(creanceRestaurantModel, monnaie),
        Divider(),
        buildFooter()
      ],
      // footer: (context) => buildFooter(),
    ));

    // return PdfApi.saveDocument(name: 'facture', pdf: pdf);
    return pdf.save();
  }

  static Widget buildInvoiceInfo(CreanceRestaurantModel creanceRestaurantModel,
      UserModel user, String monnaie) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(InfoSystem().nameClient(), style: const TextStyle(fontSize: p10)),
      Text("RCCM: ${InfoSystem().rccm()}",
          style: const TextStyle(fontSize: p8)),
      Text("Tél.: ${InfoSystem().phone()}",
          style: const TextStyle(fontSize: p8)),
      Text("Facture N° ${creanceRestaurantModel.client}",
          style: const TextStyle(fontSize: p8)),
      Text(
          "Date: ${DateFormat("dd/MM/yy HH:mm").format(creanceRestaurantModel.created)}",
          style: const TextStyle(fontSize: p8)),
      Text("Monnaie: $monnaie", style: const TextStyle(fontSize: p8))
    ]);
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'Facture créance'.toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(
      CreanceRestaurantModel creanceRestaurantModel, String monnaie) {
    final headers = ['Qté', 'Designation', 'PVU', 'Montant'];

    List<RestaurantModel> cartItemList = creanceRestaurantModel.cart;
    final data = cartItemList.map((item) {
      double priceTotal = 0;
      priceTotal += double.parse(item.price) * double.parse(item.qty);

      return [
        (NumberFormat.decimalPattern('fr').format(double.parse(item.qty))),
        item.identifiant,
        NumberFormat.decimalPattern('fr').format(double.parse(item.price)),
        (NumberFormat.decimalPattern('fr')
            .format(priceTotal.toStringAsFixed(2))),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellPadding: const EdgeInsets.all(2.0),
      tableWidth: pw.TableWidth.min,
      headerStyle: const TextStyle(fontSize: 7),
      cellStyle: const TextStyle(fontSize: 7),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      // cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight
      },
    );
  }

  static Widget buildTotal(
      CreanceRestaurantModel creanceRestaurantModel, String monnaie) {
    // var tva = 0.0;
    double sumCart = 0;
    List<RestaurantModel> cartItemList = creanceRestaurantModel.cart;
    for (var item in cartItemList) {
      sumCart += double.parse(item.price) * double.parse(item.qty);
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildText(
            title: 'Total',
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            value:
                "${NumberFormat.decimalPattern('fr').format(sumCart.toStringAsFixed(2))} $monnaie",
            unite: true,
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: '', value: InfoSystem().nameAdress()),
          // pw.Text('Merçi.', style: const TextStyle(fontSize: 7),
          //     textAlign: pw.TextAlign.center)
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    const style = TextStyle(fontSize: 7);

    return Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        Text(title, style: style, textAlign: TextAlign.center),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: style, textAlign: TextAlign.center),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    // final style = titleStyle ?? const TextStyle(fontSize: 8);
    const style = TextStyle(fontSize: 8);
    return Container(
      child: pw.Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style, textAlign: TextAlign.left),
          SizedBox(width: 100),
          Text(value, style: style, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
