import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/ventes/vente_vip_items_widget.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/vip_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class VenteVipPage extends StatefulWidget {
  const VenteVipPage({super.key});

  @override
  State<VenteVipPage> createState() => _VenteVipPageState();
}

class _VenteVipPageState extends State<VenteVipPage> {
  final ProdModelVipController controller = Get.find();
  final VipController restaurantController = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Ventes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuVip(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuVip())),
          Expanded(
              flex: 5,
              child: controller.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!),
                  (state) => SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Obx(() => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TitleWidget(title: title),
                                const SizedBox(height: p20),
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
                                          Navigator.pushNamed(
                                              context, VipRoutes.venteVip);
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
                                      return VenteVipItemWidget(
                                        controller: controller,
                                        productModel: data,
                                        profilController: profilController,
                                        vipController: restaurantController,
                                      );
                                    })
                              ],
                            ),
                          )))))
        ],
      ),
    );
  }
}
