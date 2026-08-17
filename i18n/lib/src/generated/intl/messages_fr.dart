// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(code) => "Erreur inconnue (${code})";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'Aucun élément', one: '1 élément', other: '${count} éléments')}";

  static String m2(username) => "Bienvenue, ${username} !";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "_locale": MessageLookupByLibrary.simpleMessage("fr"),
    "account": MessageLookupByLibrary.simpleMessage("Compte"),
    "appearance": MessageLookupByLibrary.simpleMessage("Apparence"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "close": MessageLookupByLibrary.simpleMessage("Fermer"),
    "continueLabel": MessageLookupByLibrary.simpleMessage("Continuer"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "errorApiForbidden": MessageLookupByLibrary.simpleMessage("Accès refusé"),
    "errorApiGenericError": MessageLookupByLibrary.simpleMessage(
      "Une erreur est survenue. Veuillez réessayer.",
    ),
    "errorApiInvalidToken": MessageLookupByLibrary.simpleMessage(
      "Session expirée. Veuillez vous reconnecter.",
    ),
    "errorApiMissingRequiredFields": MessageLookupByLibrary.simpleMessage(
      "Champs obligatoires manquants.",
    ),
    "errorApiRateLimited": MessageLookupByLibrary.simpleMessage(
      "Trop de requêtes. Veuillez réessayer plus tard.",
    ),
    "errorApiSuspendedUser": MessageLookupByLibrary.simpleMessage(
      "Votre compte a été suspendu.",
    ),
    "errorApiUnknown": m0,
    "errorApiVpnDetected": MessageLookupByLibrary.simpleMessage(
      "Veuillez désactiver votre VPN pour continuer.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Introuvable"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage(
      "Une erreur est survenue",
    ),
    "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Mot de passe oublié ?",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Accueil"),
    "itemCount": m1,
    "loading": MessageLookupByLibrary.simpleMessage("Chargement…"),
    "locale": MessageLookupByLibrary.simpleMessage("Langue"),
    "login": MessageLookupByLibrary.simpleMessage("Connexion"),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous à votre compte",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Bienvenue"),
    "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "maintenance": MessageLookupByLibrary.simpleMessage("Maintenance"),
    "noAccount": MessageLookupByLibrary.simpleMessage("Pas encore de compte ?"),
    "noResults": MessageLookupByLibrary.simpleMessage("Aucun résultat"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "rating": MessageLookupByLibrary.simpleMessage("Avis"),
    "register": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
    "retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "saveLabel": MessageLookupByLibrary.simpleMessage("Sauvegarder"),
    "search": MessageLookupByLibrary.simpleMessage("Rechercher"),
    "settings": MessageLookupByLibrary.simpleMessage("Réglages"),
    "welcomeUser": m2,
  };
}
