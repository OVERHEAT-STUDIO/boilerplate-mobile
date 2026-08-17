import 'package:flutter/material.dart';
import 'app_text_styles.dart';
import 'border/border_radius.dart';
import 'colors/colors_abstract.dart';
import 'colors/colors_light.dart';

class AppTheme {
  static ThemeData get(ColorsAbstract colors) {
    final fontFamily = 'Nunito';
    final brightness =
        colors == ColorsLight.instance ? Brightness.light : Brightness.dark;

    final textStyles = AppTextStyles.create(brightness);

    return ThemeData(
      fontFamily: fontFamily,
      textTheme: TextTheme(
        bodyLarge: textStyles.xl,
        bodyMedium: textStyles.base,
        bodySmall: textStyles.xs,
      ),
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.backgroundDefaultDefault,
      primaryColor: colors.backgroundPrimaryDefault,
      cardColor: colors.backgroundDefaultSecondary,
      canvasColor: colors.backgroundDefaultDefault,
      shadowColor: colors.backgroundDefaultSecondary,
      dividerColor: colors.borderDefaultDefault,
      dividerTheme: DividerThemeData(
        color: colors.borderDefaultDefault,
        thickness: 2,
      ),
      disabledColor: colors.iconWarningTertiary,
      colorScheme: ColorScheme(
        brightness: colors.backgroundDefaultDefault.computeLuminance() > 0.5
            ? Brightness.light
            : Brightness.dark,
        primary: colors.backgroundPrimaryDefault,
        onPrimary: colors.textDefaultDefault,
        secondary: colors.textDefaultSecondary,
        onSecondary: colors.textDefaultSecondary,
        error: colors.borderErrorDefault,
        onError: colors.borderErrorDefault,
        surface: colors.backgroundDefaultDefault,
        onSurface: colors.textDefaultDefault,
        surfaceContainerHighest: colors.backgroundDefaultSecondary,
        outline: colors.borderDefaultDefault,
        outlineVariant: colors.borderDefaultSecondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundPrimaryDefault,
        foregroundColor: colors.textDefaultDefault,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.iconDefaultDefault),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      dialogTheme: DialogThemeData(
        backgroundColor: colors.backgroundDefaultDefault,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.backgroundDefaultDefault,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(.zero),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundPrimaryDefault,
          foregroundColor: colors.textDefaultDefault,
          disabledBackgroundColor: colors.iconWarningTertiary,
          disabledForegroundColor: colors.iconWarningTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textDefaultDefault,
          disabledForegroundColor: colors.iconWarningTertiary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textDefaultDefault,
          side: BorderSide(color: colors.borderDefaultDefault),
          disabledForegroundColor: colors.iconWarningTertiary,
        ),
      ),
      iconTheme: IconThemeData(color: colors.iconDefaultDefault),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.iconDefaultDefault,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.backgroundDefaultSecondary,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderDefaultDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderDefaultDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderDefaultDefault, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderErrorDefault),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.borderDefaultDefault),
        ),
      ),
      extensions: [textStyles],
      tooltipTheme: TooltipThemeData(
        triggerMode: TooltipTriggerMode.tap,
        textStyle: textStyles.base,
        decoration: BoxDecoration(
          color: colors.backgroundDefaultDefault,
          borderRadius: BorderRadius.all(BRadius.r6),
        ),
      ),
    );
  }
}