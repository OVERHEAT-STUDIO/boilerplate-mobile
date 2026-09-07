import 'package:flutter/material.dart';

class IgnoreInteractionScope extends InheritedWidget {
  const IgnoreInteractionScope({super.key, required super.child});

  static bool ignores(BuildContext context) {
    return context.findAncestorWidgetOfExactType<IgnoreInteractionScope>() != null;
  }

  @override
  bool updateShouldNotify(covariant IgnoreInteractionScope oldWidget) => false;
}
