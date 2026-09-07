import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';

import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';
import 'separator.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(child: Separator()),
        Text(
          I18n.current.orLabel,
          style: context.textStyles.sm_b.withColor(context.colors.textDefaultTertiary),
        ),
        Expanded(child: Separator()),
      ],
    );
  }
}
