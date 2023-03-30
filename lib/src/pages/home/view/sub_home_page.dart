import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/navigation/header/header_bar.dart';
import 'package:wm_com/src/pages/home/components/home_list.dart';
import 'package:wm_com/src/routes/routes.dart';
import 'package:wm_com/src/widgets/barre_connection_widget.dart';
import 'package:wm_com/src/widgets/loading.dart';
import 'package:wm_com/src/widgets/title_widget.dart';

class SubHomePage extends StatelessWidget {
  const SubHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Menu Restaurants";
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, ''),
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const BarreConnectionWidget(),
              Padding(
                padding: const EdgeInsets.all(p10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleWidget(title: '🍴 Menu Restaurant'.toUpperCase()),
                        // botomSheetWidget()
                      ],
                    ),
                    const SizedBox(height: p20),
                    Wrap(
                      runSpacing: p20,
                      spacing: p20,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        ServiceHome(
                            title: 'Restaurant',
                            icon: Icons.restaurant,
                            color: Colors.pink,
                            onPress: () {
                              Get.toNamed(RestaurantRoutes.dashboardRestaurant);
                            }),
                        ServiceHome(
                            title: 'Terrasse',
                            icon: Icons.nightlife,
                            color: Colors.grey,
                            onPress: () {
                              Get.toNamed(TerrasseRoutes.dashboardTerrasse);
                            }),
                        ServiceHome(
                            title: 'VIP',
                            icon: Icons.food_bank,
                            color: Colors.red,
                            onPress: () {
                              Get.toNamed(VipRoutes.dashboardVip);
                            }),
                        ServiceHome(
                            title: 'Livraison',
                            icon: Icons.delivery_dining,
                            color: Colors.lightGreen,
                            onPress: () {
                              Get.toNamed(LivraisonRoutes.dashboardLivraison);
                            }),
                        // ServiceHome(
                        //     title: 'Glace',
                        //     icon: Icons.icecream,
                        //     color: Colors.cyan,
                        //     onPress: () {}),
                        // ServiceHome(
                        //     title: 'Buffet',
                        //     icon: Icons.emoji_food_beverage,
                        //     color: Colors.purple,
                        //     onPress: () {}),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
