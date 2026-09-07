import 'package:flutter/material.dart';

import '../../theme/colors/colors_abstract.dart';
import 'button.dart';

typedef ButtonPaletteType = ({Color background, Color border, Color foreground, Color iconColor});

class ButtonPalette {
  static ButtonPaletteType palette(ButtonType type, ColorsAbstract colors) => switch (type) {
    .base => (
      background: colors.backgroundDefaultSecondary,
      border: colors.borderDefaultDefault,
      foreground: colors.textDefaultDefault,
      iconColor: colors.iconDefaultDefault,
    ),
    .primary => (
      background: colors.backgroundPrimaryDefault,
      border: colors.borderPrimaryDefault,
      foreground: colors.textDefaultDefault,
      iconColor: colors.iconDefaultDefault,
    ),
    .secondary => (
      background: colors.backgroundPrimaryTertiary,
      border: colors.borderPrimaryDefault,
      foreground: colors.textPrimaryDefault,
      iconColor: colors.iconPrimaryDefault,
    ),
    .error => (
      background: colors.backgroundErrorDefault,
      border: colors.borderErrorDefault,
      foreground: colors.textErrorDefault,
      iconColor: colors.iconErrorDefault,
    ),
    .warning => (
      background: colors.backgroundWarningDefault,
      border: colors.borderWarningDefault,
      foreground: colors.textWarningDefault,
      iconColor: colors.iconWarningDefault,
    ),
    .info => (
      background: colors.backgroundInfoDefault,
      border: colors.borderInfoDefault,
      foreground: colors.textInfoDefault,
      iconColor: colors.iconInfoDefault,
    ),
    .ghost => (
      background: Colors.transparent,
      border: Colors.transparent,
      foreground: colors.textDefaultDefault,
      iconColor: colors.iconDefaultDefault,
    ),
  };
}
