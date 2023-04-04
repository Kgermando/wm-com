import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_rh.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/utils/dropdown.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class AddPersonnel extends StatefulWidget {
  const AddPersonnel({super.key, required this.personnelList});
  final List<AgentModel> personnelList;

  @override
  State<AddPersonnel> createState() => _AddPersonnelState();
}

class _AddPersonnelState extends State<AddPersonnel> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final PersonnelsController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Ressources Humaines";
  String subTitle = "New profil";

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuRH(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuRH())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (data) => SingleChildScrollView(
                          controller: ScrollController(),
                          physics: const ScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Responsive.isMobile(context) ? 0.0 : p20,
                                bottom: p8,
                                right: Responsive.isDesktop(context) ? p20 : 0,
                                left: Responsive.isDesktop(context) ? p20 : 0),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Card(
                              elevation: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: p20),
                                child: Form(
                                  key: controller.formKey,
                                  child: Column(
                                    children: [
                                      const TitleWidget(
                                          title: "Nouveau profil"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          fichierWidget(),
                                        ],
                                      ),
                                      const SizedBox(height: p20),
                                      ResponsiveChildWidget(
                                          child1: nomWidget(),
                                          child2: postNomWidget()),
                                      ResponsiveChildWidget(
                                          child1: prenomWidget(),
                                          child2: sexeWidget()),
                                      ResponsiveChildWidget(
                                          child1: dateNaissanceWidget(),
                                          child2: lieuNaissanceWidget()),
                                      ResponsiveChildWidget(
                                          child1: nationaliteWidget(),
                                          child2: adresseWidget()),
                                      ResponsiveChildWidget(
                                          child1: emailWidget(),
                                          child2: telephoneWidget()),
                                      ResponsiveChildWidget(
                                          child1: matriculeWidget(),
                                          child2: roleWidget()),
                                      ResponsiveChildWidget(
                                          child1: servicesAffectationWidget(),
                                          child2: fonctionOccupeWidget()),
                                      ResponsiveChildWidget(
                                          child1: typeContratWidget(),
                                          child2: salaireWidget()),
                                      ResponsiveChildWidget(
                                          child1: dateDebutContratWidget(),
                                          child2:
                                              (controller.typeContrat == 'CDD')
                                                  ? dateFinContratWidget()
                                                  : Container()),
                                      competanceWidget(),
                                      // experienceWidget(),
                                      const SizedBox(height: p20),
                                      Obx(() => BtnWidget(
                                          title: 'Soumettre',
                                          isLoading: controller.isLoading,
                                          press: () {
                                            final form = controller
                                                .formKey.currentState!;
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
                          ),
                        ))),
          ],
        ));
  }

  Widget fichierWidget() {
    return Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(2),
        child: Obx(() => controller.isUploading
            ? const SizedBox(
                height: 50.0, width: 50.0, child: LinearProgressIndicator())
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: CircleAvatar(
                          child: CachedNetworkImageBuilder(
                        url: (controller.uploadedFileUrl == '')
                            ? 'assets/images/avatar.jpg'
                            : controller.uploadedFileUrl,
                        builder: (image) {
                          return Center(
                              child: Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ));
                        },
                        // Optional Placeholder widget until image loaded from url
                        placeHolder: loadingMini(),
                        // Optional error widget
                        errorWidget: Image.asset('assets/images/avatar.jpg'),
                        // Optional describe your image extensions default values are; jpg, jpeg, gif and png
                        imageExtensions: const ['jpg', 'png'],
                      )),
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 70,
                      child: IconButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpg'],
                            );
                            if (result != null) {
                              setState(() {
                                controller
                                    .uploadFile(result.files.single.path!);
                              });
                            } else {
                              const Text("Le fichier n'existe pas");
                            }
                          },
                          icon: const Icon(Icons.camera_alt)))
                ],
              )));
  }

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
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

  Widget postNomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.postNomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Post-Nom',
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

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prénom',
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

  Widget emailWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Email',
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(),
          // validator: (value) => RegExpIsValide().validateEmail(value),
        ));
  }

  Widget telephoneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.telephoneController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
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

  Widget adresseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.adresseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
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

  Widget sexeWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Sexe',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.sexe,
        isExpanded: true,
        items: controller.sexeList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Sexe" : null,
        onChanged: (value) {
          setState(() {
            controller.sexe = value!;
          });
        },
      ),
    );
  }

  Widget roleWidget() {
    final ProfilController profilController = Get.find();
    List<String> roleList = [];
    if (int.parse(profilController.user.role) == 0) {
      roleList = Dropdown().roleAdmin;
    } else if (int.parse(profilController.user.role) <= 3) {
      roleList = Dropdown().roleSuperieur;
    } else if (int.parse(profilController.user.role) > 3) {
      roleList = Dropdown().roleAgent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Niveau d\'accréditation',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.only(left: 5.0),
              ),
              value: controller.role,
              isExpanded: true,
              items: roleList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? "Select accréditation" : null,
              onChanged: (value) {
                setState(() {
                  controller.role = value!;
                });
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                  tooltip: "Besoin d'aide ?",
                  color: Colors.red.shade700,
                  onPressed: () {
                    helpDialog();
                  },
                  icon: const Icon(Icons.help)))
        ],
      ),
    );
  }

  Widget matriculeWidget() {
    String prefix = InfoSystem().prefix();
    final date = DateFormat("yy").format(DateTime.now());

    String numero = '';
    if (controller.identifiant < 10) {
      numero = "00${controller.identifiant}";
    } else if (controller.identifiant < 99) {
      numero = "0${controller.identifiant}";
    } else {
      numero = "${controller.identifiant}";
    }
    controller.matricule = "${prefix}COM$date-$numero";
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          initialValue: controller.matricule,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: controller.matricule,
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget dateNaissanceWidget() { 
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
             DateTime? dateNaissance = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                type: OmniDateTimePickerType.date,
                firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );

              setState(() {
                controller.dateNaissanceController = dateNaissance;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date de naissance")
                : ResponsiveChildWidget(
                    child1: const Text("Date de naissance"),
                    child2: Text("${controller.dateNaissanceController}"))));
  }

  Widget lieuNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.lieuNaissanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Lieu de naissance',
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

  Widget nationaliteWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Nationalite',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.nationalite,
        isExpanded: true,
        items: controller.world.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Nationalite" : null,
        onChanged: (value) {
          setState(() {
            controller.nationalite = value!;
          });
        },
      ),
    );
  }

  Widget typeContratWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contrat',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.typeContrat,
        isExpanded: true,
        items: controller.typeContratList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select contrat" : null,
        onChanged: (value) {
          setState(() {
            controller.typeContrat = value!;
          });
        },
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  Widget servicesAffectationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Service d\'affectation',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: controller.servicesAffectation,
          isExpanded: true,
          items: controller.servAffectList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select Service" : null,
          onChanged: (value) {
            setState(() {
              controller.servicesAffectation = value;
            });
          },
        ));
  }

  Widget dateDebutContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              DateTime? dateDebutContrat = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                type: OmniDateTimePickerType.date,
                firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );
              setState(() {
                controller.dateDebutContratController = dateDebutContrat;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date Debut Contrat")
                : ResponsiveChildWidget(
                    child1: const Text("Date Debut Contrat"),
                    child2: Text("${controller.dateNaissanceController}"))));
  }

  Widget dateFinContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              DateTime? dateFinContrat = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                type: OmniDateTimePickerType.date,
                firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );
              setState(() {
                controller.dateFinContratController = dateFinContrat;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date Fin Contrat")
                : ResponsiveChildWidget(
                    child1: const Text("Date Fin Contrat"),
                    child2: Text("${controller.dateNaissanceController}"))));
  }

  Widget fonctionOccupeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Fonction occupée',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: controller.fonctionOccupe,
          isExpanded: true,
          items: controller.fonctionList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select Fonction" : null,
          onChanged: (value) {
            setState(() {
              controller.fonctionOccupe = value;
            });
          },
        ));
  }

  Widget competanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Column(
          children: [
            flutter_quill.QuillToolbar.basic(
                controller: controller.competanceController),
            SizedBox(
              height: 400,
              child: Row(
                children: [
                  Expanded(
                    child: flutter_quill.QuillEditor(
                      controller: controller.competanceController,
                      readOnly: false, // true for view only mode
                      scrollController: ScrollController(),
                      scrollable: true,
                      focusNode: _focusNode,
                      autoFocus: false,
                      placeholder: 'Formation, Comptence, Experience, ...',
                      expands: true,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  // Widget experienceWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: Column(
  //     children: [
  //       flutter_quill.QuillToolbar.basic(controller: controller.experienceController),
  //       SizedBox(
  //         height: 300,
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: flutter_quill.QuillEditor(
  //                 controller: controller.experienceController,
  //                 readOnly: false, // true for view only mode
  //                 scrollController: ScrollController(),
  //                 scrollable: true,
  //                 focusNode: _focusNode,
  //                 autoFocus: false,
  //                 placeholder: 'Experience...',
  //                 expands: true,
  //                 padding: EdgeInsets.zero,
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   ));
  // }

  Widget salaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller.salaireController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Salaire',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text(monnaieStorage.monney,
                    style: Theme.of(context).textTheme.headlineSmall))
          ],
        ));
  }

  helpDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Accreditation'),
              content: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Niveau 0: PCA, Président",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 1: Directeur général",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 2: Directeur département (Gérant)",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 3: Chef de service",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 4: Personnel travailleur (Agent)",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 5: Stagiaire, Expert, Consultant, ...",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )),
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
