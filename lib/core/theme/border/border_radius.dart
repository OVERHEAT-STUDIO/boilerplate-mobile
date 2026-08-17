import 'package:flutter/material.dart';

class BRadius {
  static const Radius none = Radius.circular(0.0);
  static const Radius r2 = Radius.circular(2.0);
  static const Radius r4 = Radius.circular(4.0);
  static const Radius r6 = Radius.circular(6.0);
  static const Radius r8 = Radius.circular(8.0);
  static const Radius r12 = Radius.circular(12.0);
  static const Radius r16 = Radius.circular(16.0);
  static const Radius r24 = Radius.circular(24.0);
  static const Radius r32 = Radius.circular(32.0);
  static const Radius r64 = Radius.circular(64.0);
  static const Radius full = Radius.circular(9999.0);
}

extension BRadiusX on Radius {
  double get x => x;
}

extension BRadiusContext on BuildContext {
  BorderRadius get brNone => BorderRadius.all(BRadius.none);
  BorderRadius get br2 => BorderRadius.all(BRadius.r2);
  BorderRadius get br4 => BorderRadius.all(BRadius.r4);
  BorderRadius get br6 => BorderRadius.all(BRadius.r6);
  BorderRadius get br8 => BorderRadius.all(BRadius.r8);
  BorderRadius get br12 => BorderRadius.all(BRadius.r12);
  BorderRadius get br16 => BorderRadius.all(BRadius.r16);
  BorderRadius get br24 => BorderRadius.all(BRadius.r24);
  BorderRadius get br32 => BorderRadius.all(BRadius.r32);
  BorderRadius get br64 => BorderRadius.all(BRadius.r64);
  BorderRadius get brFull => BorderRadius.all(BRadius.full);
}