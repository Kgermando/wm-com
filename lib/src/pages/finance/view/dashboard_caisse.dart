import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_finance.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/finance/components/caisses/chart_caisse.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/chart_caisse_controller.dart';
import 'package:wm_com/src/pages/finance/controller/dashboard/dashboard_finance_controller.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/dashboard_card_widget.dart';

class DashboardCaisse extends StatefulWidget {
  const DashboardCaisse({super.key});

  @override
  State<DashboardCaisse> createState() => _DashboardCaisseState();
}

class _DashboardCaisseState extends State<DashboardCaisse> {
  final DashboardFinanceController controller = Get.find();
  final ChartCaisseController chartCaisseController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Finances";
  String subTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: headerBar(context, scaffoldKey, title, subTitle),
          drawer: const DrawerMenuFinance(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: !Responsive.isMobile(context),
                  child: const Expanded(flex: 1, child: DrawerMenuFinance())),
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
                                    Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      spacing: 12.0,
                                      runSpacing: 12.0,
                                      direction: Axis.horizontal,
                                      children: [
                                        DashboardCardWidget(
                                          gestureTapCallback: () {},
                                          title: 'TOTAL CAISSES',
                                          icon: Icons.shopping_cart_checkout,
                                          montant: '${controller.soldeCaisse}',
                                          color: Colors.purple.shade700,
                                          colorText: Colors.white,
                                        ),
                                        DashboardCardWidget(
                                          gestureTapCallback: () {},
                                          title: 'TOTAL RECETTES',
                                          icon: Icons.savings,
                                          montant:
                                              '${controller.recetteCaisse}',
                                          color: Colors.teal.shade700,
                                          colorText: Colors.white,
                                        ),
                                        DashboardCardWidget(
                                          gestureTapCallback: () {},
                                          title: 'TOTAL DEPENSES',
                                          icon: Icons.money_off,
                                          montant:
                                              '${controller.depensesCaisse}',
                                          color: Colors.red.shade700,
                                          colorText: Colors.white,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Card(
                                        child: ChartCaisse(
                                      chartCaisseController:
                                          chartCaisseController,
                                      monnaieStorage: monnaieStorage,
                                    )),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                  ])),
                        ),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
