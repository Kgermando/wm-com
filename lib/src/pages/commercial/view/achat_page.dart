import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/components/achats/list_stock.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class AchatPage extends StatefulWidget {
  const AchatPage({super.key});

  @override
  State<AchatPage> createState() => _AchatPageState();
}

class _AchatPageState extends State<AchatPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Stocks";

  @override
  Widget build(BuildContext context) {
    final AchatController controller = Get.find();
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuCommercial(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Entrée stock dans magasin",
                child: const Icon(Icons.add),
                onPressed: () {
                  if (controller.profilController.user.succursale != '-') {
                    Get.toNamed(ComRoutes.comAchatAdd);
                  }
                  if (controller.profilController.user.succursale == '-') {
                    Get.dialog(Text(
                        "Veillez affecter une succursale a votre profil",
                        style: bodyMedium));
                  }
                })
            : FloatingActionButton.extended(
                label: const Text("Entrer stock"),
                tooltip: "Nouveau stock dans magasin",
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (controller.profilController.user.succursale != '-') {
                    Get.toNamed(ComRoutes.comAchatAdd);
                  }
                  if (controller.profilController.user.succursale == '-') {
                    Get.dialog(Text(
                        "Veillez affecter une succursale a votre profil",
                        style: bodyMedium));
                  }
                }),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (state) => Column(
                          children: [
                            const BarreConnectionWidget(),
                            SingleChildScrollView(
                                controller: ScrollController(),
                                physics: const ScrollPhysics(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const TitleWidget(title: "Stocks"),
                                        IconButton(
                                            onPressed: () {
                                              controller.getList();
                                            },
                                            icon: const Icon(Icons.refresh,
                                                color: Colors.green))
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state!.length,
                                        itemBuilder: (context, index) {
                                          final data = state[index];
                                          return ListStock(
                                              achat: data,
                                              role: controller
                                                  .profilController.user.role);
                                        }),
                                  ],
                                )),
                          ],
                        )))
          ],
        ));
  }
}
