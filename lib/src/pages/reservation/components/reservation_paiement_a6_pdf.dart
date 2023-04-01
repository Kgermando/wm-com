import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class ReservationPaiementPDFA6 extends GetxController {
  static generatePdf(
      PaiementReservationModel paiementReservationModel, String monnaie) async {
    await Printing.layoutPdf(
        format: PdfPageFormat.a6,
        onLayout: (format) => _generatePdf(paiementReservationModel, monnaie));
  }

  static Future<Uint8List> _generatePdf(
      PaiementReservationModel paiementReservationModel, monnaie) async {
    final pdf = Document();

    final user = await AuthStore().getUserId();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(0.0),
      pageFormat: PdfPageFormat.a6,
      build: (context) => [
        buildInvoiceInfo(user, monnaie),
        buildTitle(),
        buildInvoice(paiementReservationModel, monnaie),
        Divider(),
        buildFooter()
      ],
      // footer: (context) => buildFooter(),
    ));

    // return PdfApi.saveDocument(name: 'facture', pdf: pdf);
    return pdf.save();
  }

  static Widget buildInvoiceInfo(UserModel user, String monnaie) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(InfoSystem().nameClient(), style: const TextStyle(fontSize: p10)),
      Text("RCCM: ${InfoSystem().rccm()}",
          style: const TextStyle(fontSize: p8)),
      Text("Tél.: ${InfoSystem().phone()}",
          style: const TextStyle(fontSize: p8)),
      Text("Date: ${DateFormat("dd/MM/yy HH:mm").format(DateTime.now())}",
          style: const TextStyle(fontSize: p8)),
    ]);
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'Facture de reservation'.toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(
      PaiementReservationModel paiementReservationModel, String monnaie) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          flex: 1,
          child: Text('Motif :',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(paiementReservationModel.motif,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 2,
          child: Text("Montant payé :",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(
              '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(paiementReservationModel.montant).toStringAsFixed(2)))} \$',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 10)),
        ),
      ])
    ]);
  }

  static Widget buildFooter() => Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: '', value: InfoSystem().nameAdress()),
          pw.Text('Merçi.',
              style: const TextStyle(fontSize: 7),
              textAlign: pw.TextAlign.center)
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
    const style = TextStyle(fontSize: 14);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: style),
          // SizedBox(width: 100),
          Text(value, style: style, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
