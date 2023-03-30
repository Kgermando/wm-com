import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_marketing.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_com/src/pages/marketing/components/agenda/agenda_card_widget.dart';
import 'package:wm_com/src/pages/marketing/controller/agenda/agenda_controller.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/utils/list_colors.dart';
import 'package:wm_com/src/widgets/loading.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final AgendaController controller = Get.find();
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Marketing";
  String subTitle = "Agenda";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenuMarketing(),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton(
              tooltip: "Ajout un rappel",
              child: const Icon(Icons.add),
              onPressed: () {
                newFicheDialog();
              },
            )
          : FloatingActionButton.extended(
              label: const Text("Ajouter rappel"),
              tooltip: "Ajout un rappel",
              icon: const Icon(Icons.add),
              onPressed: () {
                newFicheDialog();
              },
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuMarketing())),
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
                        margin: EdgeInsets.only(
                            top: Responsive.isMobile(context) ? 0.0 : p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: buildAgenda(controller, profilController),
                      ))))
        ],
      ),
    );
  }

  Widget buildAgenda(
      AgendaController controller, ProfilController profilController) {
    var dataList = controller.agendaList
        .where((p0) => p0.signature == profilController.user.matricule)
        .toList();
    return StaggeredGrid.count(
      crossAxisCount: Responsive.isDesktop(context) ? 6 : 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: List.generate(dataList.length, (index) {
        final agenda = dataList[index];
        final color = listColors[index % listColors.length];
        return GestureDetector(
          onTap: () {
            Get.toNamed(MarketingRoutes.marketingAgendaDetail,
                arguments: AgendaColor(agendaModel: agenda, color: color));
          },
          child:
              AgendaCardWidget(agendaModel: agenda, index: index, color: color),
        );
      }),
    );
  }

  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: Text('Ajout Rappel', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 450,
                  width: 500,
                  child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: p20),
                          dateRappelWidget(),
                          const SizedBox(height: p16),
                          buildTitle(),
                          const SizedBox(height: p16),
                          buildDescription(),
                          const SizedBox(
                            height: p20,
                          ),
                        ],
                      ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                Obx(
                  () => TextButton(
                    onPressed: () {
                      final form = controller.formKey.currentState!;
                      if (form.validate()) {
                        controller.submit();
                        form.reset();
                      }
                    },
                    child:
                        controller.isLoading ? loadingMini() : const Text('OK'),
                  ),
                )
              ],
            );
          });
        });
  }

  Widget buildTitle() {
    return TextFormField(
      maxLength: 50,
      controller: controller.titleController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Objet...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }

  Widget dateRappelWidget() {
    DateTime? dateTime;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                type: OmniDateTimePickerType.date,
                firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
              );
              controller.dateTime = dateTime;
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text("Selctionner la date")));
  }

  Widget buildDescription() {
    return TextFormField(
      maxLines: 5,
      keyboardAppearance: Brightness.dark,
      controller: controller.descriptionController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        labelText: 'Ecrivez quelque chose...',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Ce champs est obligatoire';
        } else {
          return null;
        }
      },
    );
  }
}
