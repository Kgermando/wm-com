import 'package:get/get.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/history_ravitaillement/history_ravitaillement_xlsx.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableHistoryRavitaillementProduit extends StatefulWidget {
  const TableHistoryRavitaillementProduit(
      {Key? key,
      required this.achatModel,
      required this.historyRavitaillementList})
      : super(key: key);
  final AchatModel achatModel;
  final List<HistoryRavitaillementModel> historyRavitaillementList;

  @override
  State<TableHistoryRavitaillementProduit> createState() =>
      _TableHistoryRavitaillementProduitState();
}

class _TableHistoryRavitaillementProduitState
    extends State<TableHistoryRavitaillementProduit> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final ProfilController profilController = Get.find();

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleWidget(
                  title: (Responsive.isDesktop(context))
                      ? "Historique de Ravitaillements"
                      : "Hist. de Ravitaillements"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ComRoutes.comStockGlobalDetail,
                            arguments: widget.achatModel);
                      },
                      icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                  PrintWidget(onPressed: () {
                    HistoriqueRavitaillementXlsx()
                        .exportToExcel(widget.historyRavitaillementList);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Exportation effectué!"),
                      backgroundColor: Colors.green[700],
                    ));
                  })
                ],
              ),
            ],
          );
        },
        configuration: PlutoGridConfiguration(
          columnFilter: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
            ],
            resolveDefaultColumnFilter: (column, resolver) {
              if (column.field == 'numero') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'idProduct') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'quantity') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'quantityAchat') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'priceAchatUnit') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'prixVenteUnit') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'margeBen') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'tva') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'qtyRavitailler') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'succursale') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'signature') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'created') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              } else if (column.field == 'id') {
                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              }
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            },
          ),
        ),
      ),
    );
  }

  Future<List<PlutoRow>> agentsRow() async {
    var dataList = widget.historyRavitaillementList
        .where((element) => element.idProduct == widget.achatModel.idProduct)
        .toSet()
        .toList();
    var i = dataList.length;
    List.generate(dataList.length, (index) {
      var item = dataList[index];
      return rows.add(PlutoRow(cells: {
        'numero': PlutoCell(value: i--),
        'idProduct': PlutoCell(value: item.idProduct),
        'quantity': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.quantity).toStringAsFixed(2)))} ${item.unite}"),
        'quantityAchat': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.quantityAchat).toStringAsFixed(2)))} ${item.unite}"),
        'priceAchatUnit': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}"),
        'prixVenteUnit': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}"),
        'margeBen': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.margeBen).toStringAsFixed(2)))} ${monnaieStorage.monney}"),
        'tva': PlutoCell(value: item.tva),
        'qtyRavitailler': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(item.qtyRavitailler).toStringAsFixed(2)))} ${item.unite}"),
        'created':
            PlutoCell(value: DateFormat("dd-MM-yy HH:mm").format(item.created)),
        'id': PlutoCell(value: item.id)
      }));
    });
    return rows;
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'N°',
        field: 'numero',
        type: PlutoColumnType.number(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 100,
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
        title: 'Id Produit',
        field: 'idProduct',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Qté',
        field: 'quantity',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Qté d\'Achat',
        field: 'quantityAchat',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Prix d\'Achat Unitaire',
        field: 'priceAchatUnit',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Prix de vente Unitaire',
        field: 'prixVenteUnit',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Marge Benefiaire',
        field: 'margeBen',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'TVA %',
        field: 'tva',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Qté Ravitailler',
        field: 'qtyRavitailler',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Date',
        field: 'created',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Id',
        field: 'id',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 80,
        minWidth: 80,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
      ),
    ];
  }
}
