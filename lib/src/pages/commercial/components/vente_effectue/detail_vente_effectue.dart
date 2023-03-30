import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/controller/vente_effectue/ventes_effectue_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailVenteEffectue extends StatefulWidget {
  const DetailVenteEffectue({super.key, required this.venteCartModel});
  final VenteCartModel venteCartModel;

  @override
  State<DetailVenteEffectue> createState() => _DetailVenteEffectueState();
}

class _DetailVenteEffectueState extends State<DetailVenteEffectue> {
  final VenteEffectueController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  Future<VenteCartModel> refresh() async {
    final VenteCartModel dataItem =
        await controller.detailView(widget.venteCartModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.venteCartModel.idProductCart),
      drawer: const DrawerMenu(),
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
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: p20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (!Responsive.isMobile(context))
                                              TitleWidget(
                                                  title: widget.venteCartModel
                                                      .succursale),
                                            Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      refresh().then((value) =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              ComRoutes
                                                                  .comVenteEffectueDetail,
                                                              arguments:
                                                                  value));
                                                    },
                                                    icon: const Icon(
                                                        Icons.refresh,
                                                        color: Colors.green)),
                                                SelectableText(
                                                    DateFormat("dd-MM-yy HH:mm")
                                                        .format(widget
                                                            .venteCartModel
                                                            .created),
                                                    textAlign: TextAlign.start),
                                              ],
                                            )
                                          ],
                                        ),
                                        dataWidget(),
                                        Divider(
                                          color: mainColor,
                                        ),
                                        const SizedBox(height: p10),
                                        total(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )))
                ],
              )),
    );
  }

  Widget dataWidget() {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    double prixUnitaire = double.parse(widget.venteCartModel.priceTotalCart) /
        double.parse(widget.venteCartModel.quantityCart);

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          const SizedBox(height: p30),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Produit :',
                  textAlign: TextAlign.start,
                  style: bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.venteCartModel.idProductCart,
                  textAlign: TextAlign.start, style: bodyLarge)),
          Divider(
            color: mainColor,
          ),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Quantités :',
                  textAlign: TextAlign.start,
                  style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              child2: Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(widget.venteCartModel.quantityCart))} ${widget.venteCartModel.unite}',
                  textAlign: TextAlign.start,
                  style: bodyLarge)),
          Divider(
            color: mainColor,
          ),
          ResponsiveChildWidget(
            flex1: 1,
            flex2: 3,
            child1: Text('Prix unitaire :',
                textAlign: TextAlign.start,
                style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            child2: Text(
              "${NumberFormat.decimalPattern('fr').format(prixUnitaire)} ${monnaieStorage.monney}",
              textAlign: TextAlign.start,
              style: bodyLarge,
            ),
          ),
          Divider(
            color: mainColor,
          ),
          ResponsiveChildWidget(
            flex1: 1,
            flex2: 3,
            child1: Text('Signature :',
                textAlign: TextAlign.start,
                style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.venteCartModel.signature,
                textAlign: TextAlign.start, style: bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget total() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Montant payé',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    overflow: TextOverflow.ellipsis),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(widget.venteCartModel.priceTotalCart))} ${monnaieStorage.monney}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red.shade700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
