import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wm_com/src/models/restaurant/courbe_vente_gain_restaurant_model.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/dashboard_terrasse_controller.dart';

class CourbeVenteGainYearTerrasse extends StatefulWidget {
  const CourbeVenteGainYearTerrasse(
      {Key? key, required this.controller, required this.monnaieStorage})
      : super(key: key);
  final DashboardTerrasseController controller;
  final MonnaieStorage monnaieStorage;

  @override
  State<CourbeVenteGainYearTerrasse> createState() =>
      _CourbeVenteGainYearTerrasseState();
}

class _CourbeVenteGainYearTerrasseState
    extends State<CourbeVenteGainYearTerrasse> {
  TooltipBehavior? _tooltipBehavior;

  bool? isCardView;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p8),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
                isVisible: Responsive.isDesktop(context) ? true : false),
            // Chart title
            title: ChartTitle(
                text: 'Courbe de Ventes annuelle',
                textStyle: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            // Enable legend
            legend: Legend(
                position: Responsive.isDesktop(context)
                    ? LegendPosition.right
                    : LegendPosition.bottom,
                isVisible: true),
            // Enable tooltip
            palette: const [
              Color.fromRGBO(73, 76, 162, 1),
              Color.fromRGBO(51, 173, 127, 1),
              Color.fromRGBO(244, 67, 54, 1)
            ],
            tooltipBehavior: _tooltipBehavior,
            primaryYAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              title: Responsive.isDesktop(context)
                  ? AxisTitle(
                      text: DateFormat("MM-yyyy").format(DateTime.now()))
                  : AxisTitle(),
              numberFormat: Responsive.isDesktop(context)
                  ? NumberFormat.currency(
                      symbol: '${widget.monnaieStorage.monney} ',
                      decimalDigits: 1)
                  : NumberFormat.compactCurrency(symbol: ''),
            ),
            series: <LineSeries>[
              LineSeries<CourbeVenteRestaurantModel, String>(
                name: 'Ventes',
                dataSource: widget.controller.venteYearList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeVenteRestaurantModel ventes, _) {
                  String date = '';
                  if (ventes.created == '1') {
                    date = 'Janvier';
                  } else if (ventes.created == '2') {
                    date = 'Fevrier';
                  } else if (ventes.created == '3') {
                    date = 'Mars';
                  } else if (ventes.created == '4') {
                    date = 'Avril';
                  } else if (ventes.created == '5') {
                    date = 'Mai';
                  } else if (ventes.created == '6') {
                    date = 'Juin';
                  } else if (ventes.created == '7') {
                    date = 'Juillet';
                  } else if (ventes.created == '8') {
                    date = 'Août';
                  } else if (ventes.created == '9') {
                    date = 'Septembre';
                  } else if (ventes.created == '10') {
                    date = 'Octobre';
                  } else if (ventes.created == '11') {
                    date = 'Novembre';
                  } else if (ventes.created == '12') {
                    date = 'Décembre';
                  }
                  return date;
                },
                yValueMapper: (CourbeVenteRestaurantModel ventes, _) =>
                    double.parse(ventes.sum.toStringAsFixed(2)),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ]),
      ),
    );
  }
}
