import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/archive/archive_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class AddArchive extends StatefulWidget {
  const AddArchive({super.key, required this.archiveFolderModel});
  final ArchiveFolderModel archiveFolderModel;

  @override
  State<AddArchive> createState() => _AddArchiveState();
}

class _AddArchiveState extends State<AddArchive> {
  final ArchiveController controller = Get.put(ArchiveController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.archiveFolderModel.folderName),
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
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: p20),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      TitleWidget(title: "Ajout archive")
                                    ],
                                  ),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  nomDocumentWidget(controller),
                                  ResponsiveChildWidget(
                                      child1: fichierWidget(controller),
                                      child2: Container()),
                                  levelWidget(),
                                  descriptionWidget(controller),
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
                                          controller.submit(
                                              widget.archiveFolderModel);
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

  Widget nomDocumentWidget(ArchiveController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomDocumentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du document',
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

  Widget descriptionWidget(ArchiveController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.descriptionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Legende',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
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

  Widget fichierWidget(ArchiveController controller) {
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
                    allowedExtensions: ['pdf', 'png', 'jpg'],
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
                    ? Text("Upload terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Selectionner le fichier",
                        style: Theme.of(context).textTheme.bodyLarge))));
  }

  Widget levelWidget() {
    List<String> roleList = ["1", "2", "3", "4", "5"];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Level',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.level,
        isExpanded: true,
        items: roleList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select level" : null,
        onChanged: (value) {
          setState(() {
            controller.level = value!;
          });
        },
      ),
    );
  }
}
