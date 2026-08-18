import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color applyOpacity(double opacity) {
    if (opacity < 0 || opacity > 1) {
      throw ArgumentError('Opacity must be between 0 and 1');
    }
    return withValues(alpha: opacity);
  }
}
