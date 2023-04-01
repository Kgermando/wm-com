import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wm_com/src/models/commercial/vente_chart_model.dart';
import 'package:wm_com/src/utils/list_colors.dart';

class ArticlePlusVendusSucc extends StatefulWidget {
  const ArticlePlusVendusSucc(
      {Key? key, required this.state, required this.monnaieStorage})
      : super(key: key);
  final List<VenteChartModel> state;
  final MonnaieStorage monnaieStorage;

  @override
  State<ArticlePlusVendusSucc> createState() => _ArticlePlusVendusSuccState();
}

class _ArticlePlusVendusSuccState extends State<ArticlePlusVendusSucc> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return SizedBox(
      height: (Responsive.isDesktop(context)) ? 400 : 300,
      child: Card(
        child: SfCartesianChart(
          title: ChartTitle(
              text: 'Produits les plus vendus',
              textStyle: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          // legend: Legend(
          //     position: Responsive.isDesktop(context)
          //         ? LegendPosition.right
          //         : LegendPosition.bottom,
          //     isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            // VenteChartModel
            BarSeries<VenteChartModel, String>(
                name: 'Produits',
                pointColorMapper: (datum, index) =>
                    listColors[index % listColors.length],
                dataSource: widget.state,
                sortingOrder: SortingOrder.descending,
                xValueMapper: (VenteChartModel gdp, _) => gdp.idProductCart,
                yValueMapper: (VenteChartModel gdp, _) => gdp.count,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true)
          ],
          primaryXAxis: CategoryAxis(
              isVisible: Responsive.isDesktop(context) ? true : false),
          primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(text: '10 produits les plus vendus'),
          ),
        ),
      ),
    );
  }
}
