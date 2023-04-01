import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/pages/update/components/table_update.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/update/controller/update_controller.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final UpdateController controller = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Mise à jours";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, ''),
        drawer: const DrawerMenu(),
        floatingActionButton: (profilController.user.matricule
                .contains("Support"))
            ? FloatingActionButton.extended(
                label: const Text("Mise à jour"),
                tooltip: "Add Update",
                icon: const Icon(Icons.download),
                onPressed: () {
                  Get.bottomSheet(
                      useRootNavigator: true,
                      Scaffold(
                        body: Container(
                          // color: Colors.amber.shade100,
                          padding: const EdgeInsets.all(p20),
                          child: Form(
                            key: controller.formKey,
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Nouvelle mise à jour",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall)),
                                  ],
                                ),
                                const SizedBox(
                                  height: p20,
                                ),
                                versionWidget(),
                                motifWidget(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    fichierWidget(),
                                  ],
                                ),
                                const SizedBox(
                                  height: p20,
                                ),
                                Obx(() => BtnWidget(
                                    title: 'Soumettre',
                                    press: () {
                                      final form =
                                          controller.formKey.currentState!;
                                      if (form.validate()) {
                                        controller.submit();
                                        form.reset();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    isLoading: controller.isLoading))
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              )
            : Container(),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenu())),
            Expanded(
                flex: 5,
                child: Container(
                    margin: EdgeInsets.only(
                        top: Responsive.isMobile(context) ? 0.0 : p20,
                        bottom: p8,
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Obx(() => TableUpdate(
                        updateList: controller.updateVersionList,
                        controller: controller)))),
          ],
        ));
  }

  Widget versionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.versionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Version",
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget motifWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.motifController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Motif",
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget fichierWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Obx(() => controller.isUploading
            ? const SizedBox(
                height: p20, width: 50.0, child: LinearProgressIndicator())
            : TextButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['msix'],
                  );
                  if (result != null) {
                    controller.uploadFile(result.files.single.path!);
                  } else {
                    const Text("Votre fichier n'existe pas");
                  }
                },
                icon: controller.isUploadingDone
                    ? Icon(Icons.check_circle_outline,
                        color: Colors.green.shade700)
                    : const Icon(Icons.upload_file),
                label: controller.isUploadingDone
                    ? Text("Téléchargement terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Selectionner le fichier",
                        style: Theme.of(context).textTheme.bodyLarge))));
  }
}
