import 'package:flutter/material.dart';

import 'app_text_styles.dart';
import 'colors/colors_abstract.dart';
import 'colors/colors_dark.dart';
import 'colors/colors_light.dart';

export 'app_text_styles.dart' show TextStyleColorExtension;

extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  AppTextStyles get textStyles => theme.extension<AppTextStyles>()!;

  ColorsAbstract get colors {
    final brightness = theme.brightness;
    return brightness == Brightness.dark
        ? ColorsDark.instance
        : ColorsLight.instance;
  }
}