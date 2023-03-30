import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_restaurant.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/factures/table_creance_restaurant.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/factures/table_facture_restaurant.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/creance_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/facture_restaurant_controller.dart';
import 'package:wm_com/src/widgets/loading.dart';

class FactureRestPage extends StatefulWidget {
  const FactureRestPage({super.key});

  @override
  State<FactureRestPage> createState() => _FactureRestPageState();
}

class _FactureRestPageState extends State<FactureRestPage> {
  final FactureRestaurantController controller = Get.find();
  final ProfilController profilController = Get.find();
  final CreanceRestaurantController factureCreanceController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Restaurant";
  String subTitle = "Factures";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuRestaurant(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuRestaurant())),
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
                                        child: TableFactureRestaurant(
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
                                        child: TableCreanceRestaurant(
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
