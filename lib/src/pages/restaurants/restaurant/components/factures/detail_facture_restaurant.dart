import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/restaurant/facture_restaurant_model.dart';
import 'package:wm_com/src/models/restaurant/restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_restaurant.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/factures/cart/table_facture_rest_cart.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/factures/pdf_a6/facture_restaurant_a6_pdf.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/factures/facture_restaurant_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailFactureRestaurant extends StatefulWidget {
  const DetailFactureRestaurant(
      {super.key, required this.factureRestaurantModel});
  final FactureRestaurantModel factureRestaurantModel;

  @override
  State<DetailFactureRestaurant> createState() =>
      _DetailFactureRestaurantState();
}

class _DetailFactureRestaurantState extends State<DetailFactureRestaurant> {
  final FactureRestaurantController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final FactureRestaurantPDFA6 factureRestaurantPDFA6 =
      Get.put(FactureRestaurantPDFA6());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Restaurant";

  Future<FactureRestaurantModel> refresh() async {
    final FactureRestaurantModel dataItem =
        await controller.detailView(widget.factureRestaurantModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.factureRestaurantModel.client),
      drawer: const DrawerMenuRestaurant(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuRestaurant())),
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
                                                'Facture n° ${widget.factureRestaurantModel.client}'),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      refresh().then((value) =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              RestaurantRoutes
                                                                  .factureRestaurantDetail,
                                                              arguments:
                                                                  value));
                                                    },
                                                    icon: const Icon(
                                                        Icons.refresh,
                                                        color: Colors.green)),
                                                PrintWidget(
                                                    tooltip:
                                                        'Imprimer le document',
                                                    onPressed: () {
                                                      factureRestaurantPDFA6
                                                          .generatePdf(
                                                              widget
                                                                  .factureRestaurantModel,
                                                              monnaieStorage
                                                                  .monney);
                                                    })
                                              ],
                                            ),
                                            SelectableText(
                                                DateFormat("dd-MM-yy HH:mm")
                                                    .format(widget
                                                        .factureRestaurantModel
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
                            TableFactureRestCart(
                                factureList:
                                    widget.factureRestaurantModel.cart),
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
                  child: SelectableText(widget.factureRestaurantModel.nomClient,
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
                  child: SelectableText(widget.factureRestaurantModel.telephone,
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
                  child: SelectableText(widget.factureRestaurantModel.signature,
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

    List<RestaurantModel> cartItemList = widget.factureRestaurantModel.cart;

    double sumCart = 0;
    for (var data in cartItemList) {
      sumCart += double.parse(data.price) * double.parse(data.qty);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: p30, horizontal: p10),
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
}
