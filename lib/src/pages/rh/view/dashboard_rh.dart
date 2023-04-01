import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_rh.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/rh/components/dashboard/calendar_widget.dart';
import 'package:wm_com/src/pages/rh/components/dashboard/dash_pie_wdget.dart';
import 'package:wm_com/src/pages/rh/controller/dashboard_rh_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/dash_number_rh_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DashboardRH extends StatefulWidget {
  const DashboardRH({Key? key}) : super(key: key);

  @override
  State<DashboardRH> createState() => _DashboardRHState();
}

class _DashboardRHState extends State<DashboardRH> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final DashobardRHController controller = Get.find();
  final PersonnelsController personnelsController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Ressources Humaines";
  String subTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    // var isMonth = '';
    // final month = DateTime.now().month;

    // if (month == 1) {
    //   isMonth = 'Janvier';
    // } else if (month == 2) {
    //   isMonth = 'Fevrier';
    // } else if (month == 3) {
    //   isMonth = 'Mars';
    // } else if (month == 4) {
    //   isMonth = 'Avril';
    // } else if (month == 5) {
    //   isMonth = 'Mai';
    // } else if (month == 6) {
    //   isMonth = 'Juin';
    // } else if (month == 7) {
    //   isMonth = 'Juillet';
    // } else if (month == 8) {
    //   isMonth = 'Août';
    // } else if (month == 9) {
    //   isMonth = 'Septembre';
    // } else if (month == 10) {
    //   isMonth = 'Octobre';
    // } else if (month == 11) {
    //   isMonth = 'Novembre';
    // } else if (month == 12) {
    //   isMonth = 'Décembre';
    // }
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuRH(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuRH())),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(title: title),
                              const SizedBox(height: p10),
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  Obx(() => DashNumberRHWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(RhRoutes.rhPersonnelsPage);
                                      },
                                      number: '${controller.agentsCount}',
                                      title: 'Total agents',
                                      icon: Icons.group,
                                      color: Colors.blue.shade700)),
                                  Obx(() => DashNumberRHWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(RhRoutes.rhUserActif);
                                      },
                                      number: '${controller.agentActifCount}',
                                      title: 'Agents Actifs',
                                      icon: Icons.person,
                                      color: Colors.green.shade700)),
                                  Obx(() => DashNumberRHWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(RhRoutes.rhPersonnelsPage);
                                      },
                                      number: '${controller.agentInactifCount}',
                                      title: 'Agents inactifs',
                                      icon: Icons.person_off,
                                      color: Colors.red.shade700)),
                                  Obx(() => DashNumberRHWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(RhRoutes.rhPersonnelsPage);
                                      },
                                      number: '${controller.agentFemmeCount}',
                                      title: 'Femmes',
                                      icon: Icons.female,
                                      color: Colors.purple.shade700)),
                                  Obx(() => DashNumberRHWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(RhRoutes.rhPersonnelsPage);
                                      },
                                      number: '${controller.agentHommeCount}',
                                      title: 'Hommes',
                                      icon: Icons.male,
                                      color: Colors.grey.shade700)),
                                ],
                              ),
                              const SizedBox(height: p20),
                              ResponsiveChildWidget(
                                  child1: DashRHPieWidget(
                                      controller: personnelsController),
                                  child2: const CalendarWidget())
                            ]),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
