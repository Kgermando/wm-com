import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_com/src/models/reservation/reservation_model.dart';
import 'package:wm_com/src/models/users/user_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_reservation.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/reservation/components/reservation_a6_pdf.dart';
import 'package:wm_com/src/pages/reservation/components/reservation_paiement_a6_pdf.dart';
import 'package:wm_com/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_com/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailReservation extends StatefulWidget {
  const DetailReservation({super.key, required this.reservationModel});
  final ReservationModel reservationModel;

  @override
  State<DetailReservation> createState() => _DetailReservationState();
}

class _DetailReservationState extends State<DetailReservation> {
  final ReservationController controller = Get.put(ReservationController());
  final PaiementReservationController paiementReservationController =
      Get.put(PaiementReservationController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Reservation";

  Future<UserModel> refresh() async {
    final UserModel dataItem =
        await controller.detailView(widget.reservationModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    int userRole = int.parse(controller.profilController.user.role);
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.reservationModel.eventName),
      drawer: const DrawerMenuReservation(),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton(
              tooltip: "Ajouter le montant de paiement",
              child: const Icon(Icons.add),
              onPressed: () {
                newDialog();
              })
          : FloatingActionButton.extended(
              label: const Text("Ajouter un nouveau paiement"),
              tooltip: "Ajouter le montant de paiement",
              icon: const Icon(Icons.add),
              onPressed: () {
                newDialog();
              },
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuReservation())),
          Expanded(
              flex: 5,
              child: paiementReservationController.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!), (state) {
                var paiementReservation = state!
                    .where((element) =>
                        element.reference == widget.reservationModel.id!)
                    .toList();
                return SingleChildScrollView(
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
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: p20, vertical: p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TitleWidget(title: "Reservation"),
                                      Row(
                                        children: [
                                          IconButton(
                                              tooltip: 'Actualiser',
                                              onPressed: () {
                                                refresh().then((value) =>
                                                    Navigator.pushNamed(context,
                                                        RhRoutes.rhdetailUser,
                                                        arguments: value));
                                              },
                                              icon: Icon(Icons.refresh,
                                                  color:
                                                      Colors.green.shade700)),
                                          if (userRole <= 2)
                                            IconButton(
                                                color: Colors.purple,
                                                onPressed: () {
                                                  Get.toNamed(
                                                      ReservationRoutes
                                                          .reservationUpdate,
                                                      arguments: widget
                                                          .reservationModel);
                                                },
                                                icon: const Icon(Icons.edit)),
                                          if (userRole <= 2) deleteButton(),
                                          PrintWidget(
                                              tooltip: "Imprimer le facture",
                                              onPressed: () {
                                                ReservationPDFA6.generatePdf(
                                                    widget.reservationModel,
                                                    paiementReservation,
                                                    "\$");
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: p20),
                                  ResponsiveChildWidget(
                                      child1: Text('Evenement :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.eventName,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text(
                                          'Nom du client (Organisateur) :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.client,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Téléphone :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.telephone,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Email :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.email,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Adresse :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.adresse,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Nbre de Personnes :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.nbrePersonne,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text("Durée de l'évenement :",
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.dureeEvent,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  const Divider(color: Colors.red),
                                  ResponsiveChildWidget(
                                      child1: Text("Montant à payé :",
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.reservationModel.montant).toStringAsFixed(2)))} \$',
                                          textAlign: TextAlign.start,
                                          style: headlineSmall)),
                                  const SizedBox(height: p20),
                                ],
                              ),
                            ),
                          ),
                          paiementReservationController.obx(
                              onLoading: loadingPage(context),
                              onEmpty: const Text('Aucune donnée'),
                              onError: (error) => loadingError(context, error!),
                              (state) {
                            List<PaiementReservationModel> paiementReservation =
                                state!
                                    .where((element) =>
                                        element.reference ==
                                        widget.reservationModel.id!)
                                    .toList();
                            double total = 0.0;
                            for (var element in paiementReservation) {
                              total = double.parse(element.montant);
                            }
                            double reste =
                                double.parse(widget.reservationModel.montant) -
                                    total;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: p10),
                                const TitleWidget(title: "Paiements"),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: paiementReservation.length,
                                    itemBuilder: (context, index) {
                                      final paiement =
                                          paiementReservation[index];
                                      var isDelete = DateTime.now()
                                          .difference(paiement.created);
                                      return Card(
                                        child: ListTile(
                                          onLongPress: () {
                                            detailPaiementDialog(paiement);
                                          },
                                          leading: (isDelete.inHours <= 1)
                                              ? Obx(() =>
                                                  paiementReservationController
                                                          .isLoading
                                                      ? loadingMini()
                                                      : deleteMontantButton(
                                                          paiement))
                                              : const Icon(
                                                  Icons.monetization_on),
                                          title: Text(
                                              paiement.motif.capitalizeFirst!),
                                          subtitle: Text(
                                              DateFormat("dd-MM-yyyy HH:mm")
                                                  .format(paiement.created)),
                                          trailing: Text(
                                              "${NumberFormat.decimalPattern('fr').format(double.parse(paiement.montant))} \$",
                                              style: bodyLarge!.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: p20),
                                const Divider(color: Colors.green),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ResponsiveChildWidget(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        child1: Text("Total payé",
                                            style: headlineSmall),
                                        child2: Text(
                                            "${NumberFormat.decimalPattern('fr').format(total)} \$",
                                            style: headlineSmall!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)))),
                                const Divider(color: Colors.red),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ResponsiveChildWidget(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        child1: Text("Reste à payé",
                                            style: headlineSmall),
                                        child2: Text(
                                            "${NumberFormat.decimalPattern('fr').format(reste)} \$",
                                            style: headlineSmall.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red))))
                              ],
                            );
                          })
                        ],
                      ),
                    ));
              }))
        ],
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
          content: Obx(() => controller.isLoading
              ? loading()
              : const Text(
                  'Cette action permet de supprimer définitivement ce document.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.reservationModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: Obx(() => controller.isLoading
                  ? loading()
                  : const Text('OK', style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteMontantButton(PaiementReservationModel paiement) {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.close),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?',
              style: TextStyle(color: Colors.red)),
          content: Obx(() => controller.isLoading
              ? loading()
              : const Text(
                  'Cette action permet de supprimer définitivement ce document.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                paiementReservationController.deleteData(paiement.id!);
                Navigator.pop(context, 'ok');
              },
              child: Obx(() => paiementReservationController.isLoading
                  ? loadingMini()
                  : const Text('OK', style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  newDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Ajouter le paiement',
                  style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Obx(() => paiementReservationController.isLoading
                      ? loading()
                      : Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              motifWidget(),
                              montant(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.formKey.currentState!;
                    if (form.validate()) {
                      paiementReservationController
                          .submit(widget.reservationModel);
                      form.reset();
                    }
                  },
                  child: Obx(() =>
                      controller.isLoading ? loading() : const Text('OK')),
                ),
              ],
            );
          });
        });
  }

  Widget motifWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: paiementReservationController.motifController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Motif de paiement',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget montant() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: paiementReservationController.montantController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant en \$',
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  detailPaiementDialog(PaiementReservationModel paiement) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Detail du Paiement',
                  style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrintWidget(
                              tooltip: "Imprimer le paiement",
                              onPressed: () {
                                ReservationPaiementPDFA6.generatePdf(
                                    paiement, "\$");
                              }),
                        ],
                      ),
                      const SizedBox(height: p20),
                      Text('Motif :',
                          textAlign: TextAlign.start,
                          style: headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(paiement.motif.capitalizeFirst!,
                          textAlign: TextAlign.left, style: headlineSmall),
                      const SizedBox(height: p20),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('Motant :',
                                textAlign: TextAlign.start,
                                style: headlineSmall.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(paiement.montant).toStringAsFixed(2)))} \$',
                                textAlign: TextAlign.left,
                                style: headlineSmall),
                          ),
                        ],
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('ok'),
                ),
              ],
            );
          });
        });
  }
}
