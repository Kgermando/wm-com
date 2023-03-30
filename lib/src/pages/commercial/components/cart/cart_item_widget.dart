import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/cart_model.dart';
import 'package:wm_com/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/widgets/loading.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({Key? key, required this.cart, required this.controller})
      : super(key: key);
  final CartModel cart;
  final CartController controller;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());

  @override
  Widget build(BuildContext context) {
    // var role = int.parse(user.role) <= 3;
    double sum = 0;
    var qtyRemise = double.parse(widget.cart.qtyRemise);
    var quantity = double.parse(widget.cart.quantityCart);
    if (quantity >= qtyRemise) {
      sum = double.parse(widget.cart.quantityCart) *
          double.parse(widget.cart.remise);
    } else {
      sum = double.parse(widget.cart.quantityCart) *
          double.parse(widget.cart.priceCart);
    }

    return Responsive.isDesktop(context)
        ? Padding(
            padding: const EdgeInsets.only(right: p10, left: p10),
            child: Card(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(ComRoutes.comCartDetail, arguments: widget.cart);
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                  ),
                  title: AutoSizeText(widget.cart.idProductCart,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodySmall),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: (double.parse(widget.cart.quantityCart) >=
                                double.parse(widget.cart.qtyRemise))
                            ? Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.remise))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                      ),
                    ],
                  ),
                  trailing: ConstrainedBox(
                    constraints: const BoxConstraints.expand(width: 200),
                    child: Row(
                      children: [
                        Text(
                            'Total: ${NumberFormat.decimalPattern('fr').format(sum)} ${monnaieStorage.monney}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        onCancel(),
                      ],
                    ),
                  ),
                  dense: true,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              ),
            ),
          )
        : Card(
            // elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart,
                      color: Colors.teal, size: 40.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.cart.idProductCart,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: p10,
                          ),
                        ),
                        (double.parse(widget.cart.quantityCart) >
                                double.parse(widget.cart.qtyRemise))
                            ? Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: p10,
                                    color: Colors.teal),
                              )
                            : Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.priceCart))} x ${NumberFormat.decimalPattern('fr').format(double.parse(widget.cart.quantityCart))} ${widget.cart.unite}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: p10,
                                    color: Colors.teal),
                              ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                      constraints: const BoxConstraints(minWidth: 100),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${NumberFormat.decimalPattern('fr').format(sum)} ${monnaieStorage.monney}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          onCancel(),
                        ],
                      ))
                ],
              ),
            ),
          );
  }

  Widget onCancel() {
    return Obx(() => widget.controller.isLoadingCancel
        ? loadingMini()
        : IconButton(
            tooltip: 'Annuler',
            onPressed: () {
              setState(() {
                widget.controller.updateAchat(widget.cart);
              });
            },
            icon: const Icon(Icons.cancel, color: Colors.red)));
  }
}
