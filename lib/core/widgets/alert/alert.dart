import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';
import 'alert_palette.dart';

enum AlertType { error, warning, info, primary }

class Alert extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final IconData? iconOverride;
  final bool animateIcon;

  /// Action optionnelle affichée sous le contenu (ex: un [Button]).
  final Widget? action;

  const Alert({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.iconOverride,
    this.animateIcon = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AlertPalette.palette(type, context.colors);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: .all(BRadius.r16),
        border: .all(color: palette.border),
      ),
      child: Padding(padding: .all(16.w), child: _buildContent(context, palette)),
    );
  }

  Widget _buildContent(BuildContext context, AlertPaletteType palette) {
    final icon = Icon(iconOverride ?? _mapIcon(), color: palette.iconColor, size: 24.w);

    final iconContainer = Container(
      padding: .all(8.w),
      decoration: BoxDecoration(color: palette.iconBackground, shape: .circle),
      child: animateIcon
          ? icon
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -5, duration: 500.ms, curve: Curves.ease)
          : icon,
    );

    final row = Row(
      spacing: 16.w,
      children: [
        if (animateIcon)
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: palette.iconBackground),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .custom(
                    duration: 1000.ms,
                    builder: (_, value, child) {
                      final t = ((value - 0.5) / 0.5).clamp(0.0, 1.0);
                      final opacity = value < 0.5 ? 0.0 : (1.0 - t);
                      return Transform.scale(
                        scale: 1.0 + t * 0.6,
                        child: Opacity(opacity: opacity, child: child),
                      );
                    },
                  ),
              iconContainer,
            ],
          )
        else
          iconContainer,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: context.textStyles.lg_b.copyWith(color: palette.foreground)),
              Text(
                message,
                style: context.textStyles.xs.copyWith(color: context.colors.textDefaultSecondary),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ],
    );

    if (action == null) return row;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 16.w,
      children: [row, action!],
    );
  }

  IconData _mapIcon() =>
      switch (type) {
            .error => LucideIcons.ban,
            .warning => LucideIcons.triangleAlert,
            .info => LucideIcons.info,
            .primary => LucideIcons.server,
      };
}
