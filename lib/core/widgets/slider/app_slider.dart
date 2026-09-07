import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChangeEnd;

  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  static Color _dim(Color color) => color.withValues(alpha: 0.30);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disabled = onChanged == null;

    final active = activeColor ?? colors.backgroundPrimaryDefault;
    final inactive = inactiveColor ?? colors.backgroundDefaultSecondary;
    final thumb = thumbColor ?? colors.backgroundPrimaryDefault;

    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      activeColor: disabled ? _dim(active) : active,
      inactiveColor: disabled ? _dim(inactive) : inactive,
      thumbColor: disabled ? _dim(thumb) : thumb,
    );
  }
}
