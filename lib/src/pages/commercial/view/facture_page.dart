import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/factures/table_facture.dart';
import 'package:wm_com/src/pages/commercial/components/factures/table_facture_creance.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_com/src/widgets/loading.dart';

class FacturePage extends StatefulWidget {
  const FacturePage({super.key});

  @override
  State<FacturePage> createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  final FactureController controller = Get.find();
  final ProfilController profilController = Get.find();
  final FactureCreanceController factureCreanceController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Factures";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuCommercial(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
            Expanded(
                flex: 5,
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                          child: TabBar(
                            physics: ScrollPhysics(),
                            tabs: [
                              Tab(text: "Facture au comptant"),
                              Tab(text: "Facture à crédit")
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const ScrollPhysics(),
                            children: [
                              controller.obx(
                                  onLoading: loadingPage(context),
                                  onEmpty: const Text('Aucune donnée'),
                                  onError: (error) =>
                                      loadingError(context, error!),
                                  (state) => Container(
                                      margin: EdgeInsets.only(
                                          top: Responsive.isMobile(context)
                                              ? 0.0
                                              : p20,
                                          bottom: p8,
                                          right: Responsive.isDesktop(context)
                                              ? p20
                                              : 0,
                                          left: Responsive.isDesktop(context)
                                              ? p20
                                              : 0),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: TableFacture(
                                          factureList: state!,
                                          controller: controller,
                                          profilController: profilController))),
                              factureCreanceController.obx(
                                  onLoading: loadingPage(context),
                                  onEmpty: const Text('Aucune donnée'),
                                  onError: (error) =>
                                      loadingError(context, error!),
                                  (state) => Container(
                                      margin: EdgeInsets.only(
                                          top: Responsive.isMobile(context)
                                              ? 0.0
                                              : p20,
                                          right: Responsive.isMobile(context)
                                              ? 0.0
                                              : p20,
                                          left: Responsive.isMobile(context)
                                              ? 0.0
                                              : p20,
                                          bottom: p8),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: TableFactureCreance(
                                          creanceFactureList: state!,
                                          controller: factureCreanceController,
                                          profilController: profilController)))
                            ],
                          ),
                        ),
                      ],
                    )))

            // controller.obx(
            //     onLoading: loadingPage(context),
            //     onEmpty: const Text('Aucune donnée'),
            //     onError: (error) => loadingError(context, error!),
            //     (state) => Container(
            //         margin: const EdgeInsets.only(
            //             top: Responsive.isMobile(context) ? 0.0 : p20, right: Responsive.isMobile(context) ? 0.0 : p20, left: Responsive.isMobile(context) ? 0.0 : p20, bottom: p8),
            //         decoration: const BoxDecoration(
            //             borderRadius:
            //                 BorderRadius.all(Radius.circular(20))),
            //         child: TableFacture(
            //             factureList: state!,
            //             controller: controller,
            //             profilController: profilController)))),
          ],
        ));
  }
}
