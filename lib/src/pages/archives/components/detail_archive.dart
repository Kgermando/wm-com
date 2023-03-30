import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailArchive extends StatefulWidget {
  const DetailArchive({super.key, required this.archiveModel});
  final ArchiveModel archiveModel;

  @override
  State<DetailArchive> createState() => _DetailArchiveState();
}

class _DetailArchiveState extends State<DetailArchive> {
  final ProfilController profilController = Get.find();
  final ArchiveController controller = Get.put(ArchiveController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archive";
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  Future<ArchiveModel> refresh() async {
    final ArchiveModel dataItem =
        await controller.detailView(widget.archiveModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    int userRole = int.parse(profilController.user.role);
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.archiveModel.folderName),
      drawer: const DrawerMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: Responsive.isMobile(context) ? 0.0 : p20,
                      bottom: p8,
                      right: Responsive.isMobile(context) ? 0.0 : p20,
                      left: Responsive.isMobile(context) ? 0.0 : p20,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: p20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: "Archive"),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  refresh().then((value) =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          ArchiveRoutes
                                                              .archivesDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            if (userRole <= 2) editButton(),
                                            if (userRole <= 2) deleteButton()
                                          ],
                                        ),
                                      ],
                                    ),
                                    SelectableText(
                                        DateFormat("dd-MM-yyyy HH:mm").format(
                                            widget.archiveModel.created),
                                        textAlign: TextAlign.start),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: p20),
                            dataWidget()
                          ],
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    int roleUser = int.parse(profilController.user.role);
    int level = int.parse(widget.archiveModel.level);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Nom du Document :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.archiveModel.nomDocument,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.archiveModel.departement,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Description :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.archiveModel.description,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          if (roleUser <= level)
            ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Fichier archivé :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: (widget.archiveModel.fichier == '-')
                  ? const Text('-')
                  : TextButton(
                      onPressed: () {
                        var extension =
                            widget.archiveModel.fichier.split(".").last;
                        if (extension == 'pdf') {
                          Get.toNamed(ArchiveRoutes.archivePdf,
                              arguments: widget.archiveModel.fichier);
                          pdfViewerKey.currentState?.openBookmarkView();
                        }
                        if (extension == 'png' || extension == 'jpg') {
                          Get.toNamed(ArchiveRoutes.archiveImage,
                              arguments: widget.archiveModel.fichier);
                        }
                      },
                      child: Text("Cliquer pour visualiser",
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(color: Colors.red)),
                    ),
            ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Level :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.archiveModel.level,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.archiveModel.signature,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
        ],
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de modifier ceci?',
              style: TextStyle(color: mainColor)),
          content: const Text('Cette action permet de modifier ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(ArchiveRoutes.archivesUpdate,
                    arguments: widget.archiveModel);
                Navigator.pop(context, 'ok');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de supprimer ceci?',
              style: TextStyle(color: Colors.red.shade700)),
          content: const Text(
              'Cette action permet de supprimer définitivement ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:
                  Text('Annuler', style: TextStyle(color: Colors.red.shade700)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.archiveModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
