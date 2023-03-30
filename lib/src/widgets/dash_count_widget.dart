import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';

class DashCountWidget extends StatelessWidget {
  const DashCountWidget(
      {Key? key,
      required this.title,
      required this.count1,
      required this.count2,
      required this.icon,
      required this.color,
      required this.gestureTapCallback})
      : super(key: key);

  final String title;
  final String count1;
  final String count2;
  final IconData icon;
  final Color color;
  final GestureTapCallback gestureTapCallback;

  @override
  Widget build(BuildContext context) {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return InkWell(
      onTap: gestureTapCallback,
      child: Card(
        elevation: 10.0,
        shadowColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: Responsive.isMobile(context) ? double.infinity : 250,
          height: 100,
          color: color,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Icon(icon, size: 40.0, color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(width: p10),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: AutoSizeText(title,
                              maxLines: 2,
                              style: bodySmall!.copyWith(color: Colors.white))),
                      Expanded(
                        flex: 2,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: count1,
                                  style: headlineMedium!
                                      .copyWith(color: Colors.teal)),
                              TextSpan(
                                  text: ' / ',
                                  style: headlineMedium.copyWith(
                                      color: Colors.white)),
                              TextSpan(
                                  text: count2,
                                  style: headlineMedium.copyWith(
                                      color: Colors.white)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: headlineMedium,
                        ),
                      ),
                    ],
                  )

                  // AutoSizeText(title,
                  //     maxLines: 1,
                  //     style: bodySmall!.copyWith(color: Colors.white)),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
