import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';

class ButtonStandarWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final IconData icon;
  final Color color;

  const ButtonStandarWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(40), backgroundColor: mainColor),
        onPressed: onClicked,
        icon: Icon(icon, color: color),
        label: AutoSizeText(text,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(color: color)));
  }

  //  ElevatedButton(
  // style: ElevatedButton.styleFrom(
  //   minimumSize: const Size.fromHeight(40),
  //   primary: Colors.grey,
  // ),
  //       child: FittedBox(
  //         child: Text(
  //           text,
  //           style: const TextStyle(fontSize: 20, color: Colors.black),
  //         ),
  //       ),
  //       onPressed: onClicked,
  //     );
}
