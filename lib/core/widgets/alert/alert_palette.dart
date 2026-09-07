import 'dart:ui';

import '../../theme/colors/colors_abstract.dart';
import 'alert.dart';

typedef AlertPaletteType = ({
  Color background,
  Color border,
  Color foreground,
  Color iconColor,
  Color iconBackground,
});

class AlertPalette {
  static AlertPaletteType palette(AlertType type, ColorsAbstract colors) => switch (type) {
    .error => (
      background: colors.backgroundErrorTertiary,
      border: colors.borderErrorDefault,
      foreground: colors.textErrorDefault,
      iconColor: colors.iconErrorDefault,
      iconBackground: colors.backgroundErrorSecondary,
    ),
    .warning => (
      background: colors.backgroundWarningTransparent,
      border: colors.borderWarningDefault,
      foreground: colors.textWarningDefault,
      iconColor: colors.iconWarningDefault,
      iconBackground: colors.backgroundWarningSecondary,
    ),
    .info => (
      background: colors.backgroundInfoTertiary,
      border: colors.borderInfoDefault,
      foreground: colors.textInfoDefault,
      iconColor: colors.iconInfoDefault,
      iconBackground: colors.backgroundInfoSecondary,
    ),
    .primary => (
      background: colors.backgroundPrimaryTertiary,
      border: colors.borderPrimaryDefault,
      foreground: colors.textPrimaryDefault,
      iconColor: colors.iconPrimaryDefault,
      iconBackground: colors.backgroundPrimarySecondary,
    ),
  };
}
