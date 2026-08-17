import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../local_storage/local_storage_manager.dart';

part 'app_localization_notifier.g.dart';

@riverpod
class AppLocalizationNotifier extends _$AppLocalizationNotifier {
  final String defaultLocale = 'fr';
  final String localeKey = 'language_code';

  @override
  Locale build() => const Locale('fr');

  Future<void> fetchLocale() async {
    final String? languageCode =
        await ref.read(localStorageManagerProvider).read(key: localeKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> changeLanguage(Locale type) async {
    if (state != type) {
      state = type;
      await ref
          .read(localStorageManagerProvider)
          .write(key: localeKey, value: type.languageCode);
    }
  }
}