import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wm_com/src/models/rh/agent_count_model.dart';
import 'package:wm_com/src/pages/reservation/controller/dashboard_reservation_controller.dart';

class DashReservationPieWidget extends StatefulWidget {
  const DashReservationPieWidget({Key? key, required this.controller})
      : super(key: key);
  final DashboardReservationController controller;

  @override
  State<DashReservationPieWidget> createState() =>
      _DashReservationPieWidgetState();
}

class _DashReservationPieWidgetState extends State<DashReservationPieWidget> {
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    return SizedBox(
      width: MediaQuery.maybeOf(context)!.size.width / 1.1,
      child: Card(
        elevation: 6,
        child: SfCircularChart(
            enableMultiSelection: true,
            title: ChartTitle(
                text: "Type d'evenements",
                textStyle:
                    headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
            legend: Legend(isVisible: true, isResponsive: true),
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<ReservationPieChartModel, String>(
                  dataSource: widget.controller.reservationPieChartList,
                  xValueMapper: (ReservationPieChartModel data, _) =>
                      data.eventName,
                  yValueMapper: (ReservationPieChartModel data, _) =>
                      data.count)
            ]),
      ),
    );
  }
}
