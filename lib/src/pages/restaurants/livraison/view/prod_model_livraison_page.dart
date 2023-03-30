import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_livraison.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/livraison/components/produit_model/table_produit_livraison_model.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/prod_model_livraison_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ProdModelLivraisonPage extends StatefulWidget {
  const ProdModelLivraisonPage({super.key});

  @override
  State<ProdModelLivraisonPage> createState() => _ProdModelLivraisonPageState();
}

class _ProdModelLivraisonPageState extends State<ProdModelLivraisonPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Livraison";
  String subTitle = "Produit Modèle";

  @override
  Widget build(BuildContext context) {
    final ProdModelLivraisonController controller = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuLivraison(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Nouveau produit modèle",
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(LivraisonRoutes.prodModelLivraisonAdd);
                })
            : FloatingActionButton.extended(
                label: const Text("Ajout produit modèle"),
                tooltip: "Nouveau produit modèle",
                icon: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(LivraisonRoutes.prodModelLivraisonAdd);
                }),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenuLivraison())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableProduitLivraisonModel(
                            produitModelList: controller.produitModelList,
                            controller: controller,
                            title: title,
                          ),
                        ))),
          ],
        ));
  }
}
