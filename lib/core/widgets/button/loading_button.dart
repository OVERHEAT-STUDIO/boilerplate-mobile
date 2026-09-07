import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';
import 'button.dart';
import 'button_palette.dart';

class LoadingButton extends StatelessWidget {
  final ButtonType type;
  final String text;

  const LoadingButton({super.key, required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;
    final palette = ButtonPalette.palette(type, colors);

    return Container(
      width: double.infinity,
      padding: .all(16.w),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: .all(BRadius.r16),
        border: Border.all(color: palette.border),
      ),
      child: IconTheme(
        data: IconThemeData(color: palette.iconColor),
        child: Row(
          mainAxisAlignment: .center,
          mainAxisSize: .max,
          children: [
            Icon(LucideIcons.loader, size: 18.w, color: palette.iconColor)
                .animate(onComplete: (controller) => controller.repeat())
                .rotate(duration: 1.8.seconds),
            SizedBox(width: 12.w),
            Text(text, style: textStyles.lg_b.copyWith(color: palette.foreground)),
          ],
        ),
      ),
    );
  }
}
