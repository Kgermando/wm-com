import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/restaurant/vente_restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/prod_model_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/ventes_effectue_terrasse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class VenteEffectueTerrasse extends StatefulWidget {
  const VenteEffectueTerrasse({super.key});

  @override
  State<VenteEffectueTerrasse> createState() => _VenteEffectueterrasseState();
}

class _VenteEffectueterrasseState extends State<VenteEffectueTerrasse> {
  final VenteEffectueTerrasseController controller =
      Get.put(VenteEffectueTerrasseController());
  final ProdModelTerrasseController prodModelRestaurantController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";
  String subTitle = "Ventes effectués";
  bool isOpen = false;

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuTerrasse(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuTerrasse())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (state) => SingleChildScrollView(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TitleWidget(
                                        title: "$title Historique de ventes"),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.getList();
                                              Navigator.pushNamed(
                                                  context,
                                                  TerrasseRoutes
                                                      .ventEffectueTerrasse);
                                            },
                                            icon: const Icon(Icons.refresh,
                                                color: Colors.green))
                                      ],
                                    ),
                                  ],
                                ),
                                treeView(state!)
                              ],
                            )))))
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
                    onTap: () => Get.toNamed(
                        TerrasseRoutes.ventEffectueTerrasseDetail,
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

  // Widget printXlsx() {
  //   return CalendarDatePicker2(
  //     config: CalendarDatePicker2Config(
  //       calendarType: CalendarDatePicker2Type.range,
  //     ),
  //     onValueChanged: (dates) => _yourHandler(dates),
  //     initialValue: [],
  //   );
  // }
}
