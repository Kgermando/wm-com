import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wm_com/src/models/restaurant/courbe_vente_gain_restaurant_model.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/dashboard_rest_controller.dart';

class CourbeVenteGainMounthRest extends StatefulWidget {
  const CourbeVenteGainMounthRest(
      {Key? key, required this.controller, required this.monnaieStorage})
      : super(key: key);
  final DashboardRestController controller;
  final MonnaieStorage monnaieStorage;

  @override
  State<CourbeVenteGainMounthRest> createState() =>
      _CourbeVenteGainMounthRestState();
}

class _CourbeVenteGainMounthRestState extends State<CourbeVenteGainMounthRest> {
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
                text: 'Courbe de Ventes mensuelles',
                textStyle: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            // Enable legend
            legend: Legend(position: LegendPosition.bottom, isVisible: true),
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
                dataSource: widget.controller.venteMouthList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeVenteRestaurantModel ventes, _) =>
                    "${ventes.created}/${DateTime.now().month}",
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
