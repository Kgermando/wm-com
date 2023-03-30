import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class TableUserActif extends StatefulWidget {
  const TableUserActif(
      {super.key, required this.usersController, required this.state});
  final UsersController usersController;
  final List<UserModel> state;

  @override
  State<TableUserActif> createState() => _TableUserActifState();
}

class _TableUserActifState extends State<TableUserActif> {
  DaviModel<UserModel>? _model;

  @override
  void initState() {
    super.initState();
    List<UserModel> rows =
        List.generate(widget.state.length, (index) => widget.state[index]);
    _model = DaviModel<UserModel>(
        rows: rows,
        columns: [
          DaviColumn(
              name: 'Activé le',
              width: 200,
              stringValue: (row) =>
                  DateFormat("dd-MM-yy HH:mm").format(row.createdAt)),
          DaviColumn(
              name: 'Prenom', width: 150, stringValue: (row) => row.prenom),
          DaviColumn(name: 'Nom', width: 150, stringValue: (row) => row.nom),
          DaviColumn(
              name: 'Matricule',
              width: 150,
              stringValue: (row) => row.matricule),
          DaviColumn(
              name: 'Telephone',
              width: 150,
              stringValue: (row) => row.telephone),
          DaviColumn(
              name: 'Email', width: 150, stringValue: (row) => row.email),
        ],
        multiSortEnabled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleWidget(title: 'Utilisateurs actifs'),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.usersController.getList();
                      Navigator.pushNamed(context, RhRoutes.rhUserActif);
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.green))
            ],
          ),
          const SizedBox(height: p10),
          Expanded(
            child: Obx(() => widget.usersController.isLoading
                ? loading()
                : Davi<UserModel>(
                    _model,
                    columnWidthBehavior: ColumnWidthBehavior.scrollable,
                    onRowTap: (row) async {
                      final UserModel updateModel =
                          await widget.usersController.detailView(row.id!);
                      Get.toNamed(RhRoutes.rhdetailUser,
                          arguments: updateModel);
                    },
                  )),
          ),
        ],
      ),
    );
  }
}
