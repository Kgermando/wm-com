import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/finance/controller/caisses/caisse_name_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/info_system.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';

class DrawerMenuFinance extends GetView<CaisseNameController> {
  const DrawerMenuFinance({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    return Drawer(
        child: controller.obx(
            onLoading: loadingDrawer(),
            onError: (error) => loadingError(context, error!), (state) {
      return ListView(
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () => Get.toNamed(HomeRoutes.home),
            child: DrawerHeader(
                child: Image.asset(
              InfoSystem().logo(),
              width: 100,
              height: 100,
            )),
          ),
          DrawerWidget(
              selected:
                  currentRoute == FinanceRoutes.transactionsCaisseDashbaord,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashbaord',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(FinanceRoutes.transactionsCaisseDashbaord);
              }),
          DrawerWidget(
              selected: false,
              icon: Icons.add_circle_outline_sharp,
              sizeIcon: 20.0,
              title: 'Nouvelle caisse',
              style: bodyMedium,
              onTap: () {
                caisseDialog(context, controller);
              }),
          Column(
            children: state!.map((element) {
              return DrawerWidget(
                  selected:
                      currentRoute == '/transactions-caisse/${element.id}',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: element.nomComplet.toUpperCase(),
                  style: bodyMedium,
                  onTap: () {
                    Get.toNamed('/transactions-caisse/${element.id!}',
                        arguments: element);
                  });
            }).toList(),
          ),
          // FinanceCaisseNav(
          //   currentRoute: currentRoute,
          //   user: user,
          //   departementList: departementList,
          //   controller: controller,
          //   caisseNameController: caisseNameController,
          // ),
          if (GetPlatform.isWindows)
            UpdateNav(
              currentRoute: currentRoute,
            )
        ],
      );
    }));
  }

  caisseDialog(
      BuildContext context, CaisseNameController caisseNameController) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            final titleLarge = Theme.of(context).textTheme.titleLarge;
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(p8),
                ),
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  height: 500,
                  // width: 400,
                  child: Form(
                    key: caisseNameController.formKey,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(p16),
                        child: ListView(
                          children: [
                            Text("Création d'une nouvelle Caisse",
                                style: titleLarge),
                            const SizedBox(
                              height: p20,
                            ),
                            nomCompletCaisseWidget(caisseNameController),
                            idNatCaisseWidget(caisseNameController),
                            addresseCaisseWidget(caisseNameController),
                            const SizedBox(
                              height: p20,
                            ),
                            Obx(() => BtnWidget(
                                title: 'Soumettre',
                                isLoading: caisseNameController.isLoading,
                                press: () {
                                  final form = caisseNameController
                                      .formKey.currentState!;
                                  if (form.validate()) {
                                    caisseNameController.submit();
                                    form.reset();
                                  }
                                }))
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  Widget nomCompletCaisseWidget(CaisseNameController caisseNameController) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: caisseNameController.nomCompletController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Titre',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget idNatCaisseWidget(CaisseNameController caisseNameController) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: caisseNameController.idNatController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N° Identifiant caisse',
          ),
          keyboardType: TextInputType.text,
          // validator: (value) => value != null && value.isEmpty
          //     ? 'Ce champs est obligatoire.'
          //     : null,
          style: const TextStyle(),
        ));
  }

  Widget addresseCaisseWidget(CaisseNameController caisseNameController) {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: caisseNameController.addresseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Emplacement (Facultatif)',
          ),
          keyboardType: TextInputType.text,
          // validator: (value) => value != null && value.isEmpty
          //     ? 'Ce champs est obligatoire.'
          //     : null,
          style: const TextStyle(),
        ));
  }
}
