/// Noms des events custom envoyés à PostHog.
///
/// Convention PostHog : `[objet] [verbe]`, en minuscules. Les events préfixés
/// par `$` (`$screen`, `$exception`, cycle de vie applicatif) sont produits
/// automatiquement par le SDK et n'ont pas à être listés ici.
class AnalyticsEvents {
  const AnalyticsEvents._();

  /// Tap utilisateur remonté par `InteractionScope`.
  static const String uiInteraction = 'ui interaction';

  static const String userLoggedIn = 'user logged in';
  static const String userLoggedOut = 'user logged out';
}

/// Propriétés d'event réutilisées à plusieurs endroits.
class AnalyticsProperties {
  const AnalyticsProperties._();

  static const String source = 'source';
  static const String delta = 'delta';
  static const String route = 'route';
  static const String interactionTotal = 'interaction_total';
  static const String method = 'method';
}

/// Méthodes d'authentification, utilisées comme valeur de
/// [AnalyticsProperties.method].
class AnalyticsAuthMethod {
  const AnalyticsAuthMethod._();

  static const String password = 'password';
}
