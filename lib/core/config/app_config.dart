class AppConfig {
  // Exemple : Turnstile
  // static const String turnstileSiteKey = '0x4AAAAAABatdr8HOClLTfKL';

  // Mock flags
  static const bool useMockRewards = false;

  // AdMob (remplacer par vos IDs)
  // static const String admobAppIdAndroid = '...';
  // static const String admobAppIdIos = '...';
  // static const String rewardedAdUnitIdAndroid = '...';
  // static const String rewardedAdUnitIdIos = '...';

  // PostHog (remplacer par votre token de projet). L'init est faite côté
  // Dart (AnalyticsService), pas par le SDK natif : `com.posthog.posthog.AUTO_INIT`
  // est à `false` dans le manifest Android et l'Info.plist iOS pour éviter une
  // double initialisation. Tant que le token est vide, AnalyticsService reste
  // un no-op.
  static const String posthogProjectToken = '';
  static const String posthogHost = 'https://us.i.posthog.com';

  // Laisser à `true` permet de valider l'intégration depuis un build debug. Les
  // events portent alors `environment: development`, ce qui permet de les
  // filtrer côté PostHog.
  static const bool analyticsEnabledInDebug = true;
  static const bool analyticsVerboseLogs = false;

  static const bool interactionDebugLogs = true;
  static const int interactionWeightDefault = 1;

  static const bool forceLoadingState = false;
}