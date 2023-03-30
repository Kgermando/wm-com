import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/archives/components/archive_table.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ArchiveData extends StatefulWidget {
  const ArchiveData({super.key, required this.archiveFolderModel});
  final ArchiveFolderModel archiveFolderModel;

  @override
  State<ArchiveData> createState() => _ArchiveDataState();
}

class _ArchiveDataState extends State<ArchiveData> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archives";

  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = Get.put(ArchiveController());
    final ArchiveFolderController controllerFolder =
        Get.put(ArchiveFolderController());
    final ProfilController profilController = Get.find();

    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.archiveFolderModel.folderName),
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Ajouter l'archive"),
        tooltip: "Ajouter votre archive",
        icon: const Icon(Icons.send_and_archive),
        onPressed: () {
          Get.toNamed(ArchiveRoutes.addArchives,
              arguments: widget.archiveFolderModel);
        },
      ),
      body: controller.obx(
          onLoading: loadingPage(context),
          onEmpty: const Text('Aucune donnée'),
          onError: (error) => loadingError(context, error!),
          (state) => Row(
                children: [
                  Visibility(
                      visible: !Responsive.isMobile(context),
                      child: const Expanded(flex: 1, child: DrawerMenu())),
                  Expanded(
                      flex: 5,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: Responsive.isMobile(context) ? 0.0 : p20,
                              right: Responsive.isMobile(context) ? 0.0 : p20,
                              left: Responsive.isMobile(context) ? 0.0 : p20,
                              bottom: p8),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TableArchive(
                            archiveFolderModel: widget.archiveFolderModel,
                            controller: controller,
                            controllerFolder: controllerFolder,
                            profilController: profilController,
                          ))),
                ],
              )),
    );
  }
}
