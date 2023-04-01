import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_reservation.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final ReservationController controller = Get.put(ReservationController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Reservations";
  String subTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuReservation(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuReservation())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (state) => Container(
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
                            TitleWidget(title: "Reservations".toUpperCase()),
                            if (Responsive.isDesktop(context))
                              const SizedBox(height: p20),
                            Expanded(
                              child: Card(
                                child: SfCalendar(
                                  viewNavigationMode: ViewNavigationMode.snap,
                                  view: CalendarView.month,
                                  dataSource: SuivisDataSource(state!),
                                  onTap: (calendarTapDetails) {
                                    Get.toNamed(
                                        ReservationRoutes
                                            .reservationCalendarDetail,
                                        arguments: calendarTapDetails.date);
                                  },
                                  monthViewSettings: const MonthViewSettings(
                                      appointmentDisplayMode:
                                          MonthAppointmentDisplayMode
                                              .appointment),
                                ),
                              ),
                            ),
                          ],
                        )))),
          ],
        ));
  }
}

class SuivisDataSource extends CalendarDataSource {
  SuivisDataSource(List<ReservationModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].createdDay;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].createdDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return Color(int.parse(appointments![index].background));
  }

  // @override
  // bool isAllDay(int index) {
  //   return appointments![index].isAllDay;
  // }
}
