import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../interaction/interaction_scope.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/haptic_manager.dart';
import '../../utils/responsive.dart';
import 'button_palette.dart';

enum IconPosition { left, right }

enum ButtonType { base, primary, secondary, error, warning, info, ghost }

class Button extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;
  final IconData? icon;
  final IconPosition iconPosition;
  final double iconSpacing;
  final ButtonType type;
  final bool isDisabled;
  final double padding;
  final Radius borderRadius;
  final double iconSize;
  final TextStyle? textStyle;
  final bool expandWidth;
  final double? contentHeight;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSpacing = 12,
    this.type = ButtonType.base,
    this.isDisabled = false,
    this.padding = 16,
    this.borderRadius = BRadius.r16,
    this.iconSize = 18,
    this.textStyle,
    this.expandWidth = true,
    this.contentHeight,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;
    final palette = ButtonPalette.palette(type, colors);

    return GestureDetector(
      onTap: isDisabled
          ? () {
              HapticManager.instance.deny();
            }
          : () {
              HapticManager.instance.selectionClick();
              InteractionScope.register(context, source: 'default_tap');
              onTap();
            },
      child: AnimatedOpacity(
        duration: 300.ms,
        opacity: isDisabled ? 0.5 : 1,
        child: Container(
          width: expandWidth ? double.infinity : null,
          padding: .all(padding.w),
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: .all(borderRadius),
            border: .all(color: palette.border),
          ),
          child: _buildContent(textStyles, palette),
        ),
      ),
    );
  }

  Widget _buildContent(AppTextStyles textStyles, ButtonPaletteType palette) {
    final rowMainAxisSize = expandWidth ? MainAxisSize.max : MainAxisSize.min;
    var style = (textStyle ?? textStyles.lg_b.copyWith(color: palette.foreground, height: 1));

    final gap = SizedBox(width: iconSpacing.w);

    if (icon == null && text != null) {
      return SizedBox(
        height: (contentHeight ?? 24).w,
        child: Center(
          child: Text(text!, style: style, textAlign: .center),
        ),
      );
    }

    final textWidget = Text(text ?? '', style: style);
    final iconWidget = Icon(icon, size: iconSize.w, color: palette.iconColor);

    return IconTheme(
      data: IconThemeData(color: palette.iconColor),
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: rowMainAxisSize,
        children: text == null
            ? [iconWidget]
            : iconPosition == .left
            ? [iconWidget, gap, textWidget]
            : [textWidget, gap, iconWidget],
      ),
    );
  }
}
