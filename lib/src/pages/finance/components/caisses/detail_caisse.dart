import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/finance/caisse_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_finance.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailCaisse extends StatefulWidget {
  const DetailCaisse({super.key, required this.caisseModel});
  final CaisseModel caisseModel;

  @override
  State<DetailCaisse> createState() => _DetailCaisseState();
}

class _DetailCaisseState extends State<DetailCaisse> {
  final CaisseController controller = Get.put(CaisseController());
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Finances";

  Future<CaisseModel> refresh() async {
    final CaisseModel dataItem =
        await controller.detailView(widget.caisseModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(
            context, scaffoldKey, title, widget.caisseModel.numeroOperation),
        drawer: const DrawerMenuFinance(),
        body: controller.obx(
          onLoading: loadingPage(context),
          onEmpty: const Text('Aucune donnée'),
          onError: (error) => loadingError(context, error!),
          (state) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: !Responsive.isMobile(context),
                  child: const Expanded(flex: 1, child: DrawerMenuFinance())),
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
                                                widget.caisseModel.caisseName),
                                        Column(
                                          children: [
                                            IconButton(
                                                tooltip: 'Actualiser',
                                                onPressed: () async {
                                                  refresh().then((value) =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          FinanceRoutes
                                                              .transactionsCaisseDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            SelectableText(
                                                DateFormat("dd-MM-yyyy HH:mm")
                                                    .format(widget
                                                        .caisseModel.created),
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
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ResponsiveChildWidget(
            child1: Text('Caisse :',
                textAlign: TextAlign.start,
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.caisseName,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Titre :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.nomComplet,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Pièce justificative :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.pieceJustificative,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Libellé :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.libelle,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          if (widget.caisseModel.typeOperation == "Encaissement")
            Divider(color: mainColor),
          if (widget.caisseModel.typeOperation == "Encaissement")
            ResponsiveChildWidget(
              child1: Text('Montant Encaissement :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(
                  "${NumberFormat.decimalPattern('fr').format(double.parse(widget.caisseModel.montantEncaissement))} ${monnaieStorage.monney}",
                  textAlign: TextAlign.start,
                  style: bodyMedium),
            ),
          if (widget.caisseModel.typeOperation == "Decaissement")
            Divider(color: mainColor),
          if (widget.caisseModel.typeOperation == "Decaissement")
            ResponsiveChildWidget(
              child1: Text('Montant Decaissement :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(
                  "${NumberFormat.decimalPattern('fr').format(double.parse(widget.caisseModel.montantDecaissement))} ${monnaieStorage.monney}",
                  textAlign: TextAlign.start,
                  style: bodyMedium),
            ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Type d\'opération :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.typeOperation,
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(color: Colors.purple)),
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Numéro d\'opération :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.numeroOperation,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
            child1: Text('Signature :',
                textAlign: TextAlign.start,
                style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            child2: SelectableText(widget.caisseModel.signature,
                textAlign: TextAlign.start, style: bodyMedium),
          ),
        ],
      ),
    );
  }
}
