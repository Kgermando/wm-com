import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_marketing.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/marketing/controller/annuaire/annuaire_controller.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class AddAnnuaire extends StatefulWidget {
  const AddAnnuaire({super.key});

  @override
  State<AddAnnuaire> createState() => _AddAnnuaireState();
}

class _AddAnnuaireState extends State<AddAnnuaire> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Marketing";
  String subTitle = "Nouveau contact";

  @override
  Widget build(BuildContext context) {
    final AnnuaireController controller = Get.find();

    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
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
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(p20),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TitleWidget(title: 'Nouveau contact'),
                              const SizedBox(height: p20),
                              categorieField(controller),
                              ResponsiveChildWidget(
                                child1: nomPostnomPrenomField(controller),
                                child2: emailField(controller),
                              ),
                              ResponsiveChildWidget(
                                child1: mobile1Field(controller),
                                child2: mobile2Field(controller),
                              ),
                              ResponsiveChildWidget(
                                child1: secteurActiviteField(controller),
                                child2: nomEntrepriseField(controller),
                              ),
                              gradeField(controller),
                              adresseEntrepriseField(controller),
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
                                      controller.submit();
                                      form.reset();
                                    }
                                  }))
                            ],
                          ),
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget categorieField(AnnuaireController controller) {
    List<String> categorieList = ['Fournisseur', 'Client', 'Partenaire'];
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contact',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.categorie,
        isExpanded: true,
        items: categorieList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            controller.categorie = value;
          });
        },
      ),
    );
  }

  Widget nomPostnomPrenomField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.nomPostnomPrenomController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nom complet',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget emailField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) => RegExpIsValide().validateEmail(value),
      ),
    );
  }

  Widget mobile1Field(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.mobile1Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Téléphone 1',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) => RegExpIsValide().validateMobile(value),
      ),
    );
  }

  Widget mobile2Field(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.mobile2Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Téléphone 2',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Ce champ est obligatoire';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget secteurActiviteField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.secteurActiviteController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Secteur d\'activité',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget nomEntrepriseField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.nomEntrepriseController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Entreprise ou business',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget gradeField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.gradeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Grade ou Fonction',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget adresseEntrepriseField(AnnuaireController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller.adresseEntrepriseController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Adresse',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
