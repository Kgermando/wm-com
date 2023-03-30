import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/stock_global/list_stock_global.dart';
import 'package:wm_com/src/pages/commercial/controller/stock_global/stock_global_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class StockGlobalPage extends StatefulWidget {
  const StockGlobalPage({super.key});

  @override
  State<StockGlobalPage> createState() => _StockGlobalPageState();
}

class _StockGlobalPageState extends State<StockGlobalPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Stocks Global";

  @override
  Widget build(BuildContext context) {
    final StockGlobalController controller = Get.find();
    final ProfilController profilController = Get.find();

    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenu(),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton(
              tooltip: "Ajout le stock global",
              child: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed(ComRoutes.comStockGlobalAdd);
              },
            )
          : FloatingActionButton.extended(
              label: const Text("Ajouter stock"),
              tooltip: "Ajout le stock global",
              icon: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed(ComRoutes.comStockGlobalAdd);
              },
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
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
                        margin: const EdgeInsets.only(
                            top: p20, bottom: p8, right: p20, left: p20),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      controller.getList();
                                    },
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.green))
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.stockGlobalList.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      controller.stockGlobalList[index];
                                  return ListStockGlobal(
                                      stocksGlobalMOdel: data,
                                      role: profilController.user.role);
                                }),
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }
}
