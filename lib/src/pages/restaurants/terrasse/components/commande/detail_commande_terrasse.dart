import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/helpers/monnaire_storage.dart';
import 'package:wm_com/src/models/restaurant/table_restaurant_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_terrasse.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/commande/bon_commande_terrasse.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/components/factures/pdf_a6/facture_terrasse_a6_pdf.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/table_terrasse_controller.dart';
import 'package:wm_com/src/pages/restaurants/terrasse/controller/terrasse_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/print_widget.dart';

class DetailCommandeTerrasse extends StatefulWidget {
  const DetailCommandeTerrasse({super.key, required this.tableRestaurantModel});
  final TableRestaurantModel tableRestaurantModel;

  @override
  State<DetailCommandeTerrasse> createState() => _DetailCommandeTerrasseState();
}

class _DetailCommandeTerrasseState extends State<DetailCommandeTerrasse> {
  final TableTerrasseController controller = Get.find();
  final TerrasseController terrasseController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final FactureTerrassePDFA6 factureCartPDFA6 = Get.put(FactureTerrassePDFA6());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Terrasse";

  Future<TableRestaurantModel> refresh() async {
    final TableRestaurantModel dataItem =
        await controller.detailView(widget.tableRestaurantModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    var restaurants = terrasseController.restaurantList
        .where((p0) => p0.table == widget.tableRestaurantModel.table)
        .toList();
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.tableRestaurantModel.table),
      drawer: const DrawerMenuTerrasse(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuTerrasse())),
          Expanded(
              flex: 5,
              child: terrasseController.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!), (state) {
                var restaurantList = state!
                    .where((element) =>
                        element.table == widget.tableRestaurantModel.table &&
                        element.statutCommande == 'false')
                    .toList();
                return SingleChildScrollView(
                    controller: ScrollController(),
                    physics: const ScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.only(
                          top: Responsive.isMobile(context) ? 0.0 : p20,
                          bottom: p8,
                          right: Responsive.isMobile(context) ? 0 : p20,
                          left: Responsive.isMobile(context) ? 0 : p20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    "Commande ${widget.tableRestaurantModel.table} "
                                        .toUpperCase(),
                                    maxLines: 2,
                                    style: headlineSmall,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                refresh().then((value) =>
                                                    Navigator.pushNamed(
                                                        context,
                                                        TerrasseRoutes
                                                            .tableCommandeTerrasseDetail,
                                                        arguments: value));
                                              },
                                              icon: const Icon(Icons.refresh,
                                                  color: Colors.green)),
                                          PrintWidget(
                                              tooltip:
                                                  'Imprimer le bon de commande',
                                              onPressed: () {
                                                BonCommandeTerrassePDFA6()
                                                    .generatePdf(
                                                        widget
                                                            .tableRestaurantModel
                                                            .table,
                                                        restaurants,
                                                        monnaieStorage.monney);
                                              }),
                                          if (restaurants.isEmpty) editButton(),
                                          if (restaurants.isEmpty)
                                            deleteButton(),
                                        ],
                                      ),
                                      SelectableText(
                                          DateFormat("dd-MM-yy HH:mm").format(
                                              widget.tableRestaurantModel
                                                  .created),
                                          textAlign: TextAlign.start),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: p20),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: restaurantList.length,
                                  itemBuilder: (context, index) {
                                    final data = restaurantList[index];
                                    bool isDelivry = false;
                                    if (data.statutCommande == 'false') {
                                      isDelivry = false;
                                    } else if (data.statutCommande == 'true') {
                                      isDelivry = true;
                                    }
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            // An action can be bigger than the others.
                                            flex: 2,
                                            onPressed: (context) =>
                                                showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: Text(
                                                    'Etes-vous sûr de supprimer ceci?',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red.shade700)),
                                                content: Obx(() => controller
                                                        .isLoading
                                                    ? loading()
                                                    : const Text(
                                                        'Cette action permet de retirer cette commande.')),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: Text('Annuler',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .red.shade700)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      terrasseController
                                                          .deleteData(data.id!);
                                                      Navigator.pop(
                                                          context, 'ok');
                                                    },
                                                    child: Text('OK',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .red.shade700)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.cancel,
                                            label: 'Annuler commande',
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        child: ListTile(
                                          leading: const Icon(
                                              Icons.table_bar_outlined,
                                              size: p40),
                                          title: Text(
                                              data.identifiant.capitalizeFirst!,
                                              style: bodyMedium),
                                          subtitle: Text(
                                              "Qty: ${NumberFormat.decimalPattern('fr').format(double.parse(data.qty))} ${data.unite}",
                                              style: bodyMedium),
                                          trailing: SizedBox(
                                            width: 200,
                                            child: Obx(() => terrasseController
                                                    .isLoading
                                                ? loading()
                                                : Switch(
                                                    value: isDelivry,
                                                    onChanged: (value) {
                                                      String isChangeStatut =
                                                          'false';
                                                      if (value == true) {
                                                        isChangeStatut = 'true';
                                                      } else {
                                                        isChangeStatut =
                                                            'false';
                                                      }
                                                      terrasseController
                                                          .statutSubmit(data,
                                                              isChangeStatut);
                                                    })),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                          const SizedBox(height: p20),
                        ],
                      ),
                    ));
              }))
        ],
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification du nom",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:
              Text('Modification du nom', style: TextStyle(color: mainColor)),
          content: SizedBox(
            height: 200,
            child: Obx(() => controller.isLoading
                ? loading()
                : Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        nomTabletWidget(),
                      ],
                    ))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                controller.submitUpdate(widget.tableRestaurantModel);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget nomTabletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.tableController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom de la table',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
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
                controller.deleteData(widget.tableRestaurantModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: Text('OK', style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        ),
      ),
    );
  }
}
