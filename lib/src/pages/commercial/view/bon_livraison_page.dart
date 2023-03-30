import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/commercial/bon_livraison.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/controller/bon_livraison/bon_livraison_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class BonLivraisonPage extends StatefulWidget {
  const BonLivraisonPage({super.key});

  @override
  State<BonLivraisonPage> createState() => _BonLivraisonPageState();
}

class _BonLivraisonPageState extends State<BonLivraisonPage> {
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Bon de livraison";

  @override
  Widget build(BuildContext context) {
    final BonLivraisonController controller = Get.find();

    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenu(),
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
                  onError: (error) => loadingError(context, error!), (state) {
                List<BonLivraisonModel> bonLivraisonList = state!
                    .where((element) =>
                        element.succursale == profilController.user.succursale)
                    .toList();
                return SingleChildScrollView(
                    controller: ScrollController(),
                    physics: const ScrollPhysics(),
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: p20, bottom: p8, right: p20, left: p20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                              itemCount: bonLivraisonList.length,
                              itemBuilder: (context, index) {
                                final data = bonLivraisonList[index];
                                return bonLivraisonItemWidget(data);
                              }),
                        ],
                      ),
                    ));
              }))
        ],
      ),
    );
  }

  Widget bonLivraisonItemWidget(BonLivraisonModel bonLivraisonModel) {
    Color? nonRecu;
    if (bonLivraisonModel.accuseReception == 'false') {
      nonRecu = const Color(0xFFFFC400);
    }
    return GestureDetector(
      onTap: () {
        Get.toNamed(ComRoutes.comBonLivraisonDetail,
            arguments: bonLivraisonModel);
      },
      child: Card(
        elevation: 10,
        color: nonRecu,
        child: ListTile(
          hoverColor: grey,
          dense: true,
          leading: const Icon(
            Icons.description_outlined,
            size: 40.0,
          ),
          title: Text(bonLivraisonModel.succursale,
              overflow: TextOverflow.clip,
              style: Responsive.isDesktop(context)
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
          subtitle: Text(
            bonLivraisonModel.idProduct,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          trailing: Text(
            DateFormat("dd-MM-yyyy HH:mm").format(bonLivraisonModel.created),
          ),
        ),
      ),
    );
  }
}
