import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_reservation.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailCalendar extends StatefulWidget {
  const DetailCalendar({super.key, required this.dateTime});
  final DateTime dateTime;

  @override
  State<DetailCalendar> createState() => _DetailCalendarState();
}

class _DetailCalendarState extends State<DetailCalendar> {
  final ReservationController controller = Get.put(ReservationController());
  final ProfilController profilController = Get.find();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Reservations";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title,
          DateFormat("Le dd-MM-yyyy").format(widget.dateTime)),
      drawer: const DrawerMenuReservation(),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton(
              tooltip: "Ajouter une nouvelle reservation",
              child: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed(ReservationRoutes.reservationAdd,
                    arguments: widget.dateTime);
              })
          : FloatingActionButton.extended(
              label: const Text("Ajouter une reservation"),
              tooltip: "Ajouter une nouvelle reservation",
              icon: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed(ReservationRoutes.reservationAdd,
                    arguments: widget.dateTime);
              },
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuReservation())),
          Expanded(
              flex: 5,
              child: controller.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!), (state) {
                List<ReservationModel> reservationList = state!
                    .where((element) =>
                        DateFormat("dd-MM-yyyy").format(element.createdDay) ==
                        DateFormat("dd-MM-yyyy").format(widget.dateTime))
                    .toList();
                return SingleChildScrollView(
                    controller: ScrollController(),
                    physics: const ScrollPhysics(),
                    child: Container(
                        margin: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 0.0 : p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleWidget(
                                    title:
                                        "Reservations du ${DateFormat("dd-MM-yyyy").format(widget.dateTime)}"),
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
                                itemCount: reservationList.length,
                                itemBuilder: (context, index) {
                                  final data = reservationList[index];
                                  return itemReservation(data);
                                }),
                          ],
                        )));
              }))
        ],
      ),
    );
  }

  Widget itemReservation(ReservationModel data) {
    Color color = Colors.blueGrey;

    switch (data.eventName) {
      case 'Mariage':
        color = Colors.pink;
        break;
      case 'Conference':
        color = Colors.green;
        break;
      case 'Formation':
        color = Colors.blue;
        break;
      case 'Campagne':
        color = Colors.orange;
        break;
      case 'Funeraille':
        color = Colors.purple;
        break;
      case 'Autres':
        color = Colors.brown;
        break;
      default:
        Colors.black;
    }
    return Card(
      child: ListTile(
        onTap: () {
          Get.toNamed(ReservationRoutes.reservationDetail, arguments: data);
        },
        title:
            Text(data.eventName, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text("Durée: ${data.dureeEvent}"),
        trailing: Container(width: 25, height: 50, color: color),
      ),
    );
  }
}
