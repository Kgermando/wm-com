import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_livraison.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/components/ventes/vente_livraison_items_widget.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/prod_model_livraison_controller.dart';
import 'package:wm_com/src/pages/restaurants/livraison/controller/livraison_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class VenteLivraisonPage extends StatefulWidget {
  const VenteLivraisonPage({super.key});

  @override
  State<VenteLivraisonPage> createState() => _VenteLivraisonPageState();
}

class _VenteLivraisonPageState extends State<VenteLivraisonPage> {
  final ProdModelLivraisonController controller = Get.find();
  final LivraisonController restaurantController = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Livraison";
  String subTitle = "Ventes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuLivraison(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  (state) => SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Column(
                              children: [
                                TitleWidget(title: title),
                                const SizedBox(height: p10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        child: ListTile(
                                          leading: const Icon(Icons.search),
                                          title: TextField(
                                            controller:
                                                controller.filterController,
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                              border: InputBorder.none,
                                              suffixIcon: controller
                                                      .filterController
                                                      .text
                                                      .isNotEmpty
                                                  ? GestureDetector(
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: Colors.red),
                                                      onTap: () {
                                                        controller
                                                            .filterController
                                                            .clear();
                                                        controller
                                                            .onSearchText('');
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      },
                                                    )
                                                  : null,
                                            ),
                                            onChanged: (value) =>
                                                controller.onSearchText(value),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          controller.getList();
                                          Navigator.pushNamed(context,
                                              LivraisonRoutes.venteLivraison);
                                        },
                                        icon: const Icon(Icons.refresh,
                                            color: Colors.green))
                                  ],
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.venteList.length,
                                    itemBuilder: (context, index) {
                                      final data = controller.venteList[index];
                                      return VenteLivraisonItemWidget(
                                        controller: controller,
                                        productModel: data,
                                        profilController: profilController,
                                        livraisonController:
                                            restaurantController,
                                      );
                                    })
                              ],
                            )),
                      ))))
        ],
      ),
    );
  }
}
