import 'package:badges/badges.dart' as badges;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/vente_effectue/vente_effectue_vip_xlsx.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/ventes_effectue_vip_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class VenteEffectueVip extends StatefulWidget {
  const VenteEffectueVip({super.key});

  @override
  State<VenteEffectueVip> createState() => _VenteEffectueVipState();
}

class _VenteEffectueVipState extends State<VenteEffectueVip> {
  final VenteEffectueVipController controller =
      Get.put(VenteEffectueVipController());
  final ProdModelVipController prodModelRestaurantController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Ventes effectués";

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuVip(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuVip())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (state) => SingleChildScrollView(
                        controller: ScrollController(),
                        physics: const ScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleWidget(
                                      title: "$title Historique de ventes"),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final values =
                                              await showCalendarDatePicker2Dialog(
                                            context: context,
                                            config:
                                                CalendarDatePicker2WithActionButtonsConfig(
                                              calendarType:
                                                  CalendarDatePicker2Type.range,
                                            ),
                                            dialogSize: const Size(325, 400),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // initialValue: [],
                                            dialogBackgroundColor: Colors.white,
                                          );
                                          DateTime? date1 = values![0];
                                          DateTime? date2 = values[1];
                                          var reppoting = state!
                                              .where((element) =>
                                                  element.created
                                                          .millisecondsSinceEpoch >=
                                                      date1!
                                                          .millisecondsSinceEpoch &&
                                                  element.created
                                                          .millisecondsSinceEpoch <=
                                                      date2!
                                                          .millisecondsSinceEpoch)
                                              .toList();
                                          VenteEffectueVipXlsx()
                                              .exportToExcel(title, reppoting);
                                        },
                                        icon: const Icon(Icons.install_desktop),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            controller.getList();
                                            Navigator.pushNamed(context,
                                                VipRoutes.ventEffectueVip);
                                          },
                                          icon: const Icon(Icons.refresh,
                                              color: Colors.green)),
                                    ],
                                  )
                                ],
                              ),
                              treeView(state!)
                            ],
                          ),
                        ))))
          ],
        ));
  }

  Widget treeView(List<VenteRestaurantModel> state) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return Column(
      children: prodModelRestaurantController.produitModelList
          .map((e) {
            List<VenteRestaurantModel> ventList = state
                .where((element) => e.identifiant == element.identifiant)
                .toList();

            String count =
                (ventList.length > 9999) ? "9999+" : "${ventList.length}";
            return Card(
              child: ExpansionTile(
                leading: badges.Badge(
                  badgeContent: Padding(
                    padding: const EdgeInsets.all(p10),
                    child: Text(count,
                        style: bodySmall!.copyWith(color: Colors.white)),
                  ),
                  showBadge: (ventList.isNotEmpty),
                ),
                title: Text(e.idProduct),
                onExpansionChanged: (val) {
                  setState(() {
                    isOpen = !val;
                  });
                },
                children: List.generate(ventList.length, (index) {
                  var vente = ventList[index];
                  double unitaire = double.parse(vente.priceTotalCart) /
                      double.parse(vente.qty);
                  var countItem = index + 1;
                  return ListTile(
                    onTap: () => Get.toNamed(VipRoutes.ventEffectueVipDetail,
                        arguments: vente),
                    leading: Text("$countItem.", style: bodyMedium),
                    title: Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(vente.qty))} ${vente.unite} x ${NumberFormat.decimalPattern('fr').format(unitaire)} = ${NumberFormat.decimalPattern('fr').format(double.parse(vente.priceTotalCart))} ${monnaieStorage.monney}",
                        style: bodyMedium),
                    subtitle: Text(vente.signature,
                        style: bodyMedium!.copyWith(color: mainColor)),
                    trailing: Text(
                        DateFormat("dd-MM-yy HH:mm").format(vente.created),
                        style: bodyMedium),
                  );
                }),
              ),
            );
          })
          .toSet()
          .toList(),
    );
  }
}
