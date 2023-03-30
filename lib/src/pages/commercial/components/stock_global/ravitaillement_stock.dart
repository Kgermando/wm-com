import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/ravitaillement_controller.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';

class RavitaillementStock extends StatefulWidget {
  const RavitaillementStock({super.key, required this.stocksGlobalMOdel});
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<RavitaillementStock> createState() => _RavitaillementStockState();
}

class _RavitaillementStockState extends State<RavitaillementStock> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final RavitaillementController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  @override
  void initState() {
    super.initState();
    setState(() {
      controller.modeAchatBool = widget.stocksGlobalMOdel.modeAchat;
      controller.controlleridProduct =
          TextEditingController(text: widget.stocksGlobalMOdel.idProduct);
      controller.controllerquantity =
          TextEditingController(text: widget.stocksGlobalMOdel.quantity);
      controller.controllerpriceAchatUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.priceAchatUnit);
      controller.controllerPrixVenteUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.prixVenteUnit);
      controller.controllerUnite =
          TextEditingController(text: widget.stocksGlobalMOdel.unite);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.stocksGlobalMOdel.idProduct),
      drawer: const DrawerMenu(),
      body: Row(
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
                                  ResponsiveChildWidget(
                                      child1: Text('Mode achat :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: modeAchatField()),
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
                                          controller
                                              .submit(widget.stocksGlobalMOdel);
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

  Widget modeAchatField() {
    if (controller.modeAchatBool == "true") {
      controller.modeAchat = true;
    } else if (controller.modeAchatBool == "false") {
      controller.modeAchat = false;
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: FlutterSwitch(
          width: Responsive.isDesktop(context) ? 225.0 : 150,
          height: 55.0,
          inactiveColor: Colors.red,
          valueFontSize: 25.0,
          toggleSize: 45.0,
          value: controller.modeAchat,
          borderRadius: 30.0,
          padding: 8.0,
          showOnOff: true,
          activeText: 'PAYE',
          inactiveText: 'NON PAYE',
          onToggle: (value) {
            setState(() {
              controller.modeAchat = value;
              if (controller.modeAchat == true) {
                controller.modeAchatBool = "true";
              } else {
                controller.modeAchatBool = "false";
              }
            });
          },
        ));
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
                labelText: 'Quantités',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (quantity) => quantity != null && quantity.isEmpty
                  ? 'La Quantité total est obligatoire'
                  : null,
              onChanged: (value) =>
                  setState(() => controller.controllerquantity.text),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    const Text("Quantité précédent"),
                    Text(
                        "${widget.stocksGlobalMOdel.quantity} ${widget.stocksGlobalMOdel.unite}",
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
                labelText: 'Prix d\'achats unitaire',
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
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}",
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
              controller: controller.controllerPrixVenteUnit,
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
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}",
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
    final bodyLarge = Theme.of(context).textTheme.bodyMedium;

    var pvau = controller.prixVenteUnit * controller.tva / 100;

    controller.pavTVA = controller.prixVenteUnit + pvau;

    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Text(
            'PVU: ${controller.pavTVA.toStringAsFixed(2)} ${monnaieStorage.monney}',
            style: bodyLarge));
  }
}
