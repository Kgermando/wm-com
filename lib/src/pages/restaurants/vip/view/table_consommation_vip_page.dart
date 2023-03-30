import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/restaurant/table_restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/table_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/vip_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class TableConsommationVipPage extends StatefulWidget {
  const TableConsommationVipPage({super.key});

  @override
  State<TableConsommationVipPage> createState() =>
      _TableConsommationVipPageState();
}

class _TableConsommationVipPageState extends State<TableConsommationVipPage> {
  final TableVipController controller = Get.put(TableVipController());
  final VipController restaurantController = Get.put(VipController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Consommations";

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
                          physics: const ScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleWidget(
                                      title: '$title Table consommations'),
                                  IconButton(
                                      onPressed: () {
                                        controller.getList();
                                        Navigator.pushNamed(context,
                                            VipRoutes.tableConsommationVip);
                                      },
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.green))
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: p20),
                                child: Wrap(
                                  spacing: p20,
                                  runSpacing: p20,
                                  children:
                                      List.generate(state!.length, (index) {
                                    final data = state[index];
                                    return tableWidget(data);
                                  }),
                                ),
                              ),
                            ],
                          ),
                        )))
          ],
        ));
  }

  // Green la table est ouverte pour les nouveaux clients
  // Rouge la table est fermée donc les clients occupent
  Widget tableWidget(TableRestaurantModel data) {
    return restaurantController.obx(
        onLoading: loadingPage(context),
        onEmpty: const Text('Aucune donnée'),
        onError: (error) => loadingError(context, error!), (state) {
      var restaurant = state!
          .where((element) =>
              element.table == data.table && element.statutCommande == 'true')
          .toList();
      Color? color;
      bool isBusy = false;
      if (restaurant.isNotEmpty) {
        color = Colors.red; // Occuper
        isBusy = true;
      } else if (restaurant.isEmpty) {
        color = Colors.green; // Ouvert pour les nouveaux clients
        isBusy = false;
      }
      return InkWell(
        onTap: () =>
            Get.toNamed(VipRoutes.tableConsommationVipDetail, arguments: data),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(p8)),
          child: Container(
            height: 150,
            width: 150,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 8.0, color: color!)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(),
                Icon((isBusy) ? Icons.table_bar : Icons.table_bar_outlined,
                    size: 60, color: color),
                AutoSizeText(data.table.toUpperCase(),
                    maxLines: 2, textAlign: TextAlign.center)
              ],
            ),
          ),
        ),
      );
    });
  }

  ardoiseDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Nouvelle table', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Obx(() => controller.isLoading
                      ? loading()
                      : Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              nomTabletWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.formKey.currentState!;
                    if (form.validate()) {
                      controller.submitConsommation();
                      form.reset();
                      Navigator.pop(context, 'ok');
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          });
        });
  }

  Widget nomTabletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.tableController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom de la table',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }
}
