// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class I18n {
  I18n();

  static I18n? _current;

  static I18n get current {
    assert(
      _current != null,
      'No instance of I18n was loaded. Try to initialize the I18n delegate before accessing I18n.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<I18n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = I18n();
      I18n._current = instance;

      return instance;
    });
  }

  static I18n of(BuildContext context) {
    final instance = I18n.maybeOf(context);
    assert(
      instance != null,
      'No instance of I18n present in the widget tree. Did you add I18n.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static I18n? maybeOf(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  /// `fr`
  String get _locale {
    return Intl.message('fr', name: '_locale', desc: '', args: []);
  }

  /// `Réessayer`
  String get retry {
    return Intl.message('Réessayer', name: 'retry', desc: '', args: []);
  }

  /// `Fermer`
  String get close {
    return Intl.message('Fermer', name: 'close', desc: '', args: []);
  }

  /// `Maintenance`
  String get maintenance {
    return Intl.message('Maintenance', name: 'maintenance', desc: '', args: []);
  }

  /// `Continuer`
  String get continueLabel {
    return Intl.message('Continuer', name: 'continueLabel', desc: '', args: []);
  }

  /// `Annuler`
  String get cancelLabel {
    return Intl.message('Annuler', name: 'cancelLabel', desc: '', args: []);
  }

  /// `Sauvegarder`
  String get saveLabel {
    return Intl.message('Sauvegarder', name: 'saveLabel', desc: '', args: []);
  }

  /// `Réglages`
  String get settings {
    return Intl.message('Réglages', name: 'settings', desc: '', args: []);
  }

  /// `Apparence`
  String get appearance {
    return Intl.message('Apparence', name: 'appearance', desc: '', args: []);
  }

  /// `Langue`
  String get locale {
    return Intl.message('Langue', name: 'locale', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Compte`
  String get account {
    return Intl.message('Compte', name: 'account', desc: '', args: []);
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `Avis`
  String get rating {
    return Intl.message('Avis', name: 'rating', desc: '', args: []);
  }

  /// `Rechercher`
  String get search {
    return Intl.message('Rechercher', name: 'search', desc: '', args: []);
  }

  /// `Chargement…`
  String get loading {
    return Intl.message('Chargement…', name: 'loading', desc: '', args: []);
  }

  /// `Aucun résultat`
  String get noResults {
    return Intl.message(
      'Aucun résultat',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur est survenue`
  String get errorOccurred {
    return Intl.message(
      'Une erreur est survenue',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Introuvable`
  String get errorNotFound {
    return Intl.message(
      'Introuvable',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Accès refusé`
  String get errorApiForbidden {
    return Intl.message(
      'Accès refusé',
      name: 'errorApiForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur est survenue. Veuillez réessayer.`
  String get errorApiGenericError {
    return Intl.message(
      'Une erreur est survenue. Veuillez réessayer.',
      name: 'errorApiGenericError',
      desc: '',
      args: [],
    );
  }

  /// `Erreur inconnue ({code})`
  String errorApiUnknown(Object code) {
    return Intl.message(
      'Erreur inconnue ($code)',
      name: 'errorApiUnknown',
      desc: '',
      args: [code],
    );
  }

  /// `Trop de requêtes. Veuillez réessayer plus tard.`
  String get errorApiRateLimited {
    return Intl.message(
      'Trop de requêtes. Veuillez réessayer plus tard.',
      name: 'errorApiRateLimited',
      desc: '',
      args: [],
    );
  }

  /// `Champs obligatoires manquants.`
  String get errorApiMissingRequiredFields {
    return Intl.message(
      'Champs obligatoires manquants.',
      name: 'errorApiMissingRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Session expirée. Veuillez vous reconnecter.`
  String get errorApiInvalidToken {
    return Intl.message(
      'Session expirée. Veuillez vous reconnecter.',
      name: 'errorApiInvalidToken',
      desc: '',
      args: [],
    );
  }

  /// `Veuillez désactiver votre VPN pour continuer.`
  String get errorApiVpnDetected {
    return Intl.message(
      'Veuillez désactiver votre VPN pour continuer.',
      name: 'errorApiVpnDetected',
      desc: '',
      args: [],
    );
  }

  /// `Votre compte a été suspendu.`
  String get errorApiSuspendedUser {
    return Intl.message(
      'Votre compte a été suspendu.',
      name: 'errorApiSuspendedUser',
      desc: '',
      args: [],
    );
  }

  /// `Connexion`
  String get login {
    return Intl.message('Connexion', name: 'login', desc: '', args: []);
  }

  /// `Bienvenue`
  String get loginTitle {
    return Intl.message('Bienvenue', name: 'loginTitle', desc: '', args: []);
  }

  /// `Connectez-vous à votre compte`
  String get loginSubtitle {
    return Intl.message(
      'Connectez-vous à votre compte',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Déconnexion`
  String get logout {
    return Intl.message('Déconnexion', name: 'logout', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Mot de passe`
  String get password {
    return Intl.message('Mot de passe', name: 'password', desc: '', args: []);
  }

  /// `Mot de passe oublié ?`
  String get forgotPassword {
    return Intl.message(
      'Mot de passe oublié ?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Pas encore de compte ?`
  String get noAccount {
    return Intl.message(
      'Pas encore de compte ?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `S'inscrire`
  String get register {
    return Intl.message('S\'inscrire', name: 'register', desc: '', args: []);
  }

  /// `Accueil`
  String get home {
    return Intl.message('Accueil', name: 'home', desc: '', args: []);
  }

  /// `Profil`
  String get profile {
    return Intl.message('Profil', name: 'profile', desc: '', args: []);
  }

  /// `Bienvenue, {username} !`
  String welcomeUser(String username) {
    return Intl.message(
      'Bienvenue, $username !',
      name: 'welcomeUser',
      desc: '',
      args: [username],
    );
  }

  /// `{count, plural, =0{Aucun élément} =1{1 élément} other{{count} éléments}}`
  String itemCount(int count) {
    return Intl.plural(
      count,
      zero: 'Aucun élément',
      one: '1 élément',
      other: '$count éléments',
      name: 'itemCount',
      desc: '',
      args: [count],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<I18n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
