import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_commercial.dart'; 
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/history_livraison/table_history_livraison.dart';
import 'package:wm_com/src/pages/commercial/controller/history/history_livraison.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart'; 
import 'package:wm_com/src/widgets/loading.dart';

class HistoryLivraisonPage extends StatefulWidget {
  const HistoryLivraisonPage({super.key});

  @override
  State<HistoryLivraisonPage> createState() => _HistoryLivraisonPageState();
}

class _HistoryLivraisonPageState extends State<HistoryLivraisonPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Historique des Livraisons";

  @override
  Widget build(BuildContext context) {
    final HistoryLivraisonController controller = Get.find();
    final ProfilController profilController = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenuCommercial(),
        body: Row(
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
                    (state) => Column(
                      children: [
                        const BarreConnectionWidget(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TableHistoryLivraison(
                                livraisonHistoryList: state!,
                                profilController: profilController),
                          ),
                        ),
                      ],
                    ))),
          ],
        ));
  }
}
