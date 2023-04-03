import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/commercial/achat_model.dart';
import 'package:wm_com/src/routes/routes.dart';

class ListStock extends StatelessWidget { 
  const ListStock({super.key, 
    required this.achat, required this.role});
  final AchatModel achat;
  final String role;

  @override
  Widget build(BuildContext context) {
    var restesenPourcent = (double.parse(achat.quantity) * 100) /
        double.parse(achat.quantityAchat);
    int roleAgent = int.parse(role);
    return GestureDetector(
      onTap: () {
        if (roleAgent <= 3) {
          Get.toNamed(ComRoutes.comAchatDetail, arguments: achat);
        }
        if (roleAgent >= 4) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title:
                  Text('⚠ Accès refusée!', style: TextStyle(color: mainColor)),
              content: const Text("Accréditation non autorisée!."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'ok');
                  },
                  child: Text('OK', style: TextStyle(color: mainColor)),
                ),
              ],
            ),
          );
        }
      },
      child: Card(
          elevation: 10,
          color: colorQty(),
          child: ListTile(
            dense: true,
            leading: const Icon(
              Icons.shopping_basket_sharp,
              color: Colors.black,
              size: 40.0,
            ),
            title: Text(achat.idProduct,
                overflow: TextOverflow.clip,
                style: Responsive.isDesktop(context)
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)
                    : const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
            subtitle: Text(
              'Stock: ${double.parse(achat.quantity).toStringAsFixed(0)} ${achat.unite}',
              overflow: TextOverflow.clip,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black),
            ),
            trailing: Text('${restesenPourcent.toStringAsFixed(0)} %',
                style: Responsive.isDesktop(context)
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black)
                    : const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)),
          )),
    );
  }

  colorQty() {
    var color50 = double.parse(achat.quantityAchat) / 2;
    var color40 = double.parse(achat.quantityAchat) / 4;
    var color8 = color40 / 4;

    var color35 = color40 + color8;
    var color75 = color50 + color40;

    if (double.parse(achat.quantityAchat) == double.parse(achat.quantity)) {
      return Colors.green[400];
    } else if (double.parse(achat.quantity) >= color75) {
      return Colors.green[300];
    } else if (double.parse(achat.quantity) >= color50) {
      return Colors.teal[200];
    } else if (double.parse(achat.quantity) >= color50) {
      return Colors.teal[100];
    } else if (double.parse(achat.quantity) >= color35) {
      return Colors.yellow[200];
    } else if (double.parse(achat.quantity) >= color40) {
      return Colors.orange[200];
    } else if (double.parse(achat.quantity) >= color8) {
      return Colors.yellow;
    } else if (double.parse(achat.quantity) >= 0.0) {
      return Colors.red[300];
    } else {
      return Colors.red[400];
    }
  }
}
