import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/commercial/vente_cart_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/achats/achat_pdf.dart';
import 'package:wm_com/src/pages/commercial/components/achats/table_history_ravitaillement_produit.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_vente_controller.dart'; 
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailAchat extends StatefulWidget {
  const DetailAchat({super.key, required this.achatModel});
  final AchatModel achatModel;

  @override
  State<DetailAchat> createState() => _DetailAchatState();
}

class _DetailAchatState extends State<DetailAchat> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final AchatController controller = Get.put(AchatController());
  final ProfilController profilController = Get.put(ProfilController());
  final VenteCartController venteCartController =
      Get.put(VenteCartController());
  final HistoryRavitaillementController historyRavitaillementController =
      Get.put(HistoryRavitaillementController());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  Future<AchatModel> refresh() async {
    final AchatModel dataItem =
        await controller.detailView(widget.achatModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar:
            headerBar(context, scaffoldKey, title, widget.achatModel.idProduct),
        drawer: const DrawerMenuCommercial(),
        floatingActionButton: speedialWidget(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
            Expanded(
                flex: 5,
                child: venteCartController.obx(
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
                              mainAxisAlignment: (!Responsive.isMobile(context))
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.end,
                              children: [
                                if (!Responsive.isMobile(context))
                                  TitleWidget(
                                      title:
                                          'Succursale: ${widget.achatModel.succursale.toUpperCase()}'),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              refresh().then((value) =>
                                                  Navigator.pushNamed(context,
                                                      ComRoutes.comAchatDetail,
                                                      arguments: value));
                                            },
                                            icon: const Icon(Icons.refresh,
                                                color: Colors.green)),
                                        reporting(profilController, state!),
                                        editButton(),
                                        deleteButton()
                                      ],
                                    ),
                                    SelectableText(
                                        DateFormat("dd-MM-yyyy HH:mm")
                                            .format(widget.achatModel.created),
                                        textAlign: TextAlign.start),
                                  ],
                                )
                              ],
                            ),
                            dataWidget(profilController, state),
                            // const SizedBox(height: p20),
                            TableHistoryRavitaillementProduit(
                                achatModel: widget.achatModel,
                                historyRavitaillementList:
                                    historyRavitaillementController
                                        .historyRavitaillementList
                                        .where((p0) =>
                                            p0.idProduct ==
                                            widget.achatModel.idProduct)
                                        .toList()),
                            const SizedBox(height: p20),
                          ],
                        ),
                      )),
                ))
          ],
        ));
  }

  Widget dataWidget(
      ProfilController profilController, List<VenteCartModel> state) {
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          headerTitle(),
          const SizedBox(
            height: 20,
          ),
          achatTitle(),
          achats(profilController),
          const SizedBox(
            height: 20,
          ),
          ventetitle(),
          ventes(state),
          const SizedBox(
            height: 20,
          ),
          benficesTitle(),
          benfices(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget headerTitle() {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.achatModel.idProduct,
            style: Responsive.isDesktop(context) ? headlineSmall : bodyLarge),
      )),
    );
  }

  Widget achatTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'ACHATS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget achats(ProfilController profilController) {
    var roleAgent = int.parse(profilController.user.role) <= 3;

    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    var prixAchatTotal = double.parse(widget.achatModel.priceAchatUnit) *
        double.parse(widget.achatModel.quantityAchat);
    var margeBenifice = double.parse(widget.achatModel.prixVenteUnit) -
        double.parse(widget.achatModel.priceAchatUnit);
    var margeBenificeTotal =
        margeBenifice * double.parse(widget.achatModel.quantityAchat);

    var margeBenificeRemise = double.parse(widget.achatModel.remise) -
        double.parse(widget.achatModel.priceAchatUnit);
    var margeBenificeTotalRemise =
        margeBenificeRemise * double.parse(widget.achatModel.quantityAchat);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Quantité entrant',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.quantityAchat).toStringAsFixed(2)))} ${widget.achatModel.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Row(
                children: [
                  Text('Prix d\'achats unitaire',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodySmall,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodySmall,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Row(
                children: [
                  Text('Prix d\'achats total',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodySmall,
                      overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodySmall,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('TVA',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text('${widget.achatModel.tva} %',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix de vente unitaire',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Prix de Remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${double.parse(widget.achatModel.remise).toStringAsFixed(2)} ${monnaieStorage.monney}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Divider(
              color: mainColor,
            ),
            Row(
              children: [
                Text('Qtés pour la remise',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                    '${widget.achatModel.qtyRemise} ${widget.achatModel.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodySmall,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              const SizedBox(
                height: 20.0,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire unitaire / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodySmall,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodySmall,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marge bénéficiaire unitaire / Remise',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodySmall,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.orange)
                                : bodySmall,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
            if (roleAgent)
              Divider(
                color: mainColor,
              ),
            if (roleAgent)
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Text('Marge bénéficiaire total / Remise',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyMedium,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyMedium,
                            overflow: TextOverflow.ellipsis),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marge bénéficiaire total / Remise',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyMedium,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                            textAlign: TextAlign.left,
                            style: Responsive.isDesktop(context)
                                ? const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Color(0xFFE64A19))
                                : bodyMedium,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
          ],
        ),
      ),
    );
  }

  Widget ventetitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'VENTES',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget ventes(List<VenteCartModel> state) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    double qtyVendus = 0.0;
    double prixTotalVendu = 0.0;

    List<VenteCartModel> venteCartList = state
        .where((element) =>
            element.createdAt.millisecondsSinceEpoch ==
            widget.achatModel.created.millisecondsSinceEpoch)
        .toList();

    for (var item in venteCartList) {
      qtyVendus += double.parse(item.quantityCart);
    }

    for (var item in venteCartList) {
      prixTotalVendu += double.parse(item.priceTotalCart);
    }

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantité vendus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodySmall),
              Text('Montant vendus',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodySmall),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(qtyVendus.toStringAsFixed(0)))} ${widget.achatModel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyMedium),
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalVendu.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20)
                      : bodyMedium),
            ],
          ),
        ],
      ),
    ));
  }

  Widget benficesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Card(
        child: Text(
          'EN STOCKS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget benfices() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    var prixTotalRestante = double.parse(widget.achatModel.quantity) *
        double.parse(widget.achatModel.prixVenteUnit);

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${widget.achatModel.unite}',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodySmall),
              Text('Revenues',
                  style: Responsive.isDesktop(context)
                      ? const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)
                      : bodySmall),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.quantity).toStringAsFixed(0)))} ${widget.achatModel.unite}',
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

  Widget reporting(
      ProfilController profilController, List<VenteCartModel> state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintWidget(onPressed: () async {
          await AchatPdf.generate(
              widget.achatModel, profilController.user, state, monnaieStorage);
        })
      ],
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de supprimer ceci?',
              style: TextStyle(color: Colors.red.shade700)),
          content: Obx(() => controller.isLoading
              ? loading()
              : const Text(
                  'Cette action permet de supprimer définitivement ce document.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:
                  Text('Annuler', style: TextStyle(color: Colors.red.shade700)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.achatModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de modifier ceci?',
              style: TextStyle(color: mainColor)),
          content: const Text('Cette action permet de modifier ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(ComRoutes.comAchatUpdate,
                    arguments: widget.achatModel);
                // Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
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
                arguments: widget.achatModel);
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.local_shipping),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: 'Livraison stock',
            onPressed: () {
              Get.toNamed(ComRoutes.comStockGlobalLivraisonStock,
                  arguments: widget.achatModel);
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
