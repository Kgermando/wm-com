import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/components/dashboard/arcticle_plus_vendus.dart';
import 'package:wm_com/src/pages/commercial/components/dashboard/courbe_vente_gain_day.dart';
import 'package:wm_com/src/pages/commercial/components/dashboard/courbe_vente_gain_mounth.dart';
import 'package:wm_com/src/pages/commercial/components/dashboard/courbe_vente_gain_year.dart';
import 'package:wm_com/src/pages/commercial/controller/dashboard/dashboard_com_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_vente_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/dash_number_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DashboardCommPage extends StatefulWidget {
  const DashboardCommPage({super.key});

  @override
  State<DashboardCommPage> createState() => _DashboardCommPageState();
}

class _DashboardCommPageState extends State<DashboardCommPage> {
  final DashboardComController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final VenteCartController venteCartController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuCommercial(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      const BarreConnectionWidget(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GetBuilder(
                            builder: (DashboardComController controller) =>
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleWidget(title: title),
                                      const SizedBox(height: p10),
                                      Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          DashNumberWidget(
                                              gestureTapCallback: () {
                                                Get.toNamed(ComRoutes.comVente);
                                              },
                                              number:
                                                  '${NumberFormat.decimalPattern('fr').format(controller.sumVente)} ${monnaieStorage.monney}',
                                              title: 'Ventes',
                                              icon: Icons.shopping_cart,
                                              color: Colors.purple.shade700),
                                          DashNumberWidget(
                                              gestureTapCallback: () {
                                                Get.toNamed(ComRoutes.comVente);
                                              },
                                              number:
                                                  '${NumberFormat.decimalPattern('fr').format(controller.sumGain)} ${monnaieStorage.monney}',
                                              title: 'Gains',
                                              icon: Icons.grain,
                                              color: Colors.green.shade700),
                                          // DashNumberWidget(
                                          //     gestureTapCallback: () {
                                          //       Get.toNamed(ComRoutes.comCreance);
                                          //     },
                                          //     number:
                                          //         '${NumberFormat.decimalPattern('fr').format(controller.sumDCreance)} ${monnaieStorage.monney}',
                                          //     title: 'Créances',
                                          //     icon: Icons.money_off_outlined,
                                          //     color: Colors.pink.shade700),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      ResponsiveChildWidget(
                                          child1: CourbeVenteGainDay(
                                            controller: controller,
                                            monnaieStorage: monnaieStorage,
                                          ),
                                          child2: CourbeVenteGainMounth(
                                            controller: controller,
                                            monnaieStorage: monnaieStorage,
                                          )),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      CourbeVenteGainYear(
                                        controller: controller,
                                        monnaieStorage: monnaieStorage,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      ArticlePlusVendus(
                                          state: controller.venteChartList,
                                          monnaieStorage: monnaieStorage)
                                    ])),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
