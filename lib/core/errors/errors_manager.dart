/// Gestion globale des erreurs applicatives
class ErrorsManager {
  ErrorsManager._();

  /// Point d'entrée unique pour traiter une erreur non catchée.
  /// En production, on pourrait envoyer à Crashlytics / Sentry.
  static void handle(Object error, StackTrace stack) {
    // TODO: intégrer un service de crash reporting (Sentry, Firebase Crashlytics…)
    debugPrint('[ErrorsManager] Unhandled error: $error\n$stack');
  }
}