import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/pages/commercial/components/produit_model/prod_model_xlsx.dart';
import 'package:wm_com/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class TableProduitModel extends StatefulWidget {
  const TableProduitModel(
      {super.key,
      required this.produitModelList,
      required this.controller,
      required this.title});
  final List<ProductModel> produitModelList;
  final ProduitModelController controller;
  final String title;

  @override
  State<TableProduitModel> createState() => _TableProduitModelState();
}

class _TableProduitModelState extends State<TableProduitModel> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  initState() {
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.controller.isLoading
        ? loading()
        : PlutoGrid(
            columns: columns,
            rows: rows,
            onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) async {
              final dataId = tapEvent.row.cells.values;
              final idPlutoRow = dataId.last;

              final ProductModel productionModel =
                  await widget.controller.detailView(idPlutoRow.value);

              Get.toNamed(ComRoutes.comProduitModelDetail,
                  arguments: productionModel);
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager!.setShowColumnFilter(true);
              // stateManager!.setShowLoading(true);
            },
            createHeader: (PlutoGridStateManager header) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: "Produits ${widget.title}"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            widget.controller.getList();
                            Navigator.pushNamed(
                                context, ComRoutes.comProduitModel);
                          },
                          icon: Icon(Icons.refresh,
                              color: Colors.green.shade700)),
                      PrintWidget(onPressed: () {
                        ProdModelXlsx().exportToExcel(widget.produitModelList);
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
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'idProduct') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'identifiant') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'unite') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'created') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'id') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  }
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
            ),
            createFooter: (stateManager) {
              stateManager.setPageSize(20, notify: true); // default 40
              return PlutoPagination(stateManager);
            },
          ));
  }

  Future<List<PlutoRow>> agentsRow() async {
    var i = widget.produitModelList.length;
    List.generate(widget.produitModelList.length, (index) {
      var item = widget.produitModelList[index];
      return rows.add(PlutoRow(cells: {
        'numero': PlutoCell(value: i--),
        'idProduct': PlutoCell(value: item.idProduct),
        'identifiant': PlutoCell(value: item.identifiant),
        'unite': PlutoCell(value: item.unite),
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        width: 300,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Identifiant',
        field: 'identifiant',
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
        title: 'Unité de vente',
        field: 'unite',
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
        title: 'Date',
        field: 'created',
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
