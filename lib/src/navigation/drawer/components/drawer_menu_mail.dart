import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuMail extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenuMail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final ProfilController profilController = Get.find();

    return Drawer(
        child: profilController.obx(
            onLoading: loadingDrawer(),
            onError: (error) => loadingError(context, error!), (user) {
      return ListView(
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () => Get.toNamed(HomeRoutes.home),
            child: DrawerHeader(
                child: Image.asset(
              InfoSystem().logo(),
              width: 100,
              height: 100,
            )),
          ),
          DrawerWidget(
              selected: currentRoute == MailRoutes.mails,
              icon: Icons.inbox,
              sizeIcon: 20.0,
              title: 'Boite de reception',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(MailRoutes.mails);
              }),
          DrawerWidget(
              selected: currentRoute == MailRoutes.mailSend,
              icon: Icons.send,
              sizeIcon: 20.0,
              title: "Boite d'envoie",
              style: bodyMedium,
              onTap: () {
                Get.toNamed(MailRoutes.mailSend);
              }),
          DrawerWidget(
              selected: false,
              icon: Icons.chat,
              sizeIcon: 20.0,
              title: "Messenger",
              style: bodyMedium,
              onTap: () {
                // Get.toNamed(MailRoutes.mailSend);
              }),
          if (GetPlatform.isWindows)
            UpdateNav(
              currentRoute: currentRoute,
            )
        ],
      );
    }));
  }
}
