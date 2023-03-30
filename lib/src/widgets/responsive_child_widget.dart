import 'package:flutter/material.dart';
import 'package:wm_com/src/constants/app_theme.dart';
import 'package:wm_com/src/constants/responsive.dart';

class ResponsiveChildWidget extends StatelessWidget {
  const ResponsiveChildWidget(
      {super.key,
      required this.child1,
      required this.child2,
      this.flex1,
      this.flex2,
      this.mainAxisAlignment});

  final Widget child1;
  final Widget child2;
  final int? flex1;
  final int? flex2;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return Row(
        mainAxisAlignment: (mainAxisAlignment == null)
            ? MainAxisAlignment.start
            : mainAxisAlignment!,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: (flex1 == null) ? 1 : flex1!, child: child1),
          const SizedBox(width: p20),
          Expanded(flex: (flex2 == null) ? 1 : flex2!, child: child2),
        ],
      );
    } else if (Responsive.isTablet(context)) {
      return Row(
        mainAxisAlignment: (mainAxisAlignment == null)
            ? MainAxisAlignment.start
            : mainAxisAlignment!,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: (flex1 == null) ? 1 : flex1!, child: child1),
          const SizedBox(width: p20),
          Expanded(flex: (flex2 == null) ? 1 : flex2!, child: child2),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child1, child2],
      );
    }
  }
}
