import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/list_colors.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

Color listColor =
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

class ArchiveFolderPage extends StatefulWidget {
  const ArchiveFolderPage({super.key});

  @override
  State<ArchiveFolderPage> createState() => _ArchiveFolderPageState();
}

class _ArchiveFolderPageState extends State<ArchiveFolderPage> {
  final ArchiveFolderController controller = Get.put(ArchiveFolderController());
  final ArchiveController archiveController = Get.put(ArchiveController());
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archives";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, ""),
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Nouveau dossier"),
          tooltip: "Ajouter Nouveau dossier",
          icon: const Icon(Icons.archive),
          onPressed: () {
            detailAgentDialog(controller);
          },
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenu())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!), (state) {
                  return SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 0.0 : p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: 'Archives'),
                                IconButton(
                                    tooltip: "Actualiser",
                                    onPressed: () {
                                      controller.getList();
                                    },
                                    icon: Icon(Icons.refresh,
                                        color: Colors.green.shade700))
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: p20,
                                      runSpacing: p20,
                                      children:
                                          List.generate(state!.length, (index) {
                                        final data = state[index];
                                        final color = listColors[
                                            index % listColors.length];
                                        return cardFolder(data, color);
                                      })),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }))
          ],
        ));
  }

  Widget cardFolder(ArchiveFolderModel data, Color color) {
    return GestureDetector(
        onDoubleTap: () {
          Get.toNamed(ArchiveRoutes.archiveTable, arguments: data);
        },
        child: archiveController.obx(
            onLoading: loadingPage(context),
            onEmpty: const Icon(Icons.close), (state) {
          int archiveCount =
              state!.where((element) => element.reference == data.id!).length;
          return badges.Badge(
            showBadge: (archiveCount >= 1) ? true : false,
            badgeContent: Text(archiveCount.toString(),
                style: const TextStyle(color: Colors.white)),
            child: Column(
              children: [
                Icon(
                  Icons.folder,
                  color: color,
                  size: 100.0,
                ),
                Text(data.folderName.toUpperCase())
              ],
            ),
          );
        }));
  }

  detailAgentDialog(ArchiveFolderController controller) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text('Nouveau dossier', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Form(
                      key: controller.formKey, child: nomWidget(controller))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.formKey.currentState!;
                    if (form.validate()) {
                      controller.submit();
                      form.reset();
                      Navigator.pop(context, 'ok');
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget nomWidget(ArchiveFolderController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.folderNameController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du dossier',
          ),
          maxLength: 50,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }
}
