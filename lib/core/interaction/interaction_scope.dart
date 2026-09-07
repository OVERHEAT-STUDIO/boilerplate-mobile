import 'package:flutter/material.dart';

import '../config/app_config.dart';
import 'ignore_interaction_scope.dart';

typedef InteractionRecordCallback = void Function(int delta, {String? source});

class InteractionScope extends InheritedWidget {
  const InteractionScope({super.key, required this.record, required super.child});

  final InteractionRecordCallback record;

  static void register(BuildContext context, {String? source, int? delta}) {
    if (IgnoreInteractionScope.ignores(context)) return;
    final scope = context.findAncestorWidgetOfExactType<InteractionScope>();
    if (scope == null) return;
    scope.record(delta ?? AppConfig.interactionWeightDefault, source: source);
  }

  @override
  bool updateShouldNotify(covariant InteractionScope oldWidget) => record != oldWidget.record;
}
