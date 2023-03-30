import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/ravitaillement_controller.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class RavitaillementStock extends StatefulWidget {
  const RavitaillementStock({super.key, required this.achatModel});
  final AchatModel achatModel;

  @override
  State<RavitaillementStock> createState() => _RavitaillementStockState();
}

class _RavitaillementStockState extends State<RavitaillementStock> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final RavitaillementController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     controller.controlleridProduct =
  //         TextEditingController(text: widget.achatModel.idProduct);
  //     controller.controllerquantity =
  //         TextEditingController(text: widget.achatModel.quantity);
  //     controller.controllerpriceAchatUnit =
  //         TextEditingController(text: widget.achatModel.priceAchatUnit);
  //     controller.prixVenteUnit = double.parse(widget.achatModel.prixVenteUnit);
  //     controller.controllerUnite =
  //         TextEditingController(text: widget.achatModel.unite);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:
          headerBar(context, scaffoldKey, title, widget.achatModel.idProduct),
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
                    margin: EdgeInsets.only(
                        top: Responsive.isMobile(context) ? 0.0 : p20,
                        bottom: p8,
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Form(
                      key: controller.formKey,
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
                                  const TitleWidget(title: 'Ravitaillement'),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  ResponsiveChildWidget(
                                      child1: quantityField(),
                                      child2: priceAchatUnitField()),
                                  ResponsiveChildWidget(
                                      child1: prixVenteField(),
                                      child2: tvaField()),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  Obx(() => BtnWidget(
                                      title: 'Ravitailler',
                                      isLoading: controller.isLoading,
                                      press: () {
                                        final form =
                                            controller.formKey.currentState!;
                                        if (form.validate()) {
                                          controller.submit(widget.achatModel);
                                          form.reset();
                                        }
                                      }))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget quantityField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller.controllerquantity,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Quantité',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (quantity) => quantity != null && quantity.isEmpty
                  ? 'La Quantité total est obligatoire'
                  : null,
              // onChanged: (value) =>
              //     setState(() => controller.controllerquantity.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Qté précédente"),
                    Text(
                        "${widget.achatModel.quantity} ${widget.achatModel.unite}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget priceAchatUnitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller.controllerpriceAchatUnit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Prix d\'achat unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) => value != null && value.isEmpty
                  ? 'Le prix d\'achat unitaire est obligatoire'
                  : null,
              onChanged: (value) =>
                  setState(() => controller.controllerpriceAchatUnit.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Prix d'achat précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              // controller: controller.controllerPrixVenteUnit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Prix de vente unitaire',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Le Prix de vente unitaires est obligatoire';
                } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
              },
              onChanged: (value) => setState(() {
                controller.prixVenteUnit =
                    (value == "") ? 0.0 : double.parse(value);
              }),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Prix de vente précédent"),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.achatModel.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.orange)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget tvaField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'TVA en %',
                // hintText: 'Mettez "1" si vide',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
              },
              onChanged: (value) => setState(() {
                controller.tva = (value == "") ? 1 : double.parse(value);
              }),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: tvaValeur(),
        )
      ],
    );
  }

  tvaValeur() {
    final bodyText1 = Theme.of(context).textTheme.bodyMedium;

    var pvau = controller.prixVenteUnit * controller.tva / 100;

    controller.pavTVA = controller.prixVenteUnit + pvau;

    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text(
            'PVU: ${controller.pavTVA.toStringAsFixed(2)} ${monnaieStorage.monney}',
            style: bodyText1));
  }
}
