import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/commercial/restitution_model.dart';
import 'package:wm_com/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/commercial/components/restitution/restitution_pdf.dart';
import 'package:wm_com/src/pages/commercial/controller/restitution/restitution_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/print_widget.dart';
import 'package:wm_com/src/widgets/responsive_child_widget.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class DetailRestitution extends StatefulWidget {
  const DetailRestitution({super.key, required this.restitutionModel});
  final RestitutionModel restitutionModel;

  @override
  State<DetailRestitution> createState() => _DetailRestitutionState();
}

class _DetailRestitutionState extends State<DetailRestitution> {
  final RestitutionController controller = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  bool isChecked = false;

  Future<RestitutionModel> refresh() async {
    final RestitutionModel dataItem =
        await controller.detailView(widget.restitutionModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.restitutionModel.idProduct),
      drawer: const DrawerMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: p20, bottom: p8, right: p20, left: p20),
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
                                    const TitleWidget(
                                        title: "Bon de livraison"),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  refresh().then((value) =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComRoutes
                                                              .comRestitutionDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            PrintWidget(
                                              tooltip: 'Imprimer le document',
                                              onPressed: () async {
                                                await RestitutionPdf.generate(
                                                    widget.restitutionModel);
                                              },
                                            ),
                                          ],
                                        ),
                                        SelectableText(
                                            DateFormat("dd-MM-yyyy HH:mm")
                                                .format(widget
                                                    .restitutionModel.created),
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  ],
                                ),
                                dataWidget(controller, profilController),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget dataWidget(
      RestitutionController controller, ProfilController profilController) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          if (widget.restitutionModel.succursale ==
              profilController.user.succursale)
            accRecepetion(controller),
          const SizedBox(height: p20),
          ResponsiveChildWidget(
              child1: Text('Produit :',
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible),
              child2: Text(widget.restitutionModel.idProduct,
                  style: bodyMedium, overflow: TextOverflow.visible)),
          Divider(
            color: mainColor,
          ),
          ResponsiveChildWidget(
              child1: Text('Quantité restutué :',
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
              child2: Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(widget.restitutionModel.quantity))} ${widget.restitutionModel.unite}',
                  style: bodyMedium,
                  overflow: TextOverflow.ellipsis))
        ],
      ),
    );
  }

  Widget accRecepetion(RestitutionController controller) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Card(
      child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Accusé reception:',
                    style: Responsive.isDesktop(context)
                        ? const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)
                        : bodyLarge),
                const SizedBox(
                  width: 10.0,
                ),
                (widget.restitutionModel.accuseReception == 'false')
                    ? checkboxRead(controller)
                    : Text('OK',
                        style: Responsive.isDesktop(context)
                            ? const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.green)
                            : bodyLarge!.copyWith(color: Colors.green)),
              ],
            ),
          )),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(RestitutionController controller) {
    isChecked = widget.restitutionModel.accuseReception == 'true';
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
          controller.receptionProduit(widget.restitutionModel);
        });
      },
    );
  }
}
