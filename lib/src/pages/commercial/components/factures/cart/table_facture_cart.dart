import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TableFactureCart extends StatefulWidget {
  const TableFactureCart({Key? key, required this.factureList})
      : super(key: key);
  final List<dynamic> factureList;

  @override
  State<TableFactureCart> createState() => _TableFactureCartState();
}

class _TableFactureCartState extends State<TableFactureCart> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  DaviModel<CartModel>? _model;

  @override
  void initState() {
    super.initState();

    List<CartModel> rows = List.generate(
        widget.factureList.length, (index) => widget.factureList[index]);
    _model = DaviModel<CartModel>(
        rows: rows,
        columns: [
          DaviColumn(
              name: 'Quantité',
              width: 200,
              stringValue: (row) =>
                  "${NumberFormat.decimalPattern('fr').format(double.parse(row.quantityCart))} ${row.unite}"),
          DaviColumn(
              name: 'Designation',
              width: 300,
              stringValue: (row) => row.idProductCart),
          // DaviColumn(
          //     name: 'Prix d\'achat unitaire',
          //     width: 200,
          //     stringValue: (row) =>
          //         "${NumberFormat.decimalPattern('fr').format(double.parse(row.priceAchatUnit))} ${monnaieStorage.monney}"),
          DaviColumn(
              name: 'Prix de Vente ou Remise',
              width: 200,
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              stringValue: (row) {
                return (double.parse(row.quantityCart) >=
                        double.parse(row.qtyRemise))
                    ? "${NumberFormat.decimalPattern('fr').format(double.parse(row.remise))} ${monnaieStorage.monney}"
                    : "${NumberFormat.decimalPattern('fr').format(double.parse(row.priceCart))} ${monnaieStorage.monney}";
              }),

          DaviColumn(
              name: 'Total',
              width: 150,
              headerTextStyle: TextStyle(color: Colors.green[900]!),
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              cellTextStyle: TextStyle(color: Colors.green[700]!),
              cellBackground: (data) => Colors.green[50],
              stringValue: (row) {
                double total = 0;
                var qtyRemise = double.parse(row.qtyRemise);
                var quantity = double.parse(row.quantityCart);
                if (quantity >= qtyRemise) {
                  total +=
                      double.parse(row.remise) * double.parse(row.quantityCart);
                } else {
                  total += double.parse(row.priceCart) *
                      double.parse(row.quantityCart);
                }
                return "${NumberFormat.decimalPattern('fr').format(total)} ${monnaieStorage.monney}";
              }),
          DaviColumn(name: 'TVA', stringValue: (row) => "${row.tva} %"),
        ],
        multiSortEnabled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: SizedBox(
          height: 300,
          child: Davi<CartModel>(
            _model,
          ),
        ),
      ),
    );
  }
}
