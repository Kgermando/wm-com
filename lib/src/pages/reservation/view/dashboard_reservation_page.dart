import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_reservation.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/reservation/components/dash_reservation_pie_wdget.dart';
import 'package:wm_com/src/pages/reservation/controller/dashboard_reservation_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/dash_number_widget.dart';

class DashboardReservationPage extends StatefulWidget {
  const DashboardReservationPage({super.key});

  @override
  State<DashboardReservationPage> createState() =>
      _DashboardReservationPageState();
}

class _DashboardReservationPageState extends State<DashboardReservationPage> {
  final DashboardReservationController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Reservations";
  String subTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuReservation(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuReservation())),
            Expanded(
                flex: 5,
                child: Obx(() => SingleChildScrollView(
                        child: Column(
                      children: [
                        const BarreConnectionWidget(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  DashNumberWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(
                                            ReservationRoutes.reservation);
                                      },
                                      number:
                                          "${NumberFormat.decimalPattern('fr').format(controller.montantPayE)} ${monnaieStorage.monney}", 
                                      title: 'Total payé',
                                      icon: Icons.shopping_cart,
                                      color: Colors.green.shade700),
                                  DashNumberWidget(
                                      gestureTapCallback: () {
                                        Get.toNamed(
                                            ReservationRoutes.reservation);
                                      },
                                      number:
                                          "${NumberFormat.decimalPattern('fr').format(controller.montantNonPayE)} ${monnaieStorage.monney}", 
                                      title: 'Total reste',
                                      icon: Icons.grain,
                                      color: Colors.purple.shade700),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DashReservationPieWidget(
                                controller: controller,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))),
          ],
        ));
  }
}
