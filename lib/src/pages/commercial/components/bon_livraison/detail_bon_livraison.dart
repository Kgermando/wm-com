import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart'; 
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/bon_livraison/bon_livraison_pdf.dart';
import 'package:wm_com/src/pages/commercial/controller/bon_livraison/bon_livraison_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailBonLivraison extends StatefulWidget {
  const DetailBonLivraison({super.key, required this.bonLivraisonModel});
  final BonLivraisonModel bonLivraisonModel;

  @override
  State<DetailBonLivraison> createState() => _DetailBonLivraisonState();
}

class _DetailBonLivraisonState extends State<DetailBonLivraison> {
  final BonLivraisonController controller = Get.put(BonLivraisonController());
  final ProfilController profilController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  bool isChecked = false;

  Future<BonLivraisonModel> refresh() async {
    final BonLivraisonModel dataItem =
        await controller.detailView(widget.bonLivraisonModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.bonLivraisonModel.idProduct),
      drawer: const DrawerMenuCommercial(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: p20, bottom: p8, right: p20, left: p20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                    const TitleWidget(
                                        title: "Bon de livraison"),
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
                                                              .comBonLivraisonDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            PrintWidget(
                                              tooltip: 'Imprimer le document',
                                              onPressed: () async {
                                                await BonLivraisonPDF.generate(
                                                    widget.bonLivraisonModel,
                                                    monnaieStorage.monney);
                                              },
                                            ),
                                          ],
                                        ),
                                        SelectableText(
                                            DateFormat("dd-MM-yyyy HH:mm")
                                                .format(widget
                                                    .bonLivraisonModel.created),
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  ],
                                ),
                                dataWidget(controller, profilController),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget dataWidget(
      BonLivraisonController controller, ProfilController profilController) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    int roleUser = int.parse(profilController.user.role);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.bonLivraisonModel.succursale ==
                  profilController.user.succursale &&
              roleUser <= 3)
            accRecepetion(controller),
          const SizedBox(height: p20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Produit :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.visible),
              ),
              Expanded(
                child: Text(widget.bonLivraisonModel.idProduct,
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.visible),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Quantité Entrée :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(widget.bonLivraisonModel.quantityAchat))} ${widget.bonLivraisonModel.unite}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('TVA :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text('${widget.bonLivraisonModel.tva} %',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Prix de vente unitaire :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    '${NumberFormat.decimalPattern('fr').format(double.parse(widget.bonLivraisonModel.prixVenteUnit))} ${monnaieStorage.monney}',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          if (double.parse(widget.bonLivraisonModel.qtyRemise) >= 1)
            Divider(
              color: mainColor,
            ),
          if (double.parse(widget.bonLivraisonModel.qtyRemise) >= 1)
            Row(
              children: [
                Expanded(
                  child: Text('Prix de Remise :',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Text(
                      '${NumberFormat.decimalPattern('fr').format(double.parse(widget.bonLivraisonModel.remise))} ${monnaieStorage.monney}',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          if (double.parse(widget.bonLivraisonModel.qtyRemise) >= 1)
            Divider(
              color: mainColor,
            ),
          if (double.parse(widget.bonLivraisonModel.qtyRemise) >= 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Qtés pour la remise :',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Text(
                      '${widget.bonLivraisonModel.qtyRemise} ${widget.bonLivraisonModel.unite}',
                      style: Responsive.isDesktop(context)
                          ? const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)
                          : bodyMedium,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Livré par :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    "${widget.bonLivraisonModel.firstName} ${widget.bonLivraisonModel.lastName}",
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Réçu par :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(
                    "${widget.bonLivraisonModel.accuseReceptionFirstName} ${widget.bonLivraisonModel.accuseReceptionLastName}",
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Succursale :',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(widget.bonLivraisonModel.succursale,
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)
                        : bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget accRecepetion(BonLivraisonController controller) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Card(
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Accusé reception:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)
                        : bodyLarge),
                const SizedBox(
                  width: 10.0,
                ),
                (widget.bonLivraisonModel.accuseReception == 'false')
                    ? checkboxRead(controller)
                    : Text('OK',
                        style: Responsive.isDesktop(context)
                            ? const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.green)
                            : bodyLarge!.copyWith(color: Colors.green)),
              ],
            ),
          )),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(BonLivraisonController controller) {
    isChecked = widget.bonLivraisonModel.accuseReception == 'true';
    return Obx(() => controller.isLoading
        ? loadingMini()
        : Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
                controller.bonLivraisonStock(widget.bonLivraisonModel);
              });
            },
          ));
  }
}
