import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/button_standard_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ProfileAuth extends StatefulWidget {
  const ProfileAuth({Key? key}) : super(key: key);

  @override
  State<ProfileAuth> createState() => _ProfileAuthState();
}

class _ProfileAuthState extends State<ProfileAuth> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Mon profil";

  @override
  Widget build(BuildContext context) {
    final ProfilController controller = Get.find();
    final headlineSmall = Theme.of(context).textTheme.headlineMedium;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, ""),
        drawer: const DrawerMenu(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(child: DrawerMenu())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!), (state) {
                  final String firstLettter2 = state!.prenom[0];
                  final String firstLettter = state.nom[0];
                  return Container(
                    padding: const EdgeInsets.all(p10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(p20),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              color: mainColor,
                              height: 200,
                              width: double.infinity,
                            ),
                            Positioned(
                              top: 130,
                              left: (Responsive.isDesktop(context)) ? 50 : 10,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2.0, color: mainColor)),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: AutoSizeText(
                                    '$firstLettter2$firstLettter'.toUpperCase(),
                                    maxLines: 2,
                                    style: headlineSmall!
                                        .copyWith(color: mainColor),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 150,
                                left:
                                    (Responsive.isDesktop(context)) ? 180 : 120,
                                child: (Responsive.isDesktop(context))
                                    ? AutoSizeText(
                                        "${state.prenom} ${state.nom}",
                                        style: headlineSmall.copyWith(
                                            color: Colors.white))
                                    : Column(
                                        children: [
                                          AutoSizeText(state.prenom,
                                              textAlign: TextAlign.left,
                                              style: bodyLarge!.copyWith(
                                                  color: Colors.white)),
                                          AutoSizeText(state.nom,
                                              textAlign: TextAlign.left,
                                              style: bodyLarge.copyWith(
                                                  color: Colors.white))
                                        ],
                                      )),
                            Positioned(
                                top: 155,
                                right: 20,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    shape: BoxShape.circle,
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(height: p50),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Nom',
                                        maxLines: 2,
                                        style: bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.nom,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Prénom',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.prenom,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Matricule',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.matricule,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Email',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.email,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Département',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.departement,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText(
                                        'Services d\'Affectation',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(
                                        state.servicesAffectation,
                                        maxLines: 2,
                                        style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Fonction Occupée',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.fonctionOccupe,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Accréditation',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText("Niveau ${state.role}",
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Succursale',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(state.succursale,
                                        maxLines: 2, style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: AutoSizeText('Date de création',
                                        maxLines: 2,
                                        style: bodyLarge.copyWith(
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(width: p20),
                                Expanded(
                                    child: AutoSizeText(
                                        DateFormat("dd.MM.yy HH:mm")
                                            .format(state.createdAt),
                                        maxLines: 2,
                                        style: bodyLarge))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: p20),
                        ButtonStandarWidget(
                            text: "Modifiez votre mot de passe",
                            onClicked: () {
                              Get.toNamed(UserRoutes.changePassword);
                            },
                            icon: Icons.password,
                            color: Colors.white),
                        const SizedBox(height: p30),
                      ],
                    ),
                  );
                })),
          ],
        ));
  }
}
