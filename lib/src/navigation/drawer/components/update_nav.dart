import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/network_controller.dart';
import 'package:wm_com/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_com/src/pages/update/controller/update_controller.dart';

class UpdateNav extends StatefulWidget {
  const UpdateNav({super.key, required this.currentRoute});
  final String currentRoute;

  @override
  State<UpdateNav> createState() => _UpdateNavState();
}

class _UpdateNavState extends State<UpdateNav> {
  final UpdateController controller = Get.find();
  final NetworkController networkController = Get.put(NetworkController());
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final currentRoute = Get.currentRoute;
    var route = currentRoute.split('/');
    return Obx(() => (!GetPlatform.isWeb &&
            networkController.connectionStatus == 1)
        ? ExpansionTile(
            leading: const Icon(Icons.update, size: 20.0),
            title: Text('Update', style: bodyMedium),
            initiallyExpanded: (route.elementAt(1) == 'update') ? true : false,
            onExpansionChanged: (val) {
              isOpen = !val;
            },
            children: controller.updateVersionList.map((element) {
              return DrawerWidget(
                  selected: widget.currentRoute == '/update/${element.id}',
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: element.version.toUpperCase(),
                  style: bodySmall!,
                  onTap: () {
                    Get.toNamed('/update/${element.id!}', arguments: element);
                  });
            }).toList(),
          )
        : (GetPlatform.isWeb)
            ? ExpansionTile(
                leading: const Icon(Icons.update, size: 20.0),
                title: Text('Update', style: bodyMedium),
                initiallyExpanded:
                    (route.elementAt(1) == 'update') ? true : false,
                onExpansionChanged: (val) {
                  isOpen = !val;
                },
                children: controller.updateVersionList.map((element) {
                  return DrawerWidget(
                      selected: widget.currentRoute == '/update/${element.id}',
                      icon: Icons.arrow_right,
                      sizeIcon: 15.0,
                      title: element.version.toUpperCase(),
                      style: bodySmall!,
                      onTap: () {
                        Get.toNamed('/update/${element.id!}',
                            arguments: element);
                      });
                }).toList(),
              )
            : Container());
  }
}
