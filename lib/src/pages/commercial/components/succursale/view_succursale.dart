import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/succursale/succursale_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child3_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class ViewSuccursale extends StatefulWidget {
  const ViewSuccursale(
      {super.key,
      required this.succursaleModel,
      required this.profilController,
      required this.controller,
      required this.monnaieStorage});
  final SuccursaleModel succursaleModel;
  final ProfilController profilController;
  final SuccursaleController controller;
  final MonnaieStorage monnaieStorage;

  @override
  State<ViewSuccursale> createState() => _ViewSuccursaleState();
}

class _ViewSuccursaleState extends State<ViewSuccursale> {
  @override
  Widget build(BuildContext context) {
    int userRole = int.parse(widget.profilController.user.role);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 0.0 : p10),
      child: SingleChildScrollView(
        controller: ScrollController(),
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     TitleWidget(title: widget.succursaleModel.name),
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ComRoutes.comSuccursaleDetail,
                                        arguments: widget.succursaleModel);
                                  },
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.green)),
                              Row(
                                children: [
                                  IconButton(
                                      color: Colors.purple,
                                      onPressed: () {
                                        Get.toNamed(ComRoutes.comSuccursaleUpdate,
                                            arguments: widget.succursaleModel);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  if (userRole <= 2) deleteButton(),
                                ],
                              ),
                            ],
                          ),
                          SelectableText(
                              DateFormat("dd-MM-yy HH:mm")
                                  .format(widget.succursaleModel.created),
                              textAlign: TextAlign.start),
                        ],
                      )
                    ],
                  ),
                  headerTitle(), 
                ],
              ),
            ),
            const SizedBox(height: p20),
            // ViewStatSuccursale(
            //     succursaleModel: widget.succursaleModel),
            const SizedBox(height: p20),
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?',
              style: TextStyle(color: Colors.red)),
          content: const Text(
              'Cette action permet de supprimer définitivement ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                widget.controller.deleteData(widget.succursaleModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: Obx(() => widget.controller.isLoading
                  ? loading()
                  : const Text('OK', style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerTitle() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;

    var dataAchatList = widget.controller.achatList
        .where((element) => element.succursale == widget.succursaleModel.name)
        .toList();
    // var dataCreanceList = creanceList.where((element) => element.succursale == widget.succursaleModel.name).toList();
    // var dataVenteList = venteList.where((element) => element.succursale == widget.succursaleModel.name).toList();
    // var dataGainList = gainList.where((element) => element.succursale == widget.succursaleModel.name).toList();

    // Achat global
    double sumAchat = 0.0;
    var dataAchat = dataAchatList
        .map((e) => double.parse(e.priceAchatUnit) * double.parse(e.quantity))
        .toList();
    for (var data in dataAchat) {
      sumAchat += data;
    }

    // Revenues
    double sumAchatRevenue = 0.0;
    var dataAchatRevenue = dataAchatList
        .map((e) => double.parse(e.prixVenteUnit) * double.parse(e.quantity))
        .toList();

    for (var data in dataAchatRevenue) {
      sumAchatRevenue += data;
    }

    // Marge beneficaires
    double sumAchatMarge = 0.0;
    var dataAchatMarge = dataAchatList
        .map((e) =>
            (double.parse(e.prixVenteUnit) - double.parse(e.priceAchatUnit)) *
            double.parse(e.quantity))
        .toList();
    for (var data in dataAchatMarge) {
      sumAchatMarge += data;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ResponsiveChildWidget(
                child1: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(widget.succursaleModel.name,
                    textAlign: TextAlign.start, style: bodyMedium)),
            Divider(color: mainColor),
            ResponsiveChildWidget(
                child1: Text('Province :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                child2: SelectableText(widget.succursaleModel.province,
                    textAlign: TextAlign.start, style: bodyMedium)),
            Divider(color: mainColor),
            ResponsiveChildWidget(
              child1: Text('Adresse :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.succursaleModel.adresse,
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Divider(color: mainColor),
            ResponsiveChild3Widget(
              child1: Column(
                children: [
                  const Text("Investissement",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(sumAchat)} ${widget.monnaieStorage.monney}",
                      textAlign: TextAlign.center,
                      style:
                          headlineSmall!.copyWith(color: Colors.blue.shade700)),
                ],
              ),
              child2: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                )),
                child: Column(
                  children: [
                    const Text("Revenus attendus",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(sumAchatRevenue)} ${widget.monnaieStorage.monney}",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: headlineSmall.copyWith(
                            color: Colors.orange.shade700)),
                  ],
                ),
              ),
              child3: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: mainColor,
                    width: 2,
                  ),
                )),
                child: Column(
                  children: [
                    const Text("Marge bénéficiaires",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(sumAchatMarge)} ${widget.monnaieStorage.monney}",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: headlineSmall.copyWith(
                            color: Colors.green.shade700)),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
