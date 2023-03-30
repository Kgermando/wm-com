import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/finance/caisse_name_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_finance.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/finance/components/caisses/table_caisse.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class CaissePage extends StatefulWidget {
  const CaissePage({super.key, required this.caisseNameModel});
  final CaisseNameModel caisseNameModel;

  @override
  State<CaissePage> createState() => _CaissePageState();
}

class _CaissePageState extends State<CaissePage> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final CaisseController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Finances";
  String subTitle = "Caisses";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuFinance(),
        floatingActionButton: speedialWidget(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuFinance())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (data) => Container(
                        margin: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 0.0 : p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Tablecaisse(
                            caisseList: controller.caisseList
                                .where((p0) =>
                                    p0.caisseName ==
                                    widget.caisseNameModel.nomComplet)
                                .toList(),
                            controller: controller,
                            caisseNameModel: widget.caisseNameModel)))),
          ],
        ));
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.upload),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade700,
          label: 'Sortie',
          onPressed: () {
            decaissementDialog();
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Entrer',
          onPressed: () {
            encaissementDialog();
          },
        ),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  encaissementDialog() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  height: 400,
                  child: Form(
                    key: controller.formKeyEncaissement,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(p16),
                        child: SizedBox(
                          width: Responsive.isDesktop(context)
                              ? MediaQuery.of(context).size.width / 2
                              : MediaQuery.of(context).size.width,
                          child: ListView(
                            children: [
                              const TitleWidget(title: 'Encaissement'),
                              const SizedBox(
                                height: p20,
                              ),
                              ResponsiveChildWidget(
                                  child1: nomCompletWidget(),
                                  child2: pieceJustificativeWidget()),
                              ResponsiveChildWidget(
                                  child1: libelleWidget(),
                                  child2: montantWidget()),
                              const SizedBox(
                                height: p20,
                              ),
                              const SizedBox(
                                height: p20,
                              ),
                              Obx(() => BtnWidget(
                                  title: 'Soumettre',
                                  isLoading: controller.isLoading,
                                  press: () {
                                    final form = controller
                                        .formKeyEncaissement.currentState!;
                                    if (form.validate()) {
                                      controller.submitEncaissement(
                                          widget.caisseNameModel);
                                      form.reset();
                                    }
                                  }))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  decaissementDialog() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  height: 400,
                  child: Form(
                    key: controller.formKeyDecaissement,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(p16),
                        child: SizedBox(
                          width: Responsive.isDesktop(context)
                              ? MediaQuery.of(context).size.width / 2
                              : MediaQuery.of(context).size.width,
                          child: ListView(
                            children: [
                              const TitleWidget(title: 'Décaissement'),
                              const SizedBox(
                                height: p20,
                              ),
                              nomCompletWidget(),
                              ResponsiveChildWidget(
                                  child1: libelleWidget(),
                                  child2: montantWidget()),
                              const SizedBox(
                                height: p20,
                              ),
                              const SizedBox(
                                height: p20,
                              ),
                              Obx(() => BtnWidget(
                                  title: 'Soumettre',
                                  isLoading: controller.isLoading,
                                  press: () {
                                    final form = controller
                                        .formKeyDecaissement.currentState!;
                                    if (form.validate()) {
                                      controller.submitDecaissement(
                                          widget.caisseNameModel);
                                      form.reset();
                                    }
                                  }))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget nomCompletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomCompletController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget pieceJustificativeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.pieceJustificativeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N° de la pièce justificative',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget libelleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.libelleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libellé',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget montantWidget() {
    final headline6 = Theme.of(context).textTheme.titleLarge;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: controller.montantController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Montant',
                ),
                validator: (value) => value != null && value.isEmpty
                    ? 'Ce champs est obligatoire.'
                    : null,
                style: const TextStyle(),
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text(
                  monnaieStorage.monney,
                  style: headline6!,
                ))
          ],
        ));
  }
}
