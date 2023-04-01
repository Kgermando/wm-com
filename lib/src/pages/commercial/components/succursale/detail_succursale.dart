import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/succursale_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart'; 
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/stats_succusale.dart';
import 'package:wm_com/src/pages/commercial/components/succursale/view_succursale.dart';
import 'package:wm_com/src/pages/commercial/controller/succursale/succursale_controller.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';

class DetailSuccursale extends StatefulWidget {
  const DetailSuccursale({super.key, required this.succursaleModel});
  final SuccursaleModel succursaleModel;

  @override
  State<DetailSuccursale> createState() => _DetailSuccursaleState();
}

class _DetailSuccursaleState extends State<DetailSuccursale> {
  final SuccursaleController controller = Get.put(SuccursaleController());
  final ProfilController profilController = Get.find(); 
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  Future<SuccursaleModel> refresh() async {
    final SuccursaleModel dataItem =
        await controller.detailView(widget.succursaleModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      key: scaffoldKey,
      appBar:
          headerBar(context, scaffoldKey, title, widget.succursaleModel.name),
      drawer: const DrawerMenuCommercial(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuCommercial())),
          Expanded(
              flex: 5,
              child: DefaultTabController(
              length: 2,
              child: Column(
              children: [
                const BarreConnectionWidget(),
                const SizedBox(
                  height: 30,
                  child: TabBar(
                    physics: ScrollPhysics(),
                    tabs: [Tab(text: "Informations"), Tab(text: "Stats")],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const ScrollPhysics(),
                    children: [ 
                      Expanded(
                        child: ViewSuccursale(
                          succursaleModel: widget.succursaleModel, profilController: profilController, controller: controller, monnaieStorage: monnaieStorage)),
                      Expanded(
                        child: StatsSuccursale(
                          succursaleModel: widget.succursaleModel))
                    ],
                  ),
                ),
              ],
              )))
        ],
      ),
    );
  }

}
