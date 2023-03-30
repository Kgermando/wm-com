import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';

final GlobalKey<ScaffoldState> scaffoldNetworkKey = GlobalKey();

Widget noNetworkWidget(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.network_check, size: p50),
          const SizedBox(
            height: p20,
          ),
          Text("Pas de connexion internet.",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(
            height: p20,
          ),
          TextButton(
              onPressed: () {
                // Phoenix.rebirth(context);
                Get.back();
              },
              child: Text("Reessayer",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white)))
        ],
      ),
    );



// Widget noNetworkWidget(BuildContext context) => Scaffold(
//     key: scaffoldNetworkKey,
//     appBar: headerBar(context, scaffoldNetworkKey, '', ''),
//     drawer: const DrawerMenu(),
//     body: Row(
//       children: [
//         Visibility(
//             visible: !Responsive.isMobile(context),
//             child: const Expanded(flex: 1, child: DrawerMenu())),
//         Expanded(
//             flex: 5,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.network_check, size: p50),
//                   const SizedBox(
//                     height: p20,
//                   ),
//                   Text("Pas de connexion internet.", style: Theme.of(context).textTheme.headlineSmall),
//                   const SizedBox(
//                     height: p20,
//                   ),
//                   TextButton(onPressed: () {}, child: const Text("Reessayer"))
//                 ],
//               ),
//             )),
//       ],
//     ));
