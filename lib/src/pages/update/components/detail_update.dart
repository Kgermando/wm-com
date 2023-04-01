import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/update/update_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/update/controller/update_controller.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailUpdate extends StatefulWidget {
  const DetailUpdate({super.key, required this.updateModel});
  final UpdateModel updateModel;

  @override
  State<DetailUpdate> createState() => _DetailUpdateState();
}

class _DetailUpdateState extends State<DetailUpdate> {
  final UpdateController controller = Get.put(UpdateController());
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Mise à jours";

  Future<UpdateModel> refresh() async {
    final UpdateModel dataItem =
        await controller.detailView(widget.updateModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar:
            headerBar(context, scaffoldKey, title, widget.updateModel.version),
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
                          left: Responsive.isMobile(context) ? 0.0 : p20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TitleWidget(title: "Mise à jour"),
                                      Column(
                                        children: [
                                          SelectableText(
                                              DateFormat("dd-MM-yyyy HH:mm")
                                                  .format(widget
                                                      .updateModel.created),
                                              textAlign: TextAlign.start),
                                          const SizedBox(height: p20),
                                          Obx(() => (controller.isDownloading)
                                              ? (controller.progressString ==
                                                      "100%")
                                                  ? const Icon(Icons.check,
                                                      size: p20)
                                                  : Obx(() => AutoSizeText(
                                                      controller.progressString,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 16.0)))
                                              : IconButton(
                                                  iconSize: 60,
                                                  tooltip:
                                                      "Télécharger cette version",
                                                  onPressed: () {
                                                    controller
                                                        .downloadNetworkSoftware(
                                                            url: widget
                                                                .updateModel
                                                                .urlUpdate);
                                                  },
                                                  icon: const Icon(
                                                      Icons.download,
                                                      color: Colors.green))),
                                        ],
                                      ),
                                    ],
                                  ),
                                  dataWidget(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: p20,
                          ),
                        ],
                      ),
                    )))
          ],
        ));
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ResponsiveChildWidget(
              child1: Text('Version :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.updateModel.version,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(
            color: mainColor,
          ),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Rapport de la isse à jour :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.updateModel.motif,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(
            color: mainColor,
          ),
        ],
      ),
    );
  }
}
