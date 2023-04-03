import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_vip.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/vip/components/produit_model/table_produit_vip_model.dart';
import 'package:wm_com/src/pages/restaurants/vip/controller/prod_model_vip_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class ProdModelVipPage extends StatefulWidget {
  const ProdModelVipPage({super.key});

  @override
  State<ProdModelVipPage> createState() => _ProdModelVipPageState();
}

class _ProdModelVipPageState extends State<ProdModelVipPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Vip";
  String subTitle = "Menu";

  @override
  Widget build(BuildContext context) {
    final ProdModelVipController controller = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuVip(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Nouveau Menu",
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(VipRoutes.prodModelVipAdd);
                })
            : FloatingActionButton.extended(
                label: const Text("Nouveau Menu"),
                tooltip: "Nouveau Menu",
                icon: const Icon(Icons.add),
                onPressed: () {
                  Get.toNamed(VipRoutes.prodModelVipAdd);
                }),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    (data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableProduitVipModel(
                            produitModelList: controller.produitModelList,
                            controller: controller,
                            title: title,
                          ),
                        ))),
          ],
        ));
  }
}
