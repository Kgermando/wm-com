import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/produit_model/table_produit_terrasse_model.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/prod_model_terrasse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ProdModelTerrassePage extends StatefulWidget {
  const ProdModelTerrassePage({super.key});

  @override
  State<ProdModelTerrassePage> createState() => _ProdModelTerrassePageState();
}

class _ProdModelTerrassePageState extends State<ProdModelTerrassePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";
  String subTitle = "Menu";

  @override
  Widget build(BuildContext context) {
    final ProdModelTerrasseController controller = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuTerrasse(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Nouveau Menu",
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(TerrasseRoutes.prodModelTerrasseAdd);
                })
            : FloatingActionButton.extended(
                label: const Text("Ajout Nouveau Menu"),
                tooltip: "Nouveau Menu",
                icon: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(TerrasseRoutes.prodModelTerrasseAdd);
                }),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuTerrasse())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableProduitTerrasseModel(
                            produitModelList: controller.produitModelList,
                            controller: controller,
                            title: title,
                          ),
                        ))),
          ],
        ));
  }
}
