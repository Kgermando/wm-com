import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuRestaurant extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenuRestaurant({Key? key}) : super(key: key);
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
              selected: currentRoute == RestaurantRoutes.dashboardRestaurant,
              icon: Icons.dashboard,
              sizeIcon: 15.0,
              title: 'Dashboard',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(RestaurantRoutes.dashboardRestaurant);
              }),
          DrawerWidget(
              selected: currentRoute == RestaurantRoutes.venteRestaurant,
              icon: Icons.format_list_numbered_sharp,
              sizeIcon: 20.0,
              title: 'Ventes',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.venteRestaurant);
              }),
          DrawerWidget(
              selected:
                  currentRoute == RestaurantRoutes.tableCommandeRestaurant,
              icon: Icons.table_bar_outlined,
              sizeIcon: 20.0,
              title: 'Commandes',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.tableCommandeRestaurant);
              }),
          DrawerWidget(
              selected:
                  currentRoute == RestaurantRoutes.tableConsommationRestaurant,
              icon: Icons.table_bar,
              sizeIcon: 20.0,
              title: 'Consommations',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.tableConsommationRestaurant);
              }),
          DrawerWidget(
              selected: currentRoute == RestaurantRoutes.prodModelRestaurant,
              icon: Icons.production_quantity_limits,
              sizeIcon: 20.0,
              title: 'Identifiant Produit',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.prodModelRestaurant);
              }),
          DrawerWidget(
              selected: currentRoute == RestaurantRoutes.factureRestaurant,
              icon: Icons.receipt_long,
              sizeIcon: 20.0,
              title: 'Factures',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.factureRestaurant);
              }),
          DrawerWidget(
              selected: currentRoute == RestaurantRoutes.ventEffectueRestaurant,
              icon: Icons.history,
              sizeIcon: 20.0,
              title: 'Ventes effectués',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RestaurantRoutes.ventEffectueRestaurant);
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
