import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class AjoutProdModelVip extends StatefulWidget {
  const AjoutProdModelVip({super.key});

  @override
  State<AjoutProdModelVip> createState() => _AjoutProdModelVipState();
}

class _AjoutProdModelVipState extends State<AjoutProdModelVip> {
  final ProdModelVipController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Nouveau Produit Modèle";

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuVip(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuVip())),
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
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(p20),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleWidget(
                                      title: 'Identifiant Produit $title'),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  identifiantWidget(),
                                  ResponsiveChildWidget(
                                      child1: uniteWidget(),
                                      child2: priceWidget()),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  Obx(() => BtnWidget(
                                      title: 'Soumettre',
                                      isLoading: controller.isLoading,
                                      press: () {
                                        final form =
                                            controller.formKey.currentState!;
                                        if (form.validate()) {
                                          controller.submit(title);
                                          form.reset();
                                        }
                                      }))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget identifiantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.identifiantController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Identifiant",
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget uniteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.uniteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Unité de vente",
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget priceWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller.priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Prix',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Le Prix de vente est obligatoire';
                } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                  return 'chiffres obligatoire';
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(width: p20),
          Expanded(
              flex: 3,
              child: Text(monnaieStorage.monney,
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      ),
    );
  }
}
