import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/models/restaurant/restaurant_model.dart';

class TableFactureVipCart extends StatefulWidget {
  const TableFactureVipCart({Key? key, required this.factureList})
      : super(key: key);
  final List<RestaurantModel> factureList;

  @override
  State<TableFactureVipCart> createState() => _TableFactureVipCartState();
}

class _TableFactureVipCartState extends State<TableFactureVipCart> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  DaviModel<RestaurantModel>? _model;

  @override
  void initState() {
    super.initState();
    List<RestaurantModel> rows = List.generate(
        widget.factureList.length, (index) => widget.factureList[index]);
    _model = DaviModel<RestaurantModel>(
        rows: rows,
        columns: [
          DaviColumn(
              name: 'Quantité',
              width: 200,
              stringValue: (row) =>
                  "${NumberFormat.decimalPattern('fr').format(double.parse(row.qty))} ${row.unite}"),
          DaviColumn(
              name: 'Designation',
              width: 300,
              stringValue: (row) => row.identifiant),
          DaviColumn(
              name: 'Prix de Vente',
              width: 200,
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              stringValue: (row) {
                return "${NumberFormat.decimalPattern('fr').format(double.parse(row.price))} ${monnaieStorage.monney}";
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
                total += double.parse(row.qty) * double.parse(row.price);
                return "${NumberFormat.decimalPattern('fr').format(total)} ${monnaieStorage.monney}";
              }),
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
          child: Davi<RestaurantModel>(
            _model,
          ),
        ),
      ),
    );
  }
}
