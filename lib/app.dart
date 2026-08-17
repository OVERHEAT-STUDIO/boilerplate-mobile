import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';

import 'app_router.dart';
import 'core/localization/app_localization_helper.dart';
import 'core/localization/app_localization_notifier.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/colors/colors_dark.dart';
import 'core/theme/colors/colors_light.dart';
import 'core/utils/responsive.dart';

class MyApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = ref.watch(appLocalizationProvider);
    final appRouter = ref.watch(appRouterProvider);

    return AdaptiveTheme(
      light: AppTheme.get(ColorsLight.instance),
      dark: AppTheme.get(ColorsDark.instance),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (light, dark) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        locale: appLocale,
        supportedLocales: AppLocalizationHelper().supportedLocales,
        localizationsDelegates: const [
          I18n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: light,
        darkTheme: dark,
        builder: (context, child) {
          context.initResponsive();
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}