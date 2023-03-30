import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/navigation/drawer/components/drawer_menu_marketing.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/marketing/controller/agenda/agenda_controller.dart';
import 'package:wm_com/src/widgets/btn_widget.dart';
import 'package:wm_com/src/models/marketing/agenda_model.dart';

class UpdateAgenda extends StatefulWidget {
  const UpdateAgenda({super.key, required this.agendaColor});
  final AgendaColor agendaColor;

  @override
  State<UpdateAgenda> createState() => _UpdateAgendaState();
}

class _UpdateAgendaState extends State<UpdateAgenda> {
  final AgendaController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Marketing";

  @override
  void initState() {
    setState(() {
      controller.titleController =
          TextEditingController(text: widget.agendaColor.agendaModel.title);
      controller.descriptionController = TextEditingController(
          text: widget.agendaColor.agendaModel.description);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.agendaColor.agendaModel.title),
      drawer: const DrawerMenuMarketing(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenuMarketing())),
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
                                dateRappelWidget(),
                                const SizedBox(height: p8),
                                buildTitle(),
                                const SizedBox(height: p8),
                                buildDescription(),
                                const SizedBox(
                                  height: p20,
                                ),
                                Obx(() => BtnWidget(
                                    title: 'Soumettre',
                                    isLoading: controller.isLoading,
                                    press: () {
                                      final form =
                                          controller.formKey.currentState!;
                                      if (form.validate()) {
                                        controller.updateData(
                                            widget.agendaColor.agendaModel);
                                        form.reset();
                                      }
                                    }))
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

  Widget dateRappelWidget() {
    DateTime? dateTime;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextButton.icon(
            onPressed: () async {
              dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: controller.dateTime,
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
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );
              controller.dateTime = dateTime;
            },
            icon: const Icon(Icons.calendar_month),
            label: Text("Selctionner la date $dateTime")));
  }

  Widget buildTitle() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TextFormField(
      maxLines: 1,
      style: bodyMedium,
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

  Widget buildDescription() {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return TextFormField(
      maxLines: 10,
      style: bodySmall,
      controller: controller.descriptionController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Ecrivez quelque chose...',
        // hintStyle: TextStyle(color: Colors.black54),
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
