import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core/navigation/app_route_observer.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/controllers/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/login',
    observers: [appRouteObserver],
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SettingsPage()),
      ),
    ],
  );

  // Refresh le router quand l'état auth change
  ref.listen(authControllerProvider, (_, __) => router.refresh());

  return router;
}

String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authControllerProvider);
  final isAuthenticated = auth.value?.status == AuthStatus.authenticated;

  if (state.matchedLocation == '/login' && isAuthenticated) {
    return '/home';
  }
  if (state.matchedLocation != '/login' && !isAuthenticated) {
    return '/login';
  }
  return null;
}