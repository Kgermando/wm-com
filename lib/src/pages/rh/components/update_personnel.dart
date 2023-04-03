import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_rh.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_com/src/utils/dropdown.dart';
import 'package:wm_com/src/utils/regex.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class UpdatePersonnel extends StatefulWidget {
  const UpdatePersonnel({super.key, required this.personne});
  final AgentModel personne;

  @override
  State<UpdatePersonnel> createState() => _UpdatePersonnelState();
}

class _UpdatePersonnelState extends State<UpdatePersonnel> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final PersonnelsController controller = Get.find();
  final UsersController usersController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Ressources Humaines";

  List<String> departementSelected = [];

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // photo = widget.personne.photo!;

    controller.matricule = widget.personne.matricule;
    controller.sexe = widget.personne.sexe;
    controller.role = widget.personne.role;
    controller.nationalite = widget.personne.nationalite;
    controller.typeContrat = widget.personne.typeContrat;
    controller.servicesAffectation = widget.personne.servicesAffectation;
    controller.fonctionOccupe = widget.personne.fonctionOccupe;
    controller.nomController = TextEditingController(text: widget.personne.nom);
    controller.postNomController =
        TextEditingController(text: widget.personne.postNom);
    controller.prenomController =
        TextEditingController(text: widget.personne.prenom);
    controller.emailController =
        TextEditingController(text: widget.personne.email);
    controller.telephoneController =
        TextEditingController(text: widget.personne.telephone);
    controller.adresseController =
        TextEditingController(text: widget.personne.adresse);
    controller.lieuNaissanceController =
        TextEditingController(text: widget.personne.lieuNaissance);

    controller.salaireController =
        TextEditingController(text: widget.personne.salaire);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title,
          "${widget.personne.prenom} ${widget.personne.nom}"),
      drawer: const DrawerMenuRH(),
      body: Row(
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuRH())),
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
                          child: Column(children: [
                            const TitleWidget(title: "Modification du profil"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                fichierWidget(),
                              ],
                            ),
                            const SizedBox(height: p20),
                            ResponsiveChildWidget(
                                child1: nomWidget(controller),
                                child2: postNomWidget(controller)),
                            ResponsiveChildWidget(
                                child1: prenomWidget(controller),
                                child2: sexeWidget(controller)),
                            ResponsiveChildWidget(
                                child1: dateNaissanceWidget(),
                                child2: lieuNaissanceWidget(controller)),
                            ResponsiveChildWidget(
                                child1: nationaliteWidget(controller),
                                child2: adresseWidget(controller)),
                            ResponsiveChildWidget(
                                child1: emailWidget(controller),
                                child2: telephoneWidget(controller)),
                            // departmentWidget(controller),
                            servicesAffectationWidget(controller),
                            ResponsiveChildWidget(
                                child1: matriculeWidget(controller),
                                child2: Container()),
                            ResponsiveChildWidget(
                                child1: fonctionOccupeWidget(controller),
                                child2: roleWidget(controller)),
                            ResponsiveChildWidget(
                                child1: typeContratWidget(controller),
                                child2: salaireWidget(controller)),
                            ResponsiveChildWidget(
                                child1: dateDebutContratWidget(),
                                child2: (controller.typeContrat == 'CDD')
                                    ? dateFinContratWidget()
                                    : Container()),
                            competanceWidget(),
                            // experienceWidget(),
                            const SizedBox(height: p20),
                            Obx(() => BtnWidget(
                                title: 'Soumettre modification',
                                isLoading: controller.isLoading,
                                press: () {
                                  final form = controller.formKey.currentState!;
                                  if (form.validate()) {
                                    if (widget.personne.statutAgent ==
                                        "Actif") {
                                      usersController
                                          .deleteUser(widget.personne);
                                    }
                                    controller.submitUpdate(widget.personne);
                                    form.reset();
                                  }
                                }))
                          ]),
                        ),
                      ),
                    )),
              ))
        ],
      ),
    );
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
                        url: widget.personne.photo!,
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

  Widget nomWidget(PersonnelsController controller) {
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

  Widget postNomWidget(PersonnelsController controller) {
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

  Widget prenomWidget(PersonnelsController controller) {
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

  Widget emailWidget(PersonnelsController controller) {
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
          validator: (value) => RegExpIsValide().validateEmail(value),
        ));
  }

  Widget telephoneWidget(PersonnelsController controller) {
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

  Widget adresseWidget(PersonnelsController controller) {
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

  Widget sexeWidget(PersonnelsController controller) {
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

  Widget roleWidget(PersonnelsController controller) {
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
                    helpDialog(controller);
                  },
                  icon: const Icon(Icons.help)))
        ],
      ),
    );
  }

  Widget matriculeWidget(PersonnelsController controller) {
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
    DateTime? dateTime;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              dateTime = await showOmniDateTimePicker(
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
                controller.dateNaissanceController = dateTime;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date de naissance")
                : Text("${controller.dateNaissanceController}")));
  }

  Widget lieuNaissanceWidget(PersonnelsController controller) {
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

  Widget nationaliteWidget(PersonnelsController controller) {
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

  Widget typeContratWidget(PersonnelsController controller) {
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

  Widget servicesAffectationWidget(PersonnelsController controller) {
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
              DateTime? dateTime = await showOmniDateTimePicker(
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
                controller.dateDebutContratController = dateTime;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date Debut Contrat")
                : Text("${controller.dateNaissanceController}")));
  }

  Widget dateFinContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              DateTime? dateTime = await showOmniDateTimePicker(
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
                controller.dateFinContratController = dateTime;
              });
            },
            icon: const Icon(Icons.calendar_month),
            label: (controller.dateNaissanceController == null)
                ? const Text("Date Fin Contrat")
                : Text("${controller.dateNaissanceController}")));
  }

  Widget fonctionOccupeWidget(PersonnelsController controller) {
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
  //   var json = jsonDecode(widget.personne.experience!);
  //   controller.experienceController = flutter_quill.QuillController(
  //       document: flutter_quill.Document.fromJson(json),
  //       selection: const TextSelection.collapsed(offset: 0));
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: Column(
  //         children: [
  //           flutter_quill.QuillToolbar.basic(
  //               controller: controller.experienceController),
  //           SizedBox(
  //             height: MediaQuery.of(context).size.height / 1.5,
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: flutter_quill.QuillEditor(
  //                     controller: controller.experienceController,
  //                     readOnly: false, // true for view only mode
  //                     scrollController: ScrollController(),
  //                     scrollable: true,
  //                     focusNode: _focusNode,
  //                     autoFocus: false,
  //                     placeholder: 'Ecrire votre rapport ici...',
  //                     expands: true,
  //                     padding: EdgeInsets.zero,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ));
  // }

  Widget salaireWidget(PersonnelsController controller) {
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

  helpDialog(PersonnelsController controller) {
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
                      Text("Niveau 2: Directeur département",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 3: Chef de service",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 4: Personnel travailleur (perosne)",
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
