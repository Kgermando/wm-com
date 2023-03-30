import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/widgets/loading.dart';

class VenteItemWidget extends StatefulWidget {
  const VenteItemWidget(
      {Key? key,
      required this.controller,
      required this.achat,
      required this.profilController,
      required this.cartController})
      : super(key: key);
  final AchatController controller;
  final AchatModel achat;
  final ProfilController profilController;
  final CartController cartController;

  @override
  State<VenteItemWidget> createState() => _VenteItemWidgetState();
}

class _VenteItemWidgetState extends State<VenteItemWidget> {
  final ProfilController profilController = Get.find();

  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Après ajout au panier le produit quite la liste
  bool isActive = true;

  FocusNode focusNode = FocusNode();

  TextEditingController quantityCartController = TextEditingController();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    quantityCartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    UserModel? user = profilController.user;
    String departementList = user.departement;
    bool isVisible = user.succursale == widget.achat.succursale;

    return Visibility(
      visible: isActive,
      child: Responsive.isDesktop(context)
          ? Card(
              // elevation: 10,
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.shopping_basket_sharp,
                      color: Colors.green.shade700, size: 40.0),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width / 2,
                          child: Text(
                            widget.achat.idProduct,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2,
                          child: Text(
                            'Stock: ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.quantity))} ${widget.achat.unite} / ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.prixVenteUnit))} ${monnaieStorage.monney}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.green.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (departementList.contains('Commercial') && isVisible)
                    Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Form(
                          key: formKey,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: qtyField()),
                              Expanded(child: onChanged())
                            ],
                          ),
                        ))
                ],
              ),
            ))
          : Card(
              // elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon(Icons.shopping_basket_sharp,
                  //     color: Colors.green.shade700, size: 40.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width / 2,
                              child: AutoSizeText(
                                widget.achat.idProduct,
                                maxLines: 2,
                                // overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Stock: ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.quantity))} ${widget.achat.unite} / ${NumberFormat.decimalPattern('fr').format(double.parse(widget.achat.prixVenteUnit))} ${monnaieStorage.monney}',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.green.shade700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (departementList.contains('Commercial') && isVisible)
                    Container(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Form(
                          key: formKey,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: qtyField()),
                              Expanded(child: onChanged())
                            ],
                          ),
                        ))
                ],
              ),
            ),
    );
  }

  Widget qtyField() {
    return SizedBox(
      width: Responsive.isDesktop(context) ? 100 : 50,
      height: 40,
      child: TextFormField(
        // key: UniqueKey(),
        controller:
            quantityCartController, // widget.cartController.quantityCartController,
        focusNode: focusNode,
        style: Responsive.isDesktop(context)
            ? const TextStyle(
                fontSize: 16,
              )
            : const TextStyle(
                fontSize: 12,
              ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: const InputDecoration(
          hintText: 'Qté',
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Check Qté';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else if (double.parse(value) >
              double.parse(widget.achat.quantity)) {
            return 'Qté insuffisantes';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget onChanged() {
    return Obx(() => (widget.cartController.isLoading)
        ? loadingMini()
        : IconButton(
            tooltip: 'Ajoutez au panier',
            iconSize: Responsive.isDesktop(context) ? 24.0 : 18.0,
            onPressed: () {
              final form = formKey.currentState!;
              if (form.validate()) {
                widget.cartController
                    .addCart(widget.achat, quantityCartController);
                setState(() {
                  isActive = !isActive;
                });
              }
            },
            icon: Icon(Icons.add_shopping_cart_sharp,
                color: Colors.green.shade700)));
  }

  alertDialog(String text) {
    return IconButton(
      icon: const Icon(Icons.assistant_direction),
      tooltip: 'Restitution de la quantité en stocks',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, "ok");
              },
              child: Text('OK', style: TextStyle(color: mainColor)),
            ),
          ],
        ),
      ),
    );
  }
}
