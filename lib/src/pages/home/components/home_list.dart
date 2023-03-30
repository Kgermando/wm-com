import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/models/home/service_home_model.dart';

class HomeList extends StatelessWidget {
  const HomeList(
      {super.key, required this.serviceHomeModel, required this.color});
  final ServiceHomeModel serviceHomeModel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.table_bar;
    if (serviceHomeModel.iconPlace == 'Bar') {
      iconData = Icons.table_bar;
    } else if (serviceHomeModel.iconPlace == 'VIP') {
      iconData = Icons.food_bank;
    } else if (serviceHomeModel.iconPlace == 'Terrasse') {
      iconData = Icons.nightlife;
    } else if (serviceHomeModel.iconPlace == 'Buffet') {
      iconData = Icons.emoji_food_beverage;
    } else if (serviceHomeModel.iconPlace == 'Fast food') {
      iconData = Icons.fastfood;
    } else if (serviceHomeModel.iconPlace == 'Livraison') {
      iconData = Icons.delivery_dining;
    } else if (serviceHomeModel.iconPlace == 'Restaurant') {
      iconData = Icons.restaurant;
    } else if (serviceHomeModel.iconPlace == 'Gâteau') {
      iconData = Icons.cake;
    } else if (serviceHomeModel.iconPlace == 'Creme') {
      iconData = Icons.icecream;
    }

    return GestureDetector(
      onDoubleTap: () {},
      child: Container(
        height: 150,
        width: 150,
        color: color,
        padding: const EdgeInsets.all(p10),
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: p20),
              Icon(iconData, color: color, size: p40),
              Text(serviceHomeModel.name,
                  style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceHome extends StatefulWidget {
  const ServiceHome(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.onPress});
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPress;

  @override
  State<ServiceHome> createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        height: 150,
        width: 150,
        color: widget.color,
        padding: const EdgeInsets.all(p10),
        child: InkWell(
          onDoubleTap: widget.onPress,
          splashColor: widget.color,
          child: Material(
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: p20),
                Icon(widget.icon, color: widget.color, size: p40),
                Text(widget.title, style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
