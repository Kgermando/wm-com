import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubHeader extends StatelessWidget {
  const SubHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios))
        ],
      ),
    );
  }
}
