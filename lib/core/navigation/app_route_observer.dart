import 'package:flutter/material.dart';

/// Observateur GoRouter pour tracer les changements de route
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('[Route] Push: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('[Route] Pop: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }
}

final AppRouteObserver appRouteObserver = AppRouteObserver();