import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_rh.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/rh/components/view_personne.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DetailPersonne extends StatefulWidget {
  const DetailPersonne({super.key, required this.personne});
  final AgentModel personne;

  @override
  State<DetailPersonne> createState() => _DetailPersonneState();
}

class _DetailPersonneState extends State<DetailPersonne> {
  final PersonnelsController personnelsController =
      Get.put(PersonnelsController());
  final UsersController usersController = Get.put(UsersController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Ressources Humaines";

  bool statutAgent = false;
  String statutPersonel = 'Inactif';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title,
          "${widget.personne.prenom} ${widget.personne.nom}"),
      drawer: const DrawerMenuRH(),
      floatingActionButton: speedialWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuRH())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: ViewPersonne(
                      personne: widget.personne,
                      controller: personnelsController,
                      usersController: usersController))

              // DefaultTabController(
              //     length: 2,
              //     child: Column(
              //       children: [
              //         const SizedBox(
              //           height: 30,
              //           child: TabBar(
              //             physics: ScrollPhysics(),
              //             tabs: [Tab(text: "Profil"), Tab(text: "Utilisateurs actifs")],
              //           ),
              //         ),
              //         Expanded(
              //           child: TabBarView(
              //             physics: const ScrollPhysics(),
              //             children: [
              //               SingleChildScrollView(
              //                   child: ),
              //               Expanded(
              //                   child: InfosPersonne(personne: widget.personne))
              //             ],
              //           ),
              //         ),
              //       ],
              //     ))
              )
        ],
      ),
    );
  }

  Widget speedialWidget() {
    final ProfilController profilController = Get.find();

    bool isStatutPersonne = false;
    if (widget.personne.statutAgent == "Actif") {
      isStatutPersonne = true;
    } else if (widget.personne.statutAgent == "Inactif") {
      isStatutPersonne = false;
    }

    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        if (widget.personne.matricule != profilController.user.matricule)
          SpeedDialChild(
              child: const Icon(
                Icons.content_paste_sharp,
                size: 15.0,
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple.shade700,
              label: 'Modifier CV profil',
              onPressed: () {
                Get.toNamed(RhRoutes.rhPersonnelsUpdate,
                    arguments: widget.personne);
              }),
        if (int.parse(profilController.user.role) <= 3)
          SpeedDialChild(
            child: const Icon(Icons.safety_divider, size: 15.0),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red.shade700,
            label:
                (isStatutPersonne) ? "Désactiver le profil" : "Activer profil",
            onPressed: () {
              agentStatutDialog();
            },
          ),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  agentStatutDialog() {
    statutPersonel = widget.personne.statutAgent;
    if (statutPersonel == 'Actif') {
      statutAgent = true;
    } else if (statutPersonel == 'Inactif') {
      statutAgent = false;
    }
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Autorisation d\'accès au système'),
              content: SizedBox(
                height: 100,
                width: 200,
                child: Obx(() => personnelsController.isLoading
                    ? loading()
                    : Column(
                        children: [
                          FlutterSwitch(
                            width: 225.0,
                            height: 55.0,
                            activeColor: Colors.green,
                            inactiveColor: Colors.red,
                            valueFontSize: 25.0,
                            toggleSize: 45.0,
                            value: statutAgent,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: true,
                            activeText: 'Active',
                            inactiveText: 'Inactive',
                            onToggle: (val) {
                              setState(() {
                                statutAgent = val;
                                // String vrai = '';
                                if (statutAgent) {
                                  // vrai = 'true';
                                  statutPersonel = 'Actif';
                                  usersController.createUser(widget.personne);
                                  personnelsController.updateStatus(
                                      widget.personne, statutPersonel);
                                } else {
                                  // vrai = 'false';
                                  statutPersonel = 'Inactif';
                                  usersController.deleteUser(widget.personne);
                                  personnelsController.updateStatus(
                                      widget.personne, statutPersonel);
                                }

                                // if (vrai == 'true') {
                                //   usersController.createUser(widget.personne);
                                //   personnelsController.updateStatus(
                                //       widget.personne, statutPersonel);
                                // } else if (vrai == 'false') {
                                //   usersController.deleteUser(widget.personne);
                                //   personnelsController.updateStatus(
                                //       widget.personne, statutPersonel);
                                // }
                              });
                            },
                          ),
                        ],
                      )),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }
}
