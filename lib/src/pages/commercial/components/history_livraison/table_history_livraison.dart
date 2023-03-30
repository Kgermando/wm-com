import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/livraiason_history_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/history_livraison/history_livraison_xlsx.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class TableHistoryLivraison extends StatefulWidget {
  const TableHistoryLivraison(
      {super.key,
      required this.livraisonHistoryList,
      required this.profilController});
  final List<LivraisonHistoryModel> livraisonHistoryList;
  final ProfilController profilController;

  @override
  State<TableHistoryLivraison> createState() => _TableHistoryLivraisonState();
}

class _TableHistoryLivraisonState extends State<TableHistoryLivraison> {
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
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
        // stateManager!.setShowLoading(true);
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleWidget(title: "Historique de Livraisons"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ComRoutes.comBonLivraison);
                    },
                    icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                PrintWidget(onPressed: () {
                  HistoriqueLivraisonXlsx()
                      .exportToExcel(widget.livraisonHistoryList);
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
            } else if (column.field == 'remise') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'qtyRemise') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'margeBenRemise') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'qtyLivre') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'succursale') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'signature') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            } else if (column.field == 'created') {
              return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
      createFooter: (stateManager) {
        stateManager.setPageSize(20, notify: true); // default 40
        return PlutoPagination(stateManager);
      },
    );
  }

  Future<List<PlutoRow>> agentsRow() async {
    var dataList = widget.livraisonHistoryList
        .where((element) =>
            element.succursale == widget.profilController.user.succursale ||
            int.parse(widget.profilController.user.role) <= 2)
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
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.quantity))} ${item.unite}"),
        'quantityAchat': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.quantityAchat))} ${item.unite}"),
        'priceAchatUnit': PlutoCell(
            value:
                '${NumberFormat.decimalPattern('fr').format(double.parse(item.priceAchatUnit))} ${monnaieStorage.monney}'),
        'prixVenteUnit': PlutoCell(
            value:
                '${NumberFormat.decimalPattern('fr').format(double.parse(item.prixVenteUnit))} ${monnaieStorage.monney}'),
        'margeBen': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.margeBen))} ${monnaieStorage.monney}"),
        'tva': PlutoCell(value: "${item.tva} %"),
        'remise': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.remise))} ${monnaieStorage.monney}"),
        'qtyRemise': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.qtyRemise))} ${item.unite}"),
        'margeBenRemise': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.margeBenRemise))} ${monnaieStorage.monney}"),
        'qtyLivre': PlutoCell(
            value:
                "${NumberFormat.decimalPattern('fr').format(double.parse(item.qtyLivre))} ${item.unite}"),
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
        width: 300,
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
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
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'TVA',
        field: 'tva',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Remise',
        field: 'remise',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Qtés avec Remise',
        field: 'qtyRemise',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Marge Benefiaire avec Remise',
        field: 'margeBenRemise',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
        width: 250,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Qtés Livré',
        field: 'qtyLivre',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
          );
        },
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
