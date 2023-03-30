import 'dart:convert';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/rh/components/agent_pdf.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class ViewPersonne extends StatefulWidget {
  const ViewPersonne(
      {super.key,
      required this.personne,
      required this.controller,
      required this.usersController});
  final AgentModel personne;
  final PersonnelsController controller;
  final UsersController usersController;

  @override
  State<ViewPersonne> createState() => _ViewPersonneState();
}

class _ViewPersonneState extends State<ViewPersonne> {
  final UsersController usersController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  Future<AgentModel> refresh() async {
    final AgentModel dataItem =
        await widget.controller.detailView(widget.personne.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    int roleUser = int.parse(widget.controller.profilController.user.role);
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context) ? p20 : 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleWidget(title: 'Curriculum vitæ'.toUpperCase()),
              Row(
                children: [
                  IconButton(
                      tooltip: 'Actualiser',
                      onPressed: () {
                        refresh().then((value) => Navigator.pushNamed(
                            context, RhRoutes.rhPersonnelsDetail,
                            arguments: value));
                      },
                      icon: Icon(Icons.refresh, color: Colors.green.shade700)),
                  if (roleUser <= 2) deleteButton(),
                  PrintWidget(
                      tooltip: "Imprimer le CV",
                      onPressed: () async {
                        await AgentPdf.generate(widget.personne);
                      }),
                ],
              )
            ],
          ),
          identiteWidget(),
          serviceWidget(),
          competenceExperienceWidget(),
          infosEditeurWidget(),
        ]),
      ),
    );
  }

  Widget deleteButton() {
    var userList = usersController.usersList
        .where((p0) => p0.matricule == widget.personne.matricule)
        .toList();
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de supprimer ceci?',
              style: TextStyle(color: mainColor)),
          content: Obx(() => widget.controller.isLoading
              ? loading()
              : const Text(
                  'Cette action permet de supprimer définitivement ce document.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:
                  Text('Annuler', style: TextStyle(color: Colors.red.shade700)),
            ),
            Obx(
              () => TextButton(
                onPressed: () {
                  if (userList.isNotEmpty) {
                    widget.usersController.deleteUser(widget.personne);
                  }

                  widget.controller.isDeleteProfile(widget.personne);
                  Navigator.pop(context, 'ok');
                },
                child: widget.controller.isLoading
                    ? loadingMini()
                    : Text('OK', style: TextStyle(color: Colors.red.shade700)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget identiteWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: Responsive.isDesktop(context) ? 55 : 30,
                backgroundColor: mainColor,
                child: ClipOval(
                    child: CachedNetworkImageBuilder(
                  url: widget.personne.photo!,
                  builder: (image) {
                    return Center(
                        child: Image.file(
                      image,
                      width: Responsive.isDesktop(context) ? 150 : 100,
                      height: Responsive.isDesktop(context) ? 150 : 100,
                      fit: BoxFit.cover,
                    ));
                  },
                  // Optional Placeholder widget until image loaded from url
                  placeHolder: Center(child: loading()),
                  // Optional error widget
                  errorWidget: Image.asset(
                      width: Responsive.isDesktop(context) ? 150 : 100,
                      height: Responsive.isDesktop(context) ? 150 : 100,
                      'assets/images/avatar.jpg'),
                  // Optional describe your image extensions default values are; jpg, jpeg, gif and png
                  imageExtensions: const ['jpg', 'png'],
                )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: SfBarcodeGenerator(
                          value: widget.personne.matricule,
                          symbology: QRCode(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Statut : ',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      if (widget.personne.statutAgent == 'Actif')
                        Text(widget.personne.statutAgent,
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                color: Colors.green.shade700)),
                      if (widget.personne.statutAgent == 'Inactif')
                        Text(widget.personne.statutAgent,
                            textAlign: TextAlign.start,
                            style: bodyMedium.copyWith(
                                color: Colors.orange.shade700))
                    ],
                  ),
                  Text(
                      "Créé le. ${DateFormat("dd-MM-yyyy HH:mm").format(widget.personne.createdAt)}",
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                  Text(
                      "Mise à jour le. ${DateFormat("dd-MM-yyyy HH:mm").format(widget.personne.created)}",
                      textAlign: TextAlign.start,
                      style: bodyMedium),
                ],
              )
            ],
          ),
          const SizedBox(
            height: p20,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.nom,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.postNom,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Prénom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.prenom,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Email :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.email,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Téléphone :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.telephone,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Sexe :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.sexe,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 : 3,
                child: Text('Niveau d\'accréditation :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.role,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.matricule,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Lieu de naissance :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.lieuNaissance,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 : 3,
                child: Text('Date de naissance :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: Text(
                      DateFormat("dd-MM-yyyy")
                          .format(widget.personne.dateNaissance),
                      textAlign: TextAlign.start,
                      style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Nationalité :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.nationalite,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Adresse :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.adresse,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
        ],
      ),
    );
  }

  Widget serviceWidget() {
    final ProfilController profilController = Get.find();
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final role = int.parse(profilController.user.role);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 : 3,
                child: Text('Type de Contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.typeContrat,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Fonction occupée :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.fonctionOccupe,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 : 2,
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 3,
                  child: SelectableText(widget.personne.departement,
                      textAlign: TextAlign.start, style: bodyMedium)),
            ],
          ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Services d\'affectation :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.personne.servicesAffectation,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 : 3,
                child: Text('Date de début du contrat :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  flex: 2,
                  child: SelectableText(
                      DateFormat("dd-MM-yyyy")
                          .format(widget.personne.dateDebutContrat),
                      textAlign: TextAlign.start,
                      style: bodyMedium)),
            ],
          ),
          if (widget.personne.typeContrat == 'CDD') Divider(color: mainColor),
          if (widget.personne.typeContrat == 'CDD')
            Row(
              children: [
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 3,
                  child: Text('Date de fin du contrat :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    flex: 3,
                    child: SelectableText(
                        DateFormat("dd-MM-yyyy")
                            .format(widget.personne.dateFinContrat),
                        textAlign: TextAlign.start,
                        style: bodyMedium)),
              ],
            ),
          if (role <= 3) Divider(color: mainColor),
          if (role <= 3)
            Row(
              children: [
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 2,
                  child: Text('Salaire :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    flex: 3,
                    child: SelectableText(
                        "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(widget.personne.salaire).toStringAsFixed(2)))} ${monnaieStorage.monney}",
                        textAlign: TextAlign.start,
                        style: bodyMedium.copyWith(color: Colors.blueGrey))),
              ],
            ),
        ],
      ),
    );
  }

  Widget competenceExperienceWidget() {
    var competanceJson = jsonDecode(widget.personne.detailPersonnel!);
    widget.controller.competanceController = flutter_quill.QuillController(
        document: flutter_quill.Document.fromJson(competanceJson),
        selection: const TextSelection.collapsed(offset: 0));
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: mainColor),
              flutter_quill.QuillEditor.basic(
                controller: widget.controller.competanceController,
                readOnly: true,
                locale: const Locale('fr'),
              )
            ],
          ),
          const SizedBox(height: p30),
        ],
      ),
    );
  }

  Widget infosEditeurWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Signature :',
              style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          SelectableText(widget.personne.signature,
              textAlign: TextAlign.justify, style: bodyMedium)
        ],
      ),
    );
  }
}
