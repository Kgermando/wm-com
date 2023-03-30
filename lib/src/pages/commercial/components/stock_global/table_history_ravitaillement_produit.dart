import 'package:get/get.dart'; 
import 'package:wm_com/src/constants/responsive.dart';
import 'package:flutter/material.dart'; 
import 'package:wm_com/src/global/store/auth/login_store.dart';
import 'package:wm_com/src/global/store/commercial/history_ravitaillement_store.dart'; 
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/history_ravitaillement/history_ravitaillement_xlsx.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableHistoryRavitaillementProduit extends StatefulWidget {
  const TableHistoryRavitaillementProduit(
      {Key? key, required this.stocksGlobalMOdel})
      : super(key: key);
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<TableHistoryRavitaillementProduit> createState() =>
      _TableHistoryRavitaillementProduitState();
}

class _TableHistoryRavitaillementProduitState
    extends State<TableHistoryRavitaillementProduit> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final HistoryRavitaillementController historyRavitaillementController =
      Get.find();
  final ProfilController profilController = Get.find();

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  List<HistoryRavitaillementModel> dataList = [];
  Future<void> getData() async {
    final userModel = await AuthStore().getUserId();
    List<HistoryRavitaillementModel> historyRavitaillements =
        await HistoryRavitaillementStore().getAllData();
    setState(() {
      dataList = historyRavitaillements
          .where((element) =>
              element.succursale == userModel.succursale &&
              element.idProduct == widget.stocksGlobalMOdel.idProduct)
          .toSet()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: Obx(
          () => historyRavitaillementController.isLoading
              ? loading()
              : PlutoGrid(
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
                                      arguments: widget.stocksGlobalMOdel);
                                },
                                icon: Icon(Icons.refresh,
                                    color: Colors.green.shade700)),
                            PrintWidget(onPressed: () {
                              HistoriqueRavitaillementXlsx()
                                  .exportToExcel(dataList);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'idProduct') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'quantity') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'quantityAchat') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'priceAchatUnit') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'prixVenteUnit') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'margeBen') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'tva') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'qtyRavitailler') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'succursale') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'signature') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'created') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        } else if (column.field == 'id') {
                          return resolver<PlutoFilterTypeContains>()
                              as PlutoFilterType;
                        }
                        return resolver<PlutoFilterTypeContains>()
                            as PlutoFilterType;
                      },
                    ),
                  ),
                ),
        ));
  }

  Future<List<PlutoRow>> agentsRow() async {
    var dataList = historyRavitaillementController.historyRavitaillementList
        .where((element) =>
            element.succursale == profilController.user.succursale &&
            element.idProduct == widget.stocksGlobalMOdel.idProduct)
        .toSet()
        .toList();
    var i = dataList.length;
    List.generate(dataList.length, (index) {
      var item = dataList[index];
      return rows.add(PlutoRow(cells: {
        'numero': PlutoCell(value: i--),
        'idProduct': PlutoCell(value: item.idProduct),
        'quantity': PlutoCell(value: '${item.quantity} ${item.unite}'),
        'quantityAchat': PlutoCell(value: item.quantityAchat),
        'priceAchatUnit': PlutoCell(value: item.priceAchatUnit),
        'prixVenteUnit': PlutoCell(value: item.prixVenteUnit),
        'margeBen': PlutoCell(value: item.margeBen),
        'tva': PlutoCell(value: item.tva),
        'qtyRavitailler': PlutoCell(value: item.qtyRavitailler),
        'created':
            PlutoCell(value: DateFormat("dd-MM-yy H:mm").format(item.created)),
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
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Quantité',
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
        title: 'Quantité d\'Achat',
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
        title: 'Prix d\'Achat Unitaire ${monnaieStorage.monney}',
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
        title: 'Prix de vente Unitaire ${monnaieStorage.monney}',
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
        title: 'marge Benefiaire',
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
        title: 'Quantité Ravitailler',
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
