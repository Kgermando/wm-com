import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/facture_cart_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/components/factures/cart/table_facture_cart.dart';
import 'package:wm_com/src/pages/commercial/components/factures/pdf_a6/facture_cart_a6_pdf.dart';
import 'package:wm_com/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailFacture extends StatefulWidget {
  const DetailFacture({super.key, required this.factureCartModel});
  final FactureCartModel factureCartModel;

  @override
  State<DetailFacture> createState() => _DetailFactureState();
}

class _DetailFactureState extends State<DetailFacture> {
  final FactureController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final FactureCartPDFA6 factureCartPDFA6 = Get.put(FactureCartPDFA6());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  Future<FactureCartModel> refresh() async {
    final FactureCartModel dataItem =
        await controller.detailView(widget.factureCartModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.factureCartModel.client),
      drawer: const DrawerMenuCommercial(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
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
                                                'Facture n° ${widget.factureCartModel.client}'),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      refresh().then((value) =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              ComRoutes
                                                                  .comFactureDetail,
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
                                                      factureCartPDFA6.generatePdf(
                                                          widget
                                                              .factureCartModel,
                                                          monnaieStorage
                                                              .monney);
                                                    })
                                              ],
                                            ),
                                            SelectableText(
                                                DateFormat("dd-MM-yy HH:mm")
                                                    .format(widget
                                                        .factureCartModel
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
                            TableFactureCart(
                                factureList: widget.factureCartModel.cart),
                            // jsonDecode(widget.factureCartModel.cart)
                            //     as List),
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
                  child: SelectableText(widget.factureCartModel.nomClient,
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
                  child: SelectableText(widget.factureCartModel.telephone,
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
                  child: SelectableText(widget.factureCartModel.signature,
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
    for (var data in widget.factureCartModel.cart) {
      var qtyRemise = double.parse(data.qtyRemise);
      var quantity = double.parse(data.quantityCart);
      if (quantity >= qtyRemise) {
        sumCart += double.parse(data.remise) * double.parse(data.quantityCart);
      } else {
        sumCart +=
            double.parse(data.priceCart) * double.parse(data.quantityCart);
      }
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
