import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

enum ScreenType { mobile, tablet }

class Responsive {
  const Responsive(this.context);
  final BuildContext context;

  static const double _mobileWidth = 430;
  static const double _mobileHeight = 932;
  static const double _tabletWidth = 1366;
  static const double _tabletHeight = 1024;

  // État statique mis à jour par ResponsiveInit
  static double _currentWidth = _mobileWidth;
  static double _currentHeight = _mobileHeight;
  static double _currentRefWidth = _mobileWidth;
  static double _currentRefHeight = _mobileHeight;

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;

  ScreenType get screenType =>
      width < Breakpoints.tablet ? ScreenType.mobile : ScreenType.tablet;

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;

  static double get tabletMaxWidth => 520.w;

  double get _referenceWidth => isMobile ? _mobileWidth : _tabletWidth;
  double get _referenceHeight => isMobile ? _mobileHeight : _tabletHeight;

  double w(num value) => value * width / _referenceWidth;
  double h(num value) => value * height / _referenceHeight;

  static void _update(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _currentWidth = size.width;
    _currentHeight = size.height;
    final isMobile = size.width < Breakpoints.tablet;
    _currentRefWidth = isMobile ? _mobileWidth : _tabletWidth;
    _currentRefHeight = isMobile ? _mobileHeight : _tabletHeight;
  }

  static double scaleWidth(num value) =>
      value * _currentWidth / _currentRefWidth;
  static double scaleHeight(num value) =>
      value * _currentHeight / _currentRefHeight;
}

/// À placer dans l'arbre au-dessus de tous les widgets qui utilisent `.w` / `.h`
class ResponsiveInit extends StatelessWidget {
  final Widget child;
  const ResponsiveInit({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Responsive._update(context);
    return child;
  }
}

extension ResponsiveNum on num {
  double get w => Responsive.scaleWidth(this);
  double get h => Responsive.scaleHeight(this);
}

// Extension sur BuildContext pour initialiser le responsive
extension ResponsiveContext on BuildContext {
  void initResponsive() => Responsive._update(this);
}

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
  });

  final Widget Function(BuildContext context, Responsive responsive) mobile;
  final Widget Function(BuildContext context, Responsive responsive)? tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = Responsive(context);
        return r.isTablet && tablet != null
            ? tablet!(context, r)
            : mobile(context, r);
      },
    );
  }
}