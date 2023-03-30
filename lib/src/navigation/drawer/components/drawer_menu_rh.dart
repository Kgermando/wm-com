import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuRH extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenuRH({Key? key}) : super(key: key);
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
              selected: currentRoute == RhRoutes.rhDashboard,
              icon: Icons.dashboard,
              sizeIcon: 15.0,
              title: 'Dashboard',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(RhRoutes.rhDashboard);
              }),
          DrawerWidget(
              selected: currentRoute == RhRoutes.rhPersonnelsPage,
              icon: Icons.group,
              sizeIcon: 20.0,
              title: 'Personnels',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RhRoutes.rhPersonnelsPage);
              }),
          DrawerWidget(
              selected: currentRoute == RhRoutes.rhUserActif,
              icon: Icons.group,
              sizeIcon: 20.0,
              title: 'Personnels Actifs',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RhRoutes.rhUserActif);
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
