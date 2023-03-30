import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';

class ResponsiveChild3Widget extends StatelessWidget {
  const ResponsiveChild3Widget(
      {super.key,
      required this.child1,
      required this.child2,
      required this.child3,
      this.flex1,
      this.flex2,
      this.flex3,
      this.mainAxisAlignment});

  final Widget child1;
  final Widget child2;
  final Widget child3;
  final int? flex1;
  final int? flex2;
  final int? flex3;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return Row(
        mainAxisAlignment: (mainAxisAlignment == null)
            ? MainAxisAlignment.start
            : mainAxisAlignment!,
        children: [
          Expanded(flex: (flex1 == null) ? 1 : flex1!, child: child1),
          const SizedBox(width: p20),
          Expanded(flex: (flex2 == null) ? 1 : flex2!, child: child2),
          const SizedBox(width: p20),
          Expanded(flex: (flex3 == null) ? 1 : flex3!, child: child3),
          const SizedBox(width: p20),
        ],
      );
    } else if (Responsive.isTablet(context)) {
      return Row(
        mainAxisAlignment: (mainAxisAlignment == null)
            ? MainAxisAlignment.start
            : mainAxisAlignment!,
        children: [
          Expanded(flex: (flex1 == null) ? 1 : flex1!, child: child1),
          const SizedBox(width: p20),
          Expanded(flex: (flex2 == null) ? 1 : flex2!, child: child2),
          const SizedBox(width: p20),
          Expanded(flex: (flex3 == null) ? 1 : flex3!, child: child3),
        ],
      );
    } else {
      return Column(
        children: [child1, child2, child3],
      );
    }
  }
}
