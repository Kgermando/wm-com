import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/restaurant/creance_restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/factures/cart/table_creance_terrasse_cart.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/factures/pdf_a6/creance_terrasse_a6_pdf.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/factures/creance_terrasse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailCreanceTerrasse extends StatefulWidget {
  const DetailCreanceTerrasse(
      {super.key, required this.creanceRestaurantModel});
  final CreanceRestaurantModel creanceRestaurantModel;

  @override
  State<DetailCreanceTerrasse> createState() => _DetailCreanceterrasseState();
}

class _DetailCreanceterrasseState extends State<DetailCreanceTerrasse> {
  final CreanceTerrasseController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final CreanceTerrassePDFA6 creanceRestaurantPDFA6 =
      Get.put(CreanceTerrassePDFA6());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";

  Future<CreanceRestaurantModel> refresh() async {
    final CreanceRestaurantModel dataItem =
        await controller.detailView(widget.creanceRestaurantModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.creanceRestaurantModel.client),
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
                            Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: p20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TitleWidget(
                                            title:
                                                'Facture n° ${widget.creanceRestaurantModel.client}'),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      refresh().then((value) =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              TerrasseRoutes
                                                                  .creanceTerrasseDetail,
                                                              arguments:
                                                                  value));
                                                    },
                                                    icon: const Icon(
                                                        Icons.refresh,
                                                        color: Colors.green)),
                                                IconButton(
                                                    tooltip:
                                                        'Remboursement de la dette',
                                                    onPressed: () {
                                                      alertDialog();
                                                    },
                                                    icon:
                                                        const Icon(Icons.send),
                                                    color:
                                                        Colors.teal.shade700),
                                                PrintWidget(
                                                    tooltip:
                                                        'Imprimer le document',
                                                    onPressed: () async {
                                                      creanceRestaurantPDFA6
                                                          .generatePdf(
                                                              widget
                                                                  .creanceRestaurantModel,
                                                              monnaieStorage
                                                                  .monney);
                                                    })
                                              ],
                                            ),
                                            SelectableText(
                                                DateFormat("dd-MM-yy HH:mm")
                                                    .format(widget
                                                        .creanceRestaurantModel
                                                        .created),
                                                textAlign: TextAlign.start),
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: mainColor,
                                    ),
                                    dataWidget(),
                                  ],
                                ),
                              ),
                            ),
                            TableCreanceTerrasseCart(
                                factureList:
                                    widget.creanceRestaurantModel.cart),
                            const SizedBox(height: p20),
                            totalCart()
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Nom client :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.creanceRestaurantModel.nomClient,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Téléphone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.creanceRestaurantModel.telephone,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.creanceRestaurantModel.signature,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(
            color: mainColor,
          ),
        ],
      ),
    );
  }

  Widget totalCart() {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;

    double sumCart = 0;
    for (var data in widget.creanceRestaurantModel.cart) {
      sumCart += double.parse(data.qty) * double.parse(data.price);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: p30),
      child: Row(
        mainAxisAlignment: Responsive.isDesktop(context)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(
                  color: mainColor,
                  width: 2,
                ),
              )),
              child: Padding(
                padding: const EdgeInsets.only(left: p10),
                child: Text("Total: ",
                    style: headlineSmall!.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold)),
              )),
          const SizedBox(width: p20),
          Text(
              "${NumberFormat.decimalPattern('fr').format(sumCart)} ${monnaieStorage.monney}",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: headlineSmall.copyWith(color: Colors.red.shade700))
        ],
      ),
    );
  }

  alertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Remboursement de la dette',
                  style: TextStyle(color: Colors.green.shade700)),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text(
                      "Cette action permet de mentioner cette facture comme etant payé.")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text('Annuler',
                      style: TextStyle(color: Colors.green.shade700)),
                ),
                TextButton(
                  onPressed: () {
                    controller.submit(widget.creanceRestaurantModel);
                    Navigator.pop(context, 'ok');
                  },
                  child: Text('OK',
                      style: TextStyle(color: Colors.green.shade700)),
                ),
              ],
            );
          });
        });
  }
}
