import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/components/cart/cart_item_widget.dart';
import 'package:wm_com/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final CartController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Panier";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuCommercial(),
      floatingActionButton: controller.obx(
        onLoading: loadingPage(context),
        onEmpty: const Icon(Icons.close),
        (state) =>
            (state!.isNotEmpty) ? speedialWidget(controller) : Container(),
      ),
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
                  onEmpty: const Text('Le panier est vide.'),
                  onError: (error) => loadingError(context, error!),
                  (state) => SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: 'Panier'),
                                IconButton(
                                    onPressed: () {
                                      // Navigator.pushNamed(
                                      //     context, ComRoutes.comCart);
                                      Get.toNamed(ComRoutes.comCart);
                                      controller.getList();
                                    },
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.green))
                              ],
                            ),
                            Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: state!.length,
                                itemBuilder: (context, index) {
                                  final cart = state[index];
                                  return CartItemWidget(
                                      cart: cart, controller: controller);
                                })),
                            Obx(() => SizedBox(
                                height: p50, child: totalCart(controller)))
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }

  Widget totalCart(CartController controller) {
    // Montant a Vendre
    double sumCart = 0.0;

    var dataPriceCart = controller.cartList
        .map((e) => (double.parse(e.quantityCart) >= double.parse(e.qtyRemise))
            ? double.parse(e.remise) * double.parse(e.quantityCart)
            : double.parse(e.priceCart) * double.parse(e.quantityCart))
        .toList();

    for (var data in dataPriceCart) {
      sumCart += data;
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} ${monnaieStorage.monney}',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700),
      ),
    );
  }

  SpeedDial speedialWidget(CartController controller) {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: 'Vente au comptant',
            onPressed: () {
              newAComptantDialog();
            }),
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            label: 'Vente à crédit',
            onPressed: () {
              newACreditDialog();
              // controller.submitFactureCreance();
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  newAComptantDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text('Vente au comptant', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Obx(() => controller.isFactureLoading
                      ? loading()
                      : Form(
                          key: controller.factureFormKey,
                          child: Column(
                            children: [
                              nomClientWidget(),
                              telephoneWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final form = controller.factureFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFacture(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.factureFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFacture(controller.cartList);
                      controller.createFacturePDF(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('🖨 Print'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          });
        });
  }

  newACreditDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Vente à Crédit',
                  style: TextStyle(color: Colors.orange)),
              content: SizedBox(
                  height: 400,
                  width: 300,
                  child: Obx(() => controller.isCreanceLoading
                      ? loading()
                      : Form(
                          key: controller.creanceFormKey,
                          child: Column(
                            children: [
                              nomClientACreditWidget(),
                              telephoneACreditWidget(),
                              adresseACreditWidget(),
                              delaiPaiementWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final form = controller.creanceFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFactureCreance(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.creanceFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFactureCreance(controller.cartList);
                      controller.createPDFCreance(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('🖨 Print'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          });
        });
  }

  Widget nomClientWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomClientController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du client',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget telephoneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.telephoneController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget nomClientACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomClientAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du client',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget telephoneACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.telephoneAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget adresseACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.addresseAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget delaiPaiementWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              DateTime? dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                type: OmniDateTimePickerType.date,
                firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );
              controller.delaiPaiementAcredit = dateTime;
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text("Delai de Paiement")));
  }
}
