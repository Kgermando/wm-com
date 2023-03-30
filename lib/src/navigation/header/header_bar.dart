import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/constants/style.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/controllers/network_controller.dart';
import 'package:wm_com/src/models/menu_item.dart';
import 'package:wm_com/src/models/update/update_model.dart';
import 'package:wm_com/src/pages/auth/controller/login_controller.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/update/controller/update_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/utils/menu_items.dart';
import 'package:wm_com/src/utils/menu_options.dart';
import 'package:wm_com/src/widgets/bread_crumb_widget.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';

AppBar headerBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    String title, String subTitle) {
  final ProfilController profilController = Get.put(ProfilController());
  final DepartementNotifyCOntroller departementNotifyCOntroller =
      Get.put(DepartementNotifyCOntroller());
  final UpdateController updateController = Get.put(UpdateController());
  final NetworkController networkController = Get.put(NetworkController());
  final currentRoute = Get.currentRoute;
  final bodyLarge = Theme.of(context).textTheme.bodyLarge;

  return AppBar(
    leadingWidth: 100,
    leading: Responsive.isDesktop(context)
        ? InkWell(
            onTap: () => Get.toNamed(HomeRoutes.home),
            child: Image.asset(
              InfoSystem().logoIcon(),
              width: 20,
              height: 20,
            ),
          )
        : (currentRoute == HomeRoutes.home)
            ? InkWell(
                onTap: () => Get.toNamed(HomeRoutes.home),
                child: Image.asset(
                  InfoSystem().logoIcon(),
                  width: 20,
                  height: 20,
                ),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                }),
    title: Responsive.isMobile(context)
        ? Container()
        : (currentRoute == HomeRoutes.home) ? InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                BreadCrumb(
                  overflow: ScrollableOverflow(
                      keepLastDivider: false,
                      reverse: false,
                      direction: Axis.horizontal),
                  items: <BreadCrumbItem>[
                    BreadCrumbItem(content: BreadCrumbWidget(title: title)),
                    (Responsive.isMobile(context))
                        ? BreadCrumbItem(content: Container())
                        : BreadCrumbItem(
                            content: BreadCrumbWidget(title: subTitle)),
                  ],
                  divider: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ) : Container(),
    actions: [
      if (!GetPlatform.isWeb && networkController.connectionStatus == 1)
        Obx(() => departementNotifyCOntroller.isLoading
            ? loadingMini()
            : IconButton(
                onPressed: () {
                  departementNotifyCOntroller.syncData();
                },
                icon: const Icon(Icons.sync, color: Colors.green))),
      Obx(() => (networkController.connectionStatus == 1 &&
              GetPlatform.isWindows &&
              updateController.updateVersionList.isNotEmpty &&
              updateController.sumVersionCloud >
                  updateController.sumLocalVersion)
          ? IconButton(
              iconSize: 40,
              tooltip: 'Téléchargement',
              onPressed: () async {
                bool result = await InternetConnectionChecker().hasConnection;
                if (result == true) {
                  var updateList =
                      await updateController.updateVersionApi.getAllData();
                  UpdateModel updateModel = updateList.last;
                  Get.toNamed('/update/${updateModel.id!}',
                      arguments: updateModel);
                }
              },
              icon: (updateController.isDownloading)
                  ? (updateController.progressString == "100%")
                      ? const Icon(Icons.check)
                      : Obx(() => AutoSizeText(updateController.progressString,
                          maxLines: 1, style: const TextStyle(fontSize: 12.0)))
                  : Icon(Icons.download, color: Colors.red.shade700))
          : Container()),
      profilController.obx(onLoading: loadingMini(), (state) {
        final String firstLettter = state!.prenom[0];
        final String firstLettter2 = state.nom[0];
        return Row(
          children: [
            IconButton(
                tooltip: 'Panier',
                onPressed: () {
                  Get.toNamed(ComRoutes.comCart);
                },
                icon: Obx(() => badges.Badge(
                      showBadge:
                          (departementNotifyCOntroller.cartItemCount >= 1)
                              ? true
                              : false,
                      badgeContent: Text(
                          departementNotifyCOntroller.cartItemCount.toString(),
                          style: const TextStyle(color: Colors.white)),
                      child: const Icon(Icons.shopping_cart_outlined),
                    ))),
            IconButton(
                tooltip: 'Agenda',
                onPressed: () {
                  Get.toNamed(MarketingRoutes.marketingAgenda);
                },
                icon: Obx(() => badges.Badge(
                      showBadge:
                          (departementNotifyCOntroller.agendaItemCount >= 1)
                              ? true
                              : false,
                      badgeContent: Text(
                          departementNotifyCOntroller.agendaItemCount
                              .toString(),
                          style: const TextStyle(color: Colors.white)),
                      child: Icon(Icons.note_alt_outlined,
                          size: (Responsive.isDesktop(context) ? 25 : 20)),
                    ))),
            IconButton(
                tooltip: 'Annuaire',
                onPressed: () {
                  Get.toNamed(MarketingRoutes.marketingAnnuaire);
                },
                icon: const Icon(Icons.contact_phone)),
            if (profilController.user.matricule.contains("Support"))
              IconButton(
                  tooltip: 'Add update',
                  onPressed: () {
                    Get.bottomSheet(
                        useRootNavigator: true,
                        Scaffold(
                          body: Container(
                            // color: Colors.amber.shade100,
                            padding: const EdgeInsets.all(p20),
                            child: Form(
                              key: updateController.formKey,
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
                                  versionWidget(updateController),
                                  motifWidget(updateController),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      fichierWidget(context, updateController),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  Obx(() => BtnWidget(
                                      title: 'Soumettre',
                                      press: () {
                                        final form = updateController
                                            .formKey.currentState!;
                                        if (form.validate()) {
                                          updateController.submit();
                                          form.reset();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      isLoading: updateController.isLoading))
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                  icon: const Icon(Icons.system_update_alt, color: Colors.red)),
            if (!Responsive.isMobile(context))
              const SizedBox(
                width: p10,
              ),
            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            if (!Responsive.isMobile(context))
              const SizedBox(
                width: p20,
              ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: CircleAvatar(
                  child: AutoSizeText(
                    '$firstLettter$firstLettter2'.toUpperCase(),
                    maxLines: 1,
                    style: (Responsive.isMobile(context))
                        ? const TextStyle(fontSize: p8)
                        : const TextStyle(fontSize: p16),
                  ),
                )),
            if (Responsive.isDesktop(context)) const SizedBox(width: p8),
            if (Responsive.isDesktop(context))
              InkWell(
                onTap: () {
                  Get.toNamed(UserRoutes.profil);
                },
                child: AutoSizeText(
                  "${profilController.user.prenom} ${profilController.user.nom}",
                  maxLines: 1,
                  style: bodyLarge,
                ),
              ),
          ],
        );
      }),
      Obx(() => Get.find<LoginController>().loadingLogOut
          ? Row(
              children: [
                const SizedBox(width: p10),
                loadingMini(),
                const SizedBox(width: p10),
              ],
            )
          : PopupMenuButton<MenuItemModel>(
              onSelected: (item) => MenuOptions().onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(MenuOptions().buildItem).toList(),
                const PopupMenuDivider(),
                ...MenuItems.itemsSecond.map(MenuOptions().buildItem).toList(),
              ],
            ))
    ],
    iconTheme: IconThemeData(color: dark),
    elevation: 0,
    // backgroundColor: Colors.transparent,
  );
}

Widget versionWidget(UpdateController updateController) {
  return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: TextFormField(
        controller: updateController.versionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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

Widget motifWidget(UpdateController updateController) {
  return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: TextFormField(
        controller: updateController.motifController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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

Widget fichierWidget(BuildContext context, UpdateController updateController) {
  return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: Obx(() => updateController.isUploading
          ? const SizedBox(
              height: p20, width: 50.0, child: LinearProgressIndicator())
          : TextButton.icon(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['msix'],
                );
                if (result != null) {
                  updateController.uploadFile(result.files.single.path!);
                } else {
                  const Text("Votre fichier n'existe pas");
                }
              },
              icon: updateController.isUploadingDone
                  ? Icon(Icons.check_circle_outline,
                      color: Colors.green.shade700)
                  : const Icon(Icons.upload_file),
              label: updateController.isUploadingDone
                  ? Text("Téléchargement terminé",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.green.shade700))
                  : Text("Selectionner le fichier",
                      style: Theme.of(context).textTheme.bodyLarge))));
}
