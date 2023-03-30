import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/departement_notify_controller.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuCommercial extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenuCommercial({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final ProfilController profilController = Get.find();

    return Drawer(
        child: profilController.obx(
            onLoading: loadingDrawer(),
            onError: (error) => loadingError(context, error!), (user) {
      int userRole = int.parse(profilController.user.role);
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
              selected: currentRoute == ComRoutes.comDashboard,
              icon: Icons.dashboard,
              sizeIcon: 15.0,
              title: 'Dashboard',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(ComRoutes.comDashboard);
              }),
          DrawerWidget(
              selected: currentRoute == ComRoutes.comVente,
              icon: Icons.shopping_basket_sharp,
              sizeIcon: 15.0,
              title: 'Ventes',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ComRoutes.comVente);
              }),
          DrawerWidget(
              selected: currentRoute == ComRoutes.comAchat,
              icon: Icons.shopping_basket_sharp,
              sizeIcon: 15.0,
              title: 'Stock',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ComRoutes.comAchat);
              }),
          DrawerWidget(
              selected: currentRoute == ComRoutes.comCart,
              icon: Icons.shopping_cart,
              sizeIcon: 15.0,
              title: 'Panier',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ComRoutes.comCart);
              }),
          DrawerWidget(
              selected: currentRoute == ComRoutes.comFacture,
              icon: Icons.receipt_long,
              sizeIcon: 15.0,
              title: 'Facture',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ComRoutes.comFacture);
              }),
          if (userRole <= 3)
            DrawerWidget(
                selected: currentRoute == ComRoutes.comProduitModel,
                icon: Icons.verified,
                sizeIcon: 15.0,
                title: 'Identifiant Produit',
                style: bodyMedium,
                onTap: () {
                  Get.toNamed(ComRoutes.comProduitModel);
                }),
          DrawerWidget(
              selected: currentRoute == ComRoutes.comVenteEffectue,
              icon: Icons.checklist_rtl,
              sizeIcon: 15.0,
              title: 'Historique de Ventes',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ComRoutes.comVenteEffectue);
              }),
          if (userRole <= 3)
            DrawerWidget(
                selected: currentRoute == ComRoutes.comHistoryRavitaillement,
                icon: Icons.history,
                sizeIcon: 15.0,
                title: 'Historique de ravitaillements',
                style: bodyMedium,
                onTap: () {
                  Get.toNamed(ComRoutes.comHistoryRavitaillement);
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
