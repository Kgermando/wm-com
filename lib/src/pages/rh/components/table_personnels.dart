import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/pages/rh/components/agents_xlsx.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class TablePersonnels extends StatefulWidget {
  const TablePersonnels(
      {Key? key, required this.personnelList, required this.controller})
      : super(key: key);
  final List<AgentModel> personnelList;
  final PersonnelsController controller;

  @override
  State<TablePersonnels> createState() => _TablePersonnelsState();
}

class _TablePersonnelsState extends State<TablePersonnels> {
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

              final AgentModel personne =
                  await widget.controller.detailView(idPlutoRow.value);

              Get.toNamed(RhRoutes.rhPersonnelsDetail, arguments: personne);
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
                  const TitleWidget(title: "Personnels"),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, RhRoutes.rhPersonnelsPage);
                          },
                          icon: Icon(Icons.refresh,
                              color: Colors.green.shade700)),
                      PrintWidget(onPressed: () {
                        AgentXlsx().exportToExcel(widget.personnelList);
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
                  } else if (column.field == 'statutAgent') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'matricule') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'nom') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'postNom') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'prenom') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'email') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'telephone') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'sexe') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'role') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'createdAt') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'departement') {
                    return resolver<PlutoFilterTypeContains>()
                        as PlutoFilterType;
                  } else if (column.field == 'servicesAffectation') {
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
              stateManager.setPageSize(20, notify: false); // default 40
              return PlutoPagination(stateManager);
            },
          ));
  }

  Future<List<PlutoRow>> agentsRow() async {
    var i = widget.personnelList.length;
    List.generate(widget.personnelList.length, (index) {
      var item = widget.personnelList[index];
      return rows.add(PlutoRow(cells: {
        'numero': PlutoCell(value: i--),
        'statutAgent': PlutoCell(value: item.statutAgent),
        'matricule': PlutoCell(value: item.matricule),
        'nom': PlutoCell(value: item.nom),
        'postNom': PlutoCell(value: item.postNom),
        'prenom': PlutoCell(value: item.prenom),
        'email': PlutoCell(value: item.email),
        'telephone': PlutoCell(value: item.telephone),
        'sexe': PlutoCell(value: item.sexe),
        'role': PlutoCell(value: "Niveau ${item.role}"),
        'createdAt':
            PlutoCell(value: DateFormat("dd-MM-yyyy").format(item.createdAt)),
        'departement': PlutoCell(value: item.departement),
        'servicesAffectation': PlutoCell(value: item.servicesAffectation),
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
        title: 'Statut',
        field: 'statutAgent',
        minWidth: 150,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          Color textColor = Colors.black;
          if (rendererContext.cell.value == 'Actif') {
            textColor = Colors.green;
          } else if (rendererContext.cell.value == 'Inactif') {
            textColor = Colors.red;
          }
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Matricule',
        field: 'matricule',
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
        width: 200,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Nom',
        field: 'nom',
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
        title: 'Post-Nom',
        field: 'postNom',
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
        title: 'Prénom',
        field: 'prenom',
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
        title: 'Email',
        field: 'email',
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
        title: 'Télephone',
        field: 'telephone',
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
        title: 'Sexe',
        field: 'sexe',
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
        title: 'Acréditation',
        field: 'role',
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
        title: 'createdAt',
        field: 'createdAt',
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
        title: 'Département',
        field: 'departement',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 250,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Services d\'affectation',
        field: 'servicesAffectation',
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
