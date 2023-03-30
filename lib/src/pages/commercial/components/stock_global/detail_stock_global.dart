import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/stock_global_pdf.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/table_history_ravitaillement_produit.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/stock_global_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailStockGlobal extends StatefulWidget {
  const DetailStockGlobal({super.key, required this.stocksGlobalMOdel});
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<DetailStockGlobal> createState() => _DetailStockGlobalState();
}

class _DetailStockGlobalState extends State<DetailStockGlobal> {
  final StockGlobalController controller = Get.put(StockGlobalController());
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  Future<StocksGlobalMOdel> refresh() async {
    final StocksGlobalMOdel dataItem =
        await controller.detailView(widget.stocksGlobalMOdel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(
            context, scaffoldKey, title, widget.stocksGlobalMOdel.idProduct),
        drawer: const DrawerMenu(),
        floatingActionButton: speedialWidget(),
        body: controller.obx(
          onLoading: loadingPage(context),
          onEmpty: const Text('Aucune donnée'),
          onError: (error) => loadingError(context, error!),
          (state) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: !Responsive.isMobile(context),
                  child: const Expanded(flex: 1, child: DrawerMenu())),
              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: p20, bottom: p8, right: p20, left: p20),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Card(
                              elevation: 3,
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
                                        if (!Responsive.isMobile(context))
                                          const TitleWidget(
                                              title: "Stock global"),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      refresh().then((value) =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              ComRoutes
                                                                  .comStockGlobalDetail,
                                                              arguments:
                                                                  value));
                                                    },
                                                    icon: const Icon(
                                                        Icons.refresh,
                                                        color: Colors.green)),
                                                reporting(),
                                              ],
                                            ),
                                            SelectableText(
                                                DateFormat("dd-MM-yyyy HH:mm")
                                                    .format(widget
                                                        .stocksGlobalMOdel
                                                        .created),
                                                textAlign: TextAlign.start),
                                          ],
                                        )
                                      ],
                                    ),
                                    dataWidget(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }

  Widget dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          achats(),
          const SizedBox(
            height: 20,
          ),
          disponiblesTitle(),
          disponibles(),
          const SizedBox(
            height: 30,
          ),
          achatHistorityTitle(),
          const SizedBox(
            height: 20,
          ),
          TableHistoryRavitaillementProduit(
              stocksGlobalMOdel: widget.stocksGlobalMOdel),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget achats() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    var prixAchatTotal = double.parse(widget.stocksGlobalMOdel.priceAchatUnit) *
        double.parse(widget.stocksGlobalMOdel.quantityAchat);

    var margeBenifice = double.parse(widget.stocksGlobalMOdel.prixVenteUnit) -
        double.parse(widget.stocksGlobalMOdel.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(widget.stocksGlobalMOdel.quantityAchat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveChildWidget(
                child1: Text('Produit :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(widget.stocksGlobalMOdel.idProduct,
                    textAlign: TextAlign.start, style: bodyMedium)),
            Divider(
              color: mainColor,
            ),
            ResponsiveChildWidget(
                child1: Text('Quantités entrant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.quantityAchat).toStringAsFixed(0)))} ${widget.stocksGlobalMOdel.unite}',
                    textAlign: TextAlign.start,
                    style: bodyMedium)),
            Divider(
              color: mainColor,
            ),
            ResponsiveChildWidget(
                child1: Text('Prix d\'achats unitaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    textAlign: TextAlign.start,
                    style: bodyMedium)),
            Divider(
              color: mainColor,
            ),
            ResponsiveChildWidget(
                child1: Text('Prix d\'achats total :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    textAlign: TextAlign.start,
                    style: bodyMedium)),
            if (double.parse(widget.stocksGlobalMOdel.tva) > 1)
              Divider(
                color: mainColor,
              ),
            if (double.parse(widget.stocksGlobalMOdel.tva) > 1)
              ResponsiveChildWidget(
                  child1: Text('TVA :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  child2: SelectableText('${widget.stocksGlobalMOdel.tva} %',
                      textAlign: TextAlign.start, style: bodyMedium)),
            Divider(
              color: mainColor,
            ),
            ResponsiveChildWidget(
                child1: Text('Prix de vente unitaire :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    textAlign: TextAlign.start,
                    style: bodyMedium)),
            Divider(
              color: mainColor,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ResponsiveChildWidget(
                child1: Text('Marge bénéficiaire unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.orange)
                        : bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                child2: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.orange)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis)),
            Divider(
              color: mainColor,
            ),
            ResponsiveChildWidget(
                child1: Text('Marge bénéficiaire total',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xFFE64A19))
                        : bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                child2: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xFFE64A19))
                        : bodyMedium)),
          ],
        ),
      ),
    );
  }

  Widget disponiblesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'DISPONIBLES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget disponibles() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    var prixTotalRestante = double.parse(widget.stocksGlobalMOdel.quantity) *
        double.parse(widget.stocksGlobalMOdel.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${widget.stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyMedium),
              Text('Revenus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodyMedium),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.quantity).toStringAsFixed(0)))} ${widget.stocksGlobalMOdel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyMedium),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                  style: Responsive.isDesktop(context)
                      ? TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.green[800])
                      : bodyMedium),
            ],
          ),
        ],
      ),
    ));
  }

  Widget achatHistorityTitle() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'FICHES DE STOCKS',
          textAlign: TextAlign.center,
          style: Responsive.isDesktop(context)
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
              : const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget reporting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintWidget(onPressed: () async {
          await StockGlobalPdf.generate(
              widget.stocksGlobalMOdel, monnaieStorage);
        })
      ],
    );
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.reply),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Ravitaillement stock',
          onPressed: () {
            Get.toNamed(ComRoutes.comStockGlobalRavitaillement,
                arguments: widget.stocksGlobalMOdel);
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.local_shipping),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: 'Livraison stock',
            onPressed: () {
              Get.toNamed(ComRoutes.comStockGlobalLivraisonStock,
                  arguments: widget.stocksGlobalMOdel);
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
