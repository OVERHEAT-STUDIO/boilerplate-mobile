import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n/i18n.dart';

import 'package:my_app/core/theme/app_theme.dart';
import 'package:my_app/core/theme/colors/colors_light.dart';
import 'package:my_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:my_app/features/auth/presentation/pages/login_page.dart';

/// Double de test pour AuthController : évite tout accès au secure storage
/// (indisponible en environnement de test) en court-circuitant `build()`.
class _FakeAuthController extends AuthController {
  @override
  Future<AuthState> build() async => const AuthState();
}

void main() {
  testWidgets('LoginPage affiche le titre de connexion', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(() => _FakeAuthController()),
        ],
        child: MaterialApp(
          theme: AppTheme.get(ColorsLight.instance),
          localizationsDelegates: const [I18n.delegate],
          supportedLocales: const [Locale('fr'), Locale('en')],
          home: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(I18n.current.loginTitle), findsOneWidget);
  });
}
