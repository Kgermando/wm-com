import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_restaurant.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/components/ventes/vente_rest_items_widget.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/prod_model_restaurant_controller.dart';
import 'package:wm_com/src/pages/restaurants/restaurant/controller/restaurant_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class VenteRestaurantPage extends StatefulWidget {
  const VenteRestaurantPage({super.key});

  @override
  State<VenteRestaurantPage> createState() => _VenteRestaurantPageState();
}

class _VenteRestaurantPageState extends State<VenteRestaurantPage> {
  final ProdModelRestaurantController controller = Get.find();
  final RestaurantController restaurantController = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Restaurant";
  String subTitle = "Ventes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuRestaurant(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              RestaurantRoutes.venteRestaurant);
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
                                      return VenteRestItemWidget(
                                          controller: controller,
                                          productModel: data,
                                          profilController: profilController,
                                          restaurantController:
                                              restaurantController);
                                    })
                              ],
                            )),
                      ))))
        ],
      ),
    );
  }
}
