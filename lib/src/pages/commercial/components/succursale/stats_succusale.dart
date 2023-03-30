import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';
import 'package:wm_com/src/models/commercial/creance_cart_model.dart';
import 'package:wm_com/src/models/commercial/gain_model.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';
import 'package:wm_com/src/widgets/button_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class StatsSuccursale extends StatefulWidget {
  const StatsSuccursale({Key? key, required this.succursaleModel})
      : super(key: key);
  final SuccursaleModel succursaleModel;

  @override
  State<StatsSuccursale> createState() => _StatsSuccursaleState();
}

class _StatsSuccursaleState extends State<StatsSuccursale> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  DateTimeRange? dateRange;

  String getPlageDate() {
    if (dateRange == null) {
      return 'Filtre par plage de date';
    } else {
      return '${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}';
    }
  }

  @override
  void initState() {
    // getData();
    getPlageDate();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  // Stocks par succursale
  List<AchatModel> achatList = [];
  // Ventes par succursale
  List<VenteCartModel> venteList = [];
  // Créance par succursale
  List<CreanceCartModel> creanceList = [];
  // Gain par succursale
  List<GainModel> gainList = [];

  // Future<void> getData() async {
  //   List<AchatModel>? dataAchat = await AchatApi().getAllData();
  //   List<CreanceCartModel>? dataCreance =
  //       await CreanceFactureApi().getAllData();
  //   List<VenteCartModel>? dataVente = await VenteCartApi().getAllData();
  //   List<GainModel>? dataGain = await GainApi().getAllData();
  //   if (mounted) {
  //     setState(() {
  //       achatList = dataAchat
  //           .where(
  //               (element) => element.succursale == widget.succursaleModel.name)
  //           .toList();
  //       creanceList = dataCreance
  //           .where(
  //               (element) => element.succursale == widget.succursaleModel.name)
  //           .toList();
  //       venteList = dataVente
  //           .where(
  //               (element) => element.succursale == widget.succursaleModel.name)
  //           .toList();
  //       gainList = dataGain
  //           .where(
  //               (element) => element.succursale == widget.succursaleModel.name)
  //           .toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager!.setShowColumnFilter(true);
            stateManager!.notifyListeners();
          },
          createHeader: (PlutoGridStateManager header) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [],
            );
          },
          configuration: PlutoGridConfiguration(
            columnFilter: PlutoGridColumnFilterConfig(
              filters: const [
                ...FilterHelper.defaultFilters,
              ],
              resolveDefaultColumnFilter: (column, resolver) {
                if (column.field == 'DATE') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'GAIN') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'VENTES') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'CREANCES') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                }
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              },
            ),
          ),
        ));
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'DATE',
        field: 'DATE',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 80,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
      ),
      PlutoColumn(
        readOnly: true,
        title: 'GAIN',
        field: 'GAIN',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          Color textColor = Colors.teal.shade700;
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'VENTES',
        field: 'VENTES',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          Color textColor = Colors.purple;
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'CREANCES',
        field: 'CREANCES',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          Color textColor = Colors.orange;
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    // Gain
    double sumGain = 0;
    var dataGain = gainList.map((e) => e.sum).toList();
    for (var data in dataGain) {
      sumGain += data;
    }

    // Ventes
    double sumVente = 0;
    var dataPriceVente =
        venteList.map((e) => double.parse(e.priceTotalCart)).toList();
    for (var data in dataPriceVente) {
      sumVente += data;
    }

    // Créances
    double sumDCreance = 0;
    // for (var item in creanceList) {
    //   final cartItem = jsonDecode(item.cart) as List;
    //   List<CartModel> cartItemList = [];

    //   for (var element in cartItem) {
    //     cartItemList.add(CartModel.fromJson(element));
    //   }

    //   for (var data in cartItemList) {
    //     if (double.parse(data.quantityCart) >= double.parse(data.qtyRemise)) {
    //       double total =
    //           double.parse(data.remise) * double.parse(data.quantityCart);
    //       sumDCreance += total;
    //     } else {
    //       double total =
    //           double.parse(data.priceCart) * double.parse(data.quantityCart);
    //       sumDCreance += total;
    //     }
    //   }
    // }
    rows = [
      PlutoRow(cells: {
        'DATE': PlutoCell(
            value: dateRange != null
                ? DateFormat('dd/MM/yyyy').format(dateRange!.end)
                : ''),
        'GAIN': PlutoCell(
            value:
                '${NumberFormat.decimalPattern('fr').format(sumGain)} ${monnaieStorage.monney}'),
        'VENTES': PlutoCell(
            value:
                '${NumberFormat.decimalPattern('fr').format(sumVente)} ${monnaieStorage.monney}'),
        'CREANCES': PlutoCell(
            value:
                '${NumberFormat.decimalPattern('fr').format(sumDCreance)} ${monnaieStorage.monney}'),
      })
    ];
  }

  Widget dataRangeFilter() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: ButtonWidget(
        text: getPlageDate(),
        onClicked: () => setState(() {
          pickDateRange(context);
          FocusScope.of(context).requestFocus(FocusNode());
        }),
      ),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}
