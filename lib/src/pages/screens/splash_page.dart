import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/responsive.dart';
import 'package:wm_com/src/pages/screens/controller/splash_controller.dart';
import 'package:wm_com/src/utils/info_system.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;

    return Scaffold(
        body: Card(
      child: Center(
        child: Column(
          children: [
            Expanded(
                child: Image.asset(InfoSystem().logoSansFond(),
                    height: Responsive.isDesktop(context)
                        ? sized.height / 4
                        : sized.height / 3,
                    width: Responsive.isDesktop(context)
                        ? sized.width / 4
                        : sized.height / 3)),
            const SizedBox(width: 50, child: LinearProgressIndicator()),
            const SizedBox(height: 50)
          ],
        ),
      ),
    ));
  }
}
