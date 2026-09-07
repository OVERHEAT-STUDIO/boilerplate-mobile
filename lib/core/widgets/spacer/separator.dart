import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

class Separator extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double? height;
  const Separator({super.key, this.margin, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 2.h,
      color: context.colors.borderDefaultDefault,
      margin: margin,
    );
  }
}
