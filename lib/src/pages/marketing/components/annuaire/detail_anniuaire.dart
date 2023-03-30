import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/marketing/annuaire_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_marketing.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/marketing/controller/annuaire/annuaire_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DetailAnnuaire extends StatefulWidget {
  const DetailAnnuaire({super.key, required this.annuaireColor});
  final AnnuaireColor annuaireColor;

  @override
  State<DetailAnnuaire> createState() => _DetailAnnuaireState();
}

class _DetailAnnuaireState extends State<DetailAnnuaire> {
  final AnnuaireController controller = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Marketing";

  @override
  Widget build(BuildContext context) {
    int userRole = int.parse(profilController.user.role);
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title,
          widget.annuaireColor.annuaireModel.nomPostnomPrenom),
      drawer: const DrawerMenuMarketing(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuMarketing())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Responsive.isMobile(context) ? 0.0 : p20,
                        bottom: p8,
                        right: Responsive.isMobile(context) ? 0.0 : p20,
                        left: Responsive.isMobile(context) ? 0.0 : p20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Card(
                                  child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(p10),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade700,
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          color: widget.annuaireColor.color,
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                        Positioned(
                                          top: 130,
                                          left: (Responsive.isDesktop(context))
                                              ? 50
                                              : 10,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade700,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: mainColor)),
                                            child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: Image.asset(
                                                    "assets/images/avatar.jpg",
                                                    width: 80,
                                                    height: 80)),
                                          ),
                                        ),
                                        Positioned(
                                            top: 150,
                                            left:
                                                (Responsive.isDesktop(context))
                                                    ? 180
                                                    : 120,
                                            child:
                                                (Responsive.isMobile(context))
                                                    ? Container()
                                                    : AutoSizeText(
                                                        widget
                                                            .annuaireColor
                                                            .annuaireModel
                                                            .nomPostnomPrenom,
                                                        maxLines: 2,
                                                        style: headlineSmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white))),
                                        Positioned(
                                            top: 150,
                                            right: 20,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                    onPressed: controller
                                                            .hasCallSupport
                                                        ? () => setState(() {
                                                              controller
                                                                      .launched =
                                                                  controller.makePhoneCall(widget
                                                                      .annuaireColor
                                                                      .annuaireModel
                                                                      .mobile1);
                                                            })
                                                        : null,
                                                    icon: const Icon(
                                                      Icons.call,
                                                      size: 40.0,
                                                      color: Colors.green,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      if (Platform.isAndroid) {}
                                                    },
                                                    icon: const Icon(
                                                      Icons.sms,
                                                      size: 40.0,
                                                      color: Colors.green,
                                                    )),
                                                IconButton(
                                                  onPressed: () => {},
                                                  icon: const Icon(
                                                    Icons.email_sharp,
                                                    size: 40.0,
                                                    color: Colors.purple,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(height: p30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (userRole <= 3)
                                          editButton(widget.annuaireColor),
                                        if (userRole <= 2)
                                          deleteButton(controller)
                                      ],
                                    ),
                                    const SizedBox(height: p30),
                                    Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.category),
                                        title: Text(
                                          widget.annuaireColor.annuaireModel
                                              .categorie,
                                          style: bodyMedium,
                                        ),
                                      ),
                                    ),
                                    if (Responsive.isMobile(context))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.person,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .nomPostnomPrenom,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                    if (!widget
                                        .annuaireColor.annuaireModel.email
                                        .contains('null'))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.email_sharp,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .email,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                    Card(
                                      elevation: 2,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.call,
                                          color: widget.annuaireColor.color,
                                          size: 40,
                                        ),
                                        title: Text(
                                          widget.annuaireColor.annuaireModel
                                              .mobile1,
                                          style: bodyMedium,
                                        ),
                                        subtitle: (!widget.annuaireColor
                                                .annuaireModel.mobile2
                                                .contains('null'))
                                            ? Text(
                                                widget.annuaireColor
                                                    .annuaireModel.mobile2,
                                                style: bodyMedium,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    if (!widget.annuaireColor.annuaireModel
                                        .secteurActivite
                                        .contains('null'))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.local_activity,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .secteurActivite,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                    if (!widget.annuaireColor.annuaireModel
                                        .nomEntreprise
                                        .contains('null'))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.business,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .nomEntreprise,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                    if (!widget
                                        .annuaireColor.annuaireModel.grade
                                        .contains('null'))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.grade,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .grade,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                    if (!widget.annuaireColor.annuaireModel
                                        .adresseEntreprise
                                        .contains('null'))
                                      Card(
                                        elevation: 2,
                                        child: ListTile(
                                          leading: Icon(Icons.place_sharp,
                                              color:
                                                  widget.annuaireColor.color),
                                          title: Text(
                                            widget.annuaireColor.annuaireModel
                                                .adresseEntreprise,
                                            style: bodyMedium,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )),
                            )
                          ],
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget editButton(AnnuaireColor annuaireColor) => IconButton(
      icon: const Icon(Icons.edit_outlined),
      color: Colors.purple,
      tooltip: "Modifiaction",
      onPressed: () {
        Get.toNamed(MarketingRoutes.marketingAnnuaireEdit,
            arguments: annuaireColor.annuaireModel);
      });

  Widget deleteButton(AnnuaireController controller) {
    return IconButton(
      icon: const Icon(Icons.delete),
      color: Colors.red,
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
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.annuaireColor.annuaireModel);
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
}
