import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/ventes/vente_items_widget.dart';
import 'package:wm_com/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class VentePage extends StatefulWidget {
  const VentePage({super.key});

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  final AchatController controller = Get.find();
  final ProfilController profilController = Get.find();
  final CartController cartController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Ventes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuCommercial(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
          Expanded(
              flex: 5,
              child: controller.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!),
                  (state) => SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Container(
                          margin: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 0.0 : p20,
                            bottom: p8,
                            right: Responsive.isMobile(context) ? 0.0 : p20,
                            left: Responsive.isMobile(context) ? 0.0 : p20,
                          ),
                          // decoration: const BoxDecoration(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(20))),
                          child: Obx(() => Column(
                                children: [
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
                                              onChanged: (value) => controller
                                                  .onSearchText(value),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            controller.getList();
                                            Navigator.pushNamed(
                                                context, ComRoutes.comVente);
                                          },
                                          icon: const Icon(Icons.refresh,
                                              color: Colors.green))
                                    ],
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.venteList.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            controller.venteList[index];
                                        return VenteItemWidget(
                                          controller: controller,
                                          achat: data,
                                          profilController: profilController,
                                          cartController: cartController,
                                        );
                                      })
                                ],
                              ))))))
        ],
      ),
    );
  }
}
