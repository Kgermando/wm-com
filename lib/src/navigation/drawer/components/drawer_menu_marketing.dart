import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuMarketing extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenuMarketing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final ProfilController profilController = Get.find();

    return Drawer(
        child: profilController.obx(
            onLoading: loadingDrawer(),
            onError: (error) => loadingError(context, error!), (user) {
      return Obx(() => ListView(
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
          // DrawerWidget(
          //     selected: currentRoute == RhRoutes.comDashboard,
          //     icon: Icons.dashboard,
          //     sizeIcon: 15.0,
          //     title: 'Dashboard',
          //     style: bodyMedium!,
          //     onTap: () {
          //       Get.toNamed(RhRoutes.comDashboard);
          //     }),
          DrawerWidget(
              selected: currentRoute == MarketingRoutes.marketingAnnuaire,
              icon: Icons.contact_phone,
              sizeIcon: 20.0,
              title: 'Annuaire',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(MarketingRoutes.marketingAnnuaire);
              }),
          DrawerWidget(
              selected: currentRoute == MarketingRoutes.marketingAgenda,
              icon: Icons.note_alt,
              sizeIcon: 20.0,
              title: 'Agenda',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(MarketingRoutes.marketingAgenda);
              }),
          if (GetPlatform.isWindows)
            UpdateNav(
              currentRoute: currentRoute,
            )
        ],
      )) ;
    }));
  }
}
