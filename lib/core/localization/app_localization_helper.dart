import 'package:flutter/material.dart';

class AppLocalizationHelper {
  List<Locale> localeList = [const Locale('fr'), const Locale('en')];

  List<Locale> get supportedLocales {
    return List.unmodifiable(localeList);
  }

  Locale? getLocaleFromLanguageCode(String code) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == code) {
        return locale;
      }
    }
    return null;
  }

  String getFlagPath(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'fr':
        return 'assets/images/flags/fr.png';
      case 'en':
        return 'assets/images/flags/en.png';
      default:
        return '';
    }
  }

  String getLocaleName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      default:
        return '';
    }
  }
}