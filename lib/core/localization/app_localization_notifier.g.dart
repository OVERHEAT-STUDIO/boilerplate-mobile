// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_localization_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppLocalizationNotifier)
final appLocalizationProvider = AppLocalizationNotifierProvider._();

final class AppLocalizationNotifierProvider
    extends $NotifierProvider<AppLocalizationNotifier, Locale> {
  AppLocalizationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocalizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocalizationNotifierHash();

  @$internal
  @override
  AppLocalizationNotifier create() => AppLocalizationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocalizationNotifierHash() =>
    r'944d4ae584de6ca0c1ef2d68e5cd1b2113df127f';

abstract class _$AppLocalizationNotifier extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
