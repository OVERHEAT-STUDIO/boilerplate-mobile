import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../config/app_config.dart';

/// Point d'entrée unique vers PostHog.
///
/// Toutes les méthodes sont des no-op tant que [initialize] n'a pas réussi, et
/// aucune ne peut faire remonter une exception vers l'appelant : l'analytics ne
/// doit jamais casser un flow utilisateur.
class AnalyticsService {
  static AnalyticsService? _instance;

  AnalyticsService._();

  static AnalyticsService get instance => _instance ??= AnalyticsService._();

  bool _initialized = false;

  /// `true` une fois que le SDK est prêt à recevoir des events.
  bool get isEnabled => _initialized;

  /// Initialise le SDK. À appeler le plus tôt possible dans `main()`, avant
  /// `runApp`, pour que les crashs de démarrage soient déjà capturés.
  ///
  /// L'init native automatique est désactivée (`com.posthog.posthog.AUTO_INIT`
  /// à `false` dans le manifest Android et l'Info.plist iOS) : toute la config
  /// vit ici.
  Future<void> initialize() async {
    if (_initialized) return;
    if (AppConfig.posthogProjectToken.isEmpty) return;
    if (kDebugMode && !AppConfig.analyticsEnabledInDebug) return;

    final config = PostHogConfig(AppConfig.posthogProjectToken)
      ..host = AppConfig.posthogHost
      ..debug = kDebugMode && AppConfig.analyticsVerboseLogs
      ..captureApplicationLifecycleEvents = true
      // Pas de profil « personne » pour les visiteurs anonymes : seuls les
      // utilisateurs passés par identify() en créent un.
      ..personProfiles = PostHogPersonProfiles.identifiedOnly
      // Session replay : coûteux et sensible (tokens, données perso), on
      // laisse désactivé.
      ..sessionReplay = false;

    // Crash / error tracking.
    config.errorTrackingConfig
      // Erreurs du framework Flutter (FlutterError.onError).
      ..captureFlutterErrors = true
      // Erreurs Dart non catchées (PlatformDispatcher.onError).
      ..capturePlatformDispatcherErrors = true
      // Erreurs remontées par les isolates.
      ..captureIsolateErrors = true
      // Exceptions Java/Kotlin et crashs Mach/POSIX côté natif.
      ..captureNativeExceptions = true
      // Crashs NDK Android (envoyés au lancement suivant, API 31+).
      ..captureNativeCrashes = true;

    try {
      await Posthog().setup(config);
      _initialized = true;
      await Posthog().register(
        'environment',
        kDebugMode ? 'development' : 'production',
      );
    } catch (e, st) {
      _log('setup failed', e, st);
    }
  }

  /// Associe les events suivants à un utilisateur connu.
  Future<void> identify({
    required String userId,
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async {
    if (!_initialized) return;
    try {
      await Posthog().identify(
        userId: userId,
        userProperties: userProperties,
        userPropertiesSetOnce: userPropertiesSetOnce,
      );
    } catch (e, st) {
      _log('identify failed', e, st);
    }
  }

  /// Repart d'une identité anonyme (déconnexion).
  Future<void> reset() async {
    if (!_initialized) return;
    try {
      await Posthog().reset();
    } catch (e, st) {
      _log('reset failed', e, st);
    }
  }

  /// Envoie un event custom. Les propriétés nulles sont retirées.
  Future<void> capture(String eventName, {Map<String, Object?>? properties}) async {
    if (!_initialized) return;
    try {
      await Posthog().capture(
        eventName: eventName,
        properties: _clean(properties),
      );
    } catch (e, st) {
      _log('capture "$eventName" failed', e, st);
    }
  }

  /// Envoie un `$screen`. Le tracking automatique passe par `AppRouteObserver`,
  /// cette méthode ne sert qu'aux écrans qui ne sont pas des routes.
  Future<void> screen(String screenName, {Map<String, Object?>? properties}) async {
    if (!_initialized) return;
    try {
      await Posthog().screen(
        screenName: screenName,
        properties: _clean(properties),
      );
    } catch (e, st) {
      _log('screen "$screenName" failed', e, st);
    }
  }

  /// Remonte une erreur catchée en `$exception`. Les erreurs non catchées sont
  /// déjà captées automatiquement (voir `errorTrackingConfig` dans
  /// [initialize]).
  Future<void> captureException(
    Object error,
    StackTrace? stackTrace, {
    Map<String, Object?>? properties,
  }) async {
    if (!_initialized) return;
    try {
      await Posthog().captureException(
        error: error,
        stackTrace: stackTrace,
        properties: _clean(properties),
      );
    } catch (e, st) {
      _log('captureException failed', e, st);
    }
  }

  /// Ajoute un « breadcrumb » attaché aux `$exception` suivants, y compris aux
  /// crashs natifs remontés au lancement suivant.
  Future<void> addExceptionStep(String message, {Map<String, Object?>? properties}) async {
    if (!_initialized) return;
    try {
      await Posthog().addExceptionStep(message, properties: _clean(properties));
    } catch (e, st) {
      _log('addExceptionStep failed', e, st);
    }
  }

  /// Vide la file d'envoi. Utile juste avant une déconnexion ou une fermeture.
  Future<void> flush() async {
    if (!_initialized) return;
    try {
      await Posthog().flush();
    } catch (e, st) {
      _log('flush failed', e, st);
    }
  }

  Map<String, Object>? _clean(Map<String, Object?>? properties) {
    if (properties == null) return null;
    final cleaned = <String, Object>{};
    properties.forEach((key, value) {
      if (value != null) cleaned[key] = value;
    });
    return cleaned.isEmpty ? null : cleaned;
  }

  void _log(String message, Object error, StackTrace stackTrace) {
    if (!kDebugMode) return;
    debugPrint('[Analytics] $message — ${error.runtimeType}: $error');
  }
}
