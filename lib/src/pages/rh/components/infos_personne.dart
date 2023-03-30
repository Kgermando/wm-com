import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/models/rh/agent_model.dart';
import 'package:wm_com/src/pages/rh/components/table_users_actif.dart';
import 'package:wm_com/src/pages/rh/controller/user_actif_controller.dart';

class InfosPersonne extends StatelessWidget {
  const InfosPersonne({super.key, required this.personne});
  final AgentModel personne;

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? p20 : 0.0),
      child: usersController.obx((state) =>
          TableUserActif(usersController: usersController, state: state!)),
    );
  }
}
