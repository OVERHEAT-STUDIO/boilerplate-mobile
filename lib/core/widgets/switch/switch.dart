import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeThumbColor,
    this.activeTrackColor,
    this.activeTrackOutlineColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.inactiveTrackOutlineColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  final Color? activeThumbColor;
  final Color? activeTrackColor;
  final Color? activeTrackOutlineColor;

  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final Color? inactiveTrackOutlineColor;

  static Color _dim(Color color) => color.withValues(alpha: 0.30);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disabled = onChanged == null;

    final onThumb = activeThumbColor ?? colors.backgroundPrimaryDefault;
    final onTrack = activeTrackColor ?? colors.backgroundPrimaryTertiary;
    final onOutline = activeTrackColor ?? colors.backgroundPrimaryDefault;
    final offThumb = inactiveThumbColor ?? colors.borderDefaultDefault;
    final offTrack = inactiveTrackColor ?? colors.backgroundDefaultSecondary;
    final offOutline =
        inactiveTrackOutlineColor ?? colors.borderDefaultDefault;

    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final base = selected ? onThumb : offThumb;
        if (states.contains(WidgetState.disabled) || disabled) {
          return _dim(base);
        }
        return base;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final base = selected ? onTrack : offTrack;
        if (states.contains(WidgetState.disabled) || disabled) {
          return _dim(base);
        }
        return base;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final base = selected ? onOutline : offOutline;
        if (states.contains(WidgetState.disabled) || disabled) {
          return _dim(base);
        }
        return base;
      }),
    );
  }
}
