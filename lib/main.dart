import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'core/constants/breakpoints.dart';
import 'core/utils/haptic_manager.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  _initIsTablet();                           // 1. Détection tablette (avant tout)
  await HapticManager.instance.loadUseHaptics();
  await initializeDateFormatting();          // 2. Localisation des dates
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Paris'));

  await MobileAds.instance.initialize();    // 3. AdMob (optionnel)

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);   // 4. Hive

  final savedThemeMode =
      await AdaptiveTheme.getThemeMode();   // 5. Thème persisté

  // 6. Orientation selon le type d'écran
  if (isTablet) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // 7. Overrides Riverpod (mock en debug)
  final overrides = <Override>[
    // Exemple :
    // if (kDebugMode && AppConfig.useMockRewards)
    //   rewardsRepositoryProvider.overrideWithValue(MockRewardsRepository()),
  ];

  if (kDebugMode) {
    runApp(
      DevicePreview(
        enabled: false, // Toggle pour activer/désactiver DevicePreview
        builder: (_) => ProviderScope(
          overrides: overrides,
          child: MyApp(savedThemeMode: savedThemeMode),
        ),
      ),
    );
  } else {
    runApp(
      ProviderScope(
        overrides: overrides,
        child: MyApp(savedThemeMode: savedThemeMode),
      ),
    );
  }
}

late final bool isTablet;

void _initIsTablet() {
  final view = PlatformDispatcher.instance.views.first;
  final logicalSize = view.physicalSize / view.devicePixelRatio;
  isTablet = logicalSize.shortestSide >= Breakpoints.tablet;
}