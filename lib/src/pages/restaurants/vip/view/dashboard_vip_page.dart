import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/dashboard/arcticle_plus_vendus_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/dashboard/courbe_vente_gain_day_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/dashboard/courbe_vente_gain_mounth_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/dashboard/courbe_vente_gain_year_vip.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/dashboard_vip_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/dash_count_widget.dart';
import 'package:wm_com/src/widgets/dash_number_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DashboardVipPage extends StatefulWidget {
  const DashboardVipPage({super.key});

  @override
  State<DashboardVipPage> createState() => _DashboardVipPageState();
}

class _DashboardVipPageState extends State<DashboardVipPage> {
  final DashboardVipController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuVip(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuVip())),
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
                        child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          title: 'Ventes journalières',
                                          icon: Icons.shopping_cart,
                                          color: Colors.green.shade700),
                                      DashNumberWidget(
                                          gestureTapCallback: () {
                                            Get.toNamed(ComRoutes.comCreance);
                                          },
                                          number:
                                              '${NumberFormat.decimalPattern('fr').format(controller.sumDCreance)} ${monnaieStorage.monney}',
                                          title: 'Créances',
                                          icon: Icons.money_off_outlined,
                                          color: Colors.pink.shade700),
                                      DashCountWidget(
                                        title: 'Commande en cours',
                                        count1: controller.tableCommandeCount
                                            .toString(),
                                        count2: controller.tableTotalCount
                                            .toString(),
                                        icon: Icons.table_bar,
                                        color: Colors.blue.shade700,
                                        gestureTapCallback: () {
                                          Get.toNamed(
                                              VipRoutes.tableCommandeVip);
                                        },
                                      ),
                                      DashCountWidget(
                                        title: 'Consommation en cours',
                                        count1: controller
                                            .tableConsommationCount
                                            .toString(),
                                        count2: controller.tableTotalCount
                                            .toString(),
                                        icon: Icons.table_bar,
                                        color: Colors.orange.shade700,
                                        gestureTapCallback: () {
                                          Get.toNamed(
                                              VipRoutes.tableConsommationVip);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ResponsiveChildWidget(
                                    child1: CourbeVenteGainDayVip(
                                      controller: controller,
                                      monnaieStorage: monnaieStorage,
                                    ),
                                    child2: CourbeVenteGainMounthVip(
                                      controller: controller,
                                      monnaieStorage: monnaieStorage,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  CourbeVenteGainYearVip(
                                    controller: controller,
                                    monnaieStorage: monnaieStorage,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ArticlePlusVendusVip(
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
