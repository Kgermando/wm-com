import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_restaurant.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/produit_model/table_produit_rest_model.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/prod_model_restaurant_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ProdModelRestaurantPage extends StatefulWidget {
  const ProdModelRestaurantPage({super.key});

  @override
  State<ProdModelRestaurantPage> createState() =>
      _ProdModelRestaurantPageState();
}

class _ProdModelRestaurantPageState extends State<ProdModelRestaurantPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Restaurant";
  String subTitle = "Produit Modèle";

  @override
  Widget build(BuildContext context) {
    final ProdModelRestaurantController controller = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuRestaurant(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Nouveau produit modèle",
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(RestaurantRoutes.prodModelRestaurantAdd);
                })
            : FloatingActionButton.extended(
                label: const Text("Ajout produit modèle"),
                tooltip: "Nouveau produit modèle",
                icon: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(RestaurantRoutes.prodModelRestaurantAdd);
                }),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuRestaurant())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableProduitRestModel(
                            produitModelList: controller.produitModelList,
                            controller: controller,
                            title: title,
                          ),
                        ))),
          ],
        ));
  }
}
