import 'package:flutter/material.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.xxs,
    required this.xxs_b,
    required this.xs,
    required this.xs_b,
    required this.sm,
    required this.sm_b,
    required this.base,
    required this.base_b,
    required this.lg,
    required this.lg_b,
    required this.xl,
    required this.xl_b,
    required this.xxl,
    required this.xxl_b,
  });

  final TextStyle xxs;
  final TextStyle xxs_b;
  final TextStyle xs;
  final TextStyle xs_b;
  final TextStyle sm;
  final TextStyle sm_b;
  final TextStyle base;
  final TextStyle base_b;
  final TextStyle lg;
  final TextStyle lg_b;
  final TextStyle xl;
  final TextStyle xl_b;
  final TextStyle xxl;
  final TextStyle xxl_b;

  static AppTextStyles create(Brightness brightness) {
    final baseColor = brightness == Brightness.light
        ? const Color(0xFF1A1A2E)
        : const Color(0xFFF5F5F5);

    TextStyle s(double size, FontWeight weight) => TextStyle(
          fontFamily: 'Nunito',
          fontSize: size,
          fontWeight: weight,
          color: baseColor,
        );

    return AppTextStyles(
      xxs: s(10, FontWeight.w400),
      xxs_b: s(10, FontWeight.w700),
      xs: s(12, FontWeight.w400),
      xs_b: s(12, FontWeight.w700),
      sm: s(14, FontWeight.w400),
      sm_b: s(14, FontWeight.w700),
      base: s(16, FontWeight.w400),
      base_b: s(16, FontWeight.w700),
      lg: s(18, FontWeight.w400),
      lg_b: s(18, FontWeight.w700),
      xl: s(20, FontWeight.w400),
      xl_b: s(20, FontWeight.w700),
      xxl: s(24, FontWeight.w400),
      xxl_b: s(24, FontWeight.w700),
    );
  }

  @override
  AppTextStyles copyWith({
    TextStyle? xxs,
    TextStyle? xxs_b,
    TextStyle? xs,
    TextStyle? xs_b,
    TextStyle? sm,
    TextStyle? sm_b,
    TextStyle? base,
    TextStyle? base_b,
    TextStyle? lg,
    TextStyle? lg_b,
    TextStyle? xl,
    TextStyle? xl_b,
    TextStyle? xxl,
    TextStyle? xxl_b,
  }) {
    return AppTextStyles(
      xxs: xxs ?? this.xxs,
      xxs_b: xxs_b ?? this.xxs_b,
      xs: xs ?? this.xs,
      xs_b: xs_b ?? this.xs_b,
      sm: sm ?? this.sm,
      sm_b: sm_b ?? this.sm_b,
      base: base ?? this.base,
      base_b: base_b ?? this.base_b,
      lg: lg ?? this.lg,
      lg_b: lg_b ?? this.lg_b,
      xl: xl ?? this.xl,
      xl_b: xl_b ?? this.xl_b,
      xxl: xxl ?? this.xxl,
      xxl_b: xxl_b ?? this.xxl_b,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      xxs: TextStyle.lerp(xxs, other.xxs, t)!,
      xxs_b: TextStyle.lerp(xxs_b, other.xxs_b, t)!,
      xs: TextStyle.lerp(xs, other.xs, t)!,
      xs_b: TextStyle.lerp(xs_b, other.xs_b, t)!,
      sm: TextStyle.lerp(sm, other.sm, t)!,
      sm_b: TextStyle.lerp(sm_b, other.sm_b, t)!,
      base: TextStyle.lerp(base, other.base, t)!,
      base_b: TextStyle.lerp(base_b, other.base_b, t)!,
      lg: TextStyle.lerp(lg, other.lg, t)!,
      lg_b: TextStyle.lerp(lg_b, other.lg_b, t)!,
      xl: TextStyle.lerp(xl, other.xl, t)!,
      xl_b: TextStyle.lerp(xl_b, other.xl_b, t)!,
      xxl: TextStyle.lerp(xxl, other.xxl, t)!,
      xxl_b: TextStyle.lerp(xxl_b, other.xxl_b, t)!,
    );
  }
}

extension TextStyleColorExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}