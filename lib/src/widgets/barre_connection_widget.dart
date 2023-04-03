import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/controllers/network_controller.dart';


class BarreConnectionWidget extends GetView<NetworkController> {
  const BarreConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final labelSmall = Theme.of(context).textTheme.labelSmall;
    return (!GetPlatform.isWeb)
        ? Obx(() => Container(
              width: double.infinity,
              color: (controller.connectionStatus == 1)
                  ? Colors.green
                  : Colors.black,
              child: (controller.connectionStatus == 1)
                  ? Text(
                      "Vous êtes connecté",
                      textAlign: TextAlign.center,
                      style: labelSmall!.copyWith(color: Colors.white),
                    )
                  : Text(
                      "Vous êtes hors ligne",
                      textAlign: TextAlign.center,
                      style: labelSmall!.copyWith(color: Colors.white),
                    ),
            ))
        : Container();
  }
}
