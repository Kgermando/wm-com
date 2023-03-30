import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/factures/table_creance_terrasse.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/factures/table_facture_terrasse.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/creance_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/facture_terrasse_controller.dart';
import 'package:wm_com/src/widgets/loading.dart';

class FactureTerrassePage extends StatefulWidget {
  const FactureTerrassePage({super.key});

  @override
  State<FactureTerrassePage> createState() => _FactureTerrassePageState();
}

class _FactureTerrassePageState extends State<FactureTerrassePage> {
  final FactureTerrasseController controller = Get.find();
  final ProfilController profilController = Get.find();
  final CreanceTerrasseController factureCreanceController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";
  String subTitle = "Factures";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuTerrasse(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuTerrasse())),
            Expanded(
                flex: 5,
                child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                          child: TabBar(
                            physics: const ScrollPhysics(),
                            tabs: [
                              Tab(text: "$title Facture au comptant"),
                              Tab(text: "$title Facture à crédit")
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
                                  (state) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TableFactureTerrasse(
                                            factureList: state!,
                                            controller: controller,
                                            profilController: profilController),
                                      )),
                              factureCreanceController.obx(
                                  onLoading: loadingPage(context),
                                  onEmpty: const Text('Aucune donnée'),
                                  onError: (error) =>
                                      loadingError(context, error!),
                                  (state) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TableCreanceTerrasse(
                                            creanceRestaurantList: state!,
                                            controller:
                                                factureCreanceController,
                                            profilController: profilController),
                                      ))
                            ],
                          ),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
