import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class ReservationPDFA6 extends GetxController {
  static generatePdf(
      ReservationModel reservationModel,
      List<PaiementReservationModel> paiementReservation,
      String monnaie) async {
    await Printing.layoutPdf(
        format: PdfPageFormat.a6,
        onLayout: (format) =>
            _generatePdf(reservationModel, paiementReservation, monnaie));
  }

  static Future<Uint8List> _generatePdf(ReservationModel reservationModel,
      List<PaiementReservationModel> paiementReservation, monnaie) async {
    final pdf = Document();

    final user = await AuthStore().getUserId();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(0.0),
      pageFormat: PdfPageFormat.a6,
      build: (context) => [
        buildInvoiceInfo(reservationModel, user, monnaie),
        buildTitle(),
        buildInvoice(reservationModel, monnaie),
        Divider(),
        buildTotal(reservationModel, paiementReservation, monnaie),
        buildFooter()
      ],
      // footer: (context) => buildFooter(),
    ));

    // return PdfApi.saveDocument(name: 'facture', pdf: pdf);
    return pdf.save();
  }

  static Widget buildInvoiceInfo(
      ReservationModel reservationModel, UserModel user, String monnaie) {
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
      ReservationModel reservationModel, String monnaie) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          flex: 1,
          child: Text('Evenement :',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(reservationModel.eventName,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 1,
          child: Text('Client :',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(reservationModel.client,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 1,
          child: Text('Téléphone :',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(reservationModel.telephone,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 2,
          child: Text('Nombre personne :',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(reservationModel.nbrePersonne,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 1,
          child: Text("Durée :",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(reservationModel.dureeEvent,
              textAlign: TextAlign.left, style: const TextStyle(fontSize: 10)),
        ),
      ]),
      Row(children: [
        Expanded(
          flex: 2,
          child: Text("Montant à payé :",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 3,
          child: Text(
              '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(reservationModel.montant).toStringAsFixed(2)))} \$',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 10)),
        ),
      ])
    ]);
  }

  static Widget buildTotal(ReservationModel reservationModel,
      List<PaiementReservationModel> paiementReservation, String monnaie) {
    double total = 0.0;
    for (var element in paiementReservation) {
      total = double.parse(element.montant);
    }
    double reste = double.parse(reservationModel.montant) - total;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(
            title: 'Total payé:',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(total.toStringAsFixed(2)))} \$",
            unite: true,
          ),
          buildText(
            title: 'Reste à payé:',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(reste.toStringAsFixed(2)))} \$",
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
