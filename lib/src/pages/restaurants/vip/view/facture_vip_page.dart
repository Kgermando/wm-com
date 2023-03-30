import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/factures/table_creance_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/factures/table_facture_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/creance_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/factures/facture_vip_controller.dart';
import 'package:wm_com/src/widgets/loading.dart';

class FactureVipPage extends StatefulWidget {
  const FactureVipPage({super.key});

  @override
  State<FactureVipPage> createState() => _FactureVipPageState();
}

class _FactureVipPageState extends State<FactureVipPage> {
  final FactureVipController controller = Get.find();
  final ProfilController profilController = Get.find();
  final CreanceVipController factureCreanceController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Factures";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuVip(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuVip())),
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
                              Tab(text: "Facture au comptant $title"),
                              Tab(text: "Facture à crédit $title")
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
                                        child: TableFactureVip(
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
                                        child: TableCreanceVip(
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
