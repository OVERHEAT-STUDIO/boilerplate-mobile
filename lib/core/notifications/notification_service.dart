/// Service de notifications. Template à adapter selon le projet.
///
/// Pour OneSignal :
///   - Ajouter `onesignal_flutter` aux dépendances
///   - Implémenter l'initialisation dans `main.dart`
///   - Configurer les permissions iOS dans Info.plist
///
/// Pour Firebase Cloud Messaging :
///   - Ajouter `firebase_messaging` + `firebase_core`
///   - Configurer google-services.json / GoogleService-Info.plist
class NotificationService {
  NotificationService._();

  /// Initialisation des notifications (à customiser selon le projet)
  static Future<void> initialize() async {
    // TODO: initialiser OneSignal, Firebase Messaging, etc.
  }
}