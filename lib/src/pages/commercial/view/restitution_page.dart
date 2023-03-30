import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/commercial/restitution_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/commercial/controller/restitution/restitution_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';

class RestitutionPage extends StatefulWidget {
  const RestitutionPage({super.key});

  @override
  State<RestitutionPage> createState() => _RestitutionPageState();
}

class _RestitutionPageState extends State<RestitutionPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Restitution stock";

  @override
  Widget build(BuildContext context) {
    final RestitutionController controller = Get.find();

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
                                itemCount: controller.restitutionList.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      controller.restitutionList[index];
                                  return restitutionItemWidget(data);
                                }),
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }

  Widget restitutionItemWidget(RestitutionModel restitutionModel) {
    Color? nonRecu;
    if (restitutionModel.accuseReception == 'false') {
      nonRecu = const Color(0xFFa4adbe);
    }
    return GestureDetector(
      onTap: () {
        Get.toNamed(ComRoutes.comRestitutionDetail,
            arguments: restitutionModel);
      },
      child: Card(
        elevation: 10,
        color: nonRecu,
        child: ListTile(
          hoverColor: grey,
          dense: true,
          leading: const Icon(
            Icons.description,
            size: 40.0,
          ),
          title: Text(restitutionModel.succursale,
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
            restitutionModel.idProduct,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
