import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/commercial/prod_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/prod_model_terrasse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailProdModelTerrasse extends StatefulWidget {
  const DetailProdModelTerrasse({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<DetailProdModelTerrasse> createState() =>
      _DetailProdModelTerrasseState();
}

class _DetailProdModelTerrasseState extends State<DetailProdModelTerrasse> {
  final ProdModelTerrasseController controller = Get.find();
  final ProfilController profilController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";

  Future<ProductModel> refresh() async {
    final ProductModel dataItem =
        await controller.detailView(widget.productModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:
          headerBar(context, scaffoldKey, title, widget.productModel.idProduct),
      drawer: const DrawerMenuTerrasse(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuTerrasse())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Responsive.isMobile(context) ? 0.0 : p20,
                        bottom: p8,
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: p20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TitleWidget(
                                        title: widget.productModel.identifiant),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  refresh().then((value) =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          TerrasseRoutes
                                                              .prodModelTerrasseDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            editButton(),
                                            deleteButton(),
                                          ],
                                        ),
                                        SelectableText(
                                            DateFormat("dd-MM-yyyy HH:mm")
                                                .format(widget
                                                    .productModel.created),
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  ],
                                ),
                                dataWidget()
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: p20),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de modifier ceci?',
              style: TextStyle(color: mainColor)),
          content: const Text('Cette action permet de modifier ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(TerrasseRoutes.prodModelTerrasseUpdate,
                    arguments: widget.productModel);
                // Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de supprimer ceci?',
              style: TextStyle(color: Colors.red.shade700)),
          content: Obx(() => controller.isLoading
              ? loading()
              : const Text(
                  'Cette action permet de supprimer définitivement ce document.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:
                  Text('Annuler', style: TextStyle(color: Colors.red.shade700)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.productModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ResponsiveChildWidget(
              child1: Text('Id Produit :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.productModel.idProduct,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Identifiant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(widget.productModel.identifiant,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Unité:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(widget.productModel.unite,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Prix:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(widget.productModel.price))} ${monnaieStorage.monney}",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(widget.productModel.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
        ],
      ),
    );
  }
}
