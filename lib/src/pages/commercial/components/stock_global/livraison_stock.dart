import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/livraison_controller.dart';
import 'package:wm_com/src/models/commercial/stocks_global_model.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class LivraisonStock extends StatefulWidget {
  const LivraisonStock({super.key, required this.stocksGlobalMOdel});
  final StocksGlobalMOdel stocksGlobalMOdel;

  @override
  State<LivraisonStock> createState() => _LivraisonStockState();
}

class _LivraisonStockState extends State<LivraisonStock> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final LivraisonController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  @override
  void initState() {
    setState(() {
      controller.controllerPrixVenteUnit =
          TextEditingController(text: widget.stocksGlobalMOdel.prixVenteUnit);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TitleWidget(
                                          title:
                                              "Livraison à ${controller.succursale}"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  succursaleField(controller),
                                  quantityField(controller),
                                  prixVenteField(controller),
                                  ResponsiveChildWidget(
                                      child1: qtyRemiseField(controller),
                                      child2: remiseField(controller)),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  Obx(() => BtnWidget(
                                      title: 'Livré à ${controller.succursale}',
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

  Widget succursaleField(LivraisonController controller) {
    var succ = controller.succursaleList.map((e) => e.name).toList().toSet();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Selectionner la succursale',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.succursale,
        isExpanded: true,
        items: succ.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select succursalee" : null,
        onChanged: (value) {
          setState(() {
            controller.succursale = value;
          });
        },
      ),
    );
  }

  Widget quantityField(LivraisonController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              // controller: controllerQuantity, // Ce champ doit etre vide pour permettre a l'admin de saisir la qty
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Quantité à livrer',
                suffixStyle: const TextStyle(color: Colors.red),
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'La Qtés à livrer est obligatoire';
                } else if (value.isEmpty) {
                  return 'Qté ne peut pas être nulle';
                } else if (value.contains(RegExp(r'[A-Z]'))) {
                  return 'Que les chiffres svp!';
                } else if (double.parse(value) >
                    double.parse(widget.stocksGlobalMOdel.quantity)) {
                  return 'La Qté à livrer ne peut pas être superieur à la Qtés actuelle';
                }
                return null;
              },
              onChanged: (value) =>
                  setState(() => controller.quantityStock = value),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                    'Qté Existante: ${widget.stocksGlobalMOdel.quantity} ${widget.stocksGlobalMOdel.unite}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.orange)),
              ))
        ],
      ),
    );
  }

  Widget prixVenteField(LivraisonController controller) {
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
                if (value == null || value.isEmpty) {
                  return 'Le Prix de vente unitaires est obligatoire';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                if (value == "" || value == ".") {
                  controller.prixVenteUnit = 0.0;
                } else {
                  controller.prixVenteUnit = double.parse(value);
                }

                // controller.prixVenteUnit =
                //     (value == "") ? 0.0 : double.parse(value);
              }),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                    'Prix Existant: ${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.stocksGlobalMOdel.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.orange)),
              ))
        ],
      ),
    );
  }

  Widget remiseField(LivraisonController controller) {
    return ResponsiveChildWidget(
        flex1: 3,
        flex2: 1,
        child1: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            // controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Remise en % (Facultatif) ',
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
              controller.remise = (value == "") ? 1 : double.parse(value);
            }),
          ),
        ),
        child2: remiseValeur(controller));
  }

  Widget qtyRemiseField(LivraisonController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Quantités pour la remise (Facultatif) ',
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
          controller.qtyRemise = (value == "") ? 1 : double.parse(value);
        }),
      ),
    );
  }

  double? pavTVARemise;

  remiseValeur(LivraisonController controller) {
    var remiseEnPourcent = (controller.prixVenteUnit * controller.remise) / 100;
    pavTVARemise = controller.prixVenteUnit - remiseEnPourcent;
    return Container(
      margin: const EdgeInsets.only(left: 5.0, bottom: 20.0),
      child: Text(
          'R: ${pavTVARemise!.toStringAsFixed(2)} ${monnaieStorage.monney}',
          style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
