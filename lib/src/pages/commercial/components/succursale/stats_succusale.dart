import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart'; 
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/dashboard/arcticle_plus_vendus_succ.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/dashboard/courbe_vente_gain_day_succ.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/dashboard/courbe_vente_gain_mounth_succ.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/dashboard/courbe_vente_gain_year_succ.dart';
import 'package:wm_com/src/pages/commercial/controller/succursale/succursale_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/dash_number_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class StatsSuccursale extends StatefulWidget {
  const StatsSuccursale({super.key, required this.succursaleModel});
  final SuccursaleModel succursaleModel;

  @override
  State<StatsSuccursale> createState() => _StatsSuccursaleState();
}

class _StatsSuccursaleState extends State<StatsSuccursale> { 
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final SuccursaleController controller = Get.find(); 
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      physics: const ScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 0.0 : p10),
        child: GetBuilder(
            builder: (SuccursaleController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: widget.succursaleModel.name),
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
                  title: 'Ventes',
                  icon: Icons.shopping_cart,
                  color: Colors.purple.shade700),
              DashNumberWidget(
                  gestureTapCallback: () {
                    Get.toNamed(ComRoutes.comVente);
                  },
                  number:
                      '${NumberFormat.decimalPattern('fr').format(controller.sumGain)} ${monnaieStorage.monney}',
                  title: 'Gains',
                  icon: Icons.grain,
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
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          ResponsiveChildWidget(
              child1: CourbeVenteGainDaySucc(
                controller: controller,
                monnaieStorage: monnaieStorage,
              ),
              child2: CourbeVenteGainMounthSucc(
                controller: controller,
                monnaieStorage: monnaieStorage,
              )),
          const SizedBox(
            height: 20.0,
          ),
          CourbeVenteGainYearSucc(
            controller: controller,
            monnaieStorage: monnaieStorage,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ArticlePlusVendusSucc(
              state: controller.venteChartList,
              monnaieStorage: monnaieStorage)
        ])),
      ),
    );
  }
}
