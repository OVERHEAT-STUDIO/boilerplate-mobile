import 'package:flutter/material.dart';

import '../../../main.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileView;
  final Widget tabletView;

  const ResponsiveLayout({super.key, required this.mobileView, required this.tabletView});

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return tabletView;
    }
    return mobileView;
  }
}
