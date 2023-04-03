import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/dropdown.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/licence_wm.dart';
import 'package:wm_com/src/utils/monnaie_dropdown.dart';
import 'package:wm_com/src/widgets/change_theme_button_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> { 
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Settings";
  String subTitle = InfoSystem().version();

  List<String> langues = Dropdown().langues;
  List<String> deviseList = MonnaieDropDown().devises;

  String? devise;
  String? langue;
  String? formatImprimante;

  @override
  void initState() {
    super.initState();
    setState(() {
      langues.first;
    });
    LicenceWM().initMyLibrary();
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
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
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListSettings(
                                icon: Icons.theater_comedy,
                                title: 'Thèmes',
                                options: ChangeThemeButtonWidget()),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListSettings(
                                icon: Icons.language,
                                title: 'Langues',
                                options: langueWidget(context)),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListSettings(
                                  icon: Icons.monetization_on,
                                  title: 'Devise',
                                  options: TextButton(
                                    onPressed: () {
                                      Get.toNamed(SettingsRoutes.monnaiePage);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(monnaieStorage.monney,
                                            style: headlineSmall),
                                        const Icon(Icons.arrow_right)
                                      ],
                                    ),
                                  ))),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListSettings(
                                icon: Icons.print,
                                title: 'Format imprimante',
                                options: formatImprimanteWidget(context)),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListSettings(
                                icon: Icons.apps_rounded,
                                title: 'Version Plateform',
                                options: getVersionField(context)),
                          ),
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget langueWidget(BuildContext context) {
    return DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelStyle: TextStyle(),
          contentPadding: EdgeInsets.only(left: 5.0),
        ),
        value: langues.first,
        isExpanded: true,
        items: langues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            langue = value;
          });
        });
  }

  Widget formatImprimanteWidget(BuildContext context) {
    List<String> formatList = ["A4", "A6"];
    return DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelStyle: TextStyle(),
          contentPadding: EdgeInsets.only(left: 5.0),
        ),
        value: formatImprimante,
        isExpanded: true,
        items: formatList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() async {
            formatImprimante = value;
          });
        });
  }

  Widget getVersionField(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return SizedBox(
      height: 200,
      width: 200,
      child: TextButton(
          child: Text(InfoSystem().version(), style: headlineSmall),
          onPressed: () => showAboutDialog(
                  context: context,
                  applicationName: InfoSystem().name(),
                  applicationIcon: Image.asset(
                    InfoSystem().logoIcon(),
                    width: 50,
                    height: 50,
                  ),
                  applicationVersion: InfoSystem().version(),
                  children: [
                    Text(
                        "Work Management est une suite logicielle conçu \n pour les Grandes entreprises, \n Petites et Moyennes Entreprises, ONG et Associations, \n ainsi que l'administration public. ",
                        textAlign: TextAlign.justify,
                        style: bodyMedium),
                    const SizedBox(height: p20),
                    Text("® Copyright Eventdrc Technology",
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  ])

          // showDialog<String>(
          //   context: context,
          //   builder: (BuildContext context) => AlertDialog(
          //       title: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           ,
          //           const SizedBox(height: p20),
          //           Text(),
          //         ],
          //       ),
          //       content:
          //           ),
          // ),
          ),
    );
  }
}

class ListSettings extends StatelessWidget {
  const ListSettings(
      {Key? key,
      required this.icon,
      required this.title,
      required this.options})
      : super(key: key);

  final IconData icon;
  final String title;
  final Widget options;

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style: Responsive.isDesktop(context) ? headlineSmall : bodyLarge),
      trailing: SizedBox(width: 100, child: options),
    );
  }
}
