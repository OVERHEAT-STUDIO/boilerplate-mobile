// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localStorageManager)
final localStorageManagerProvider = LocalStorageManagerProvider._();

final class LocalStorageManagerProvider
    extends
        $FunctionalProvider<
          LocalStorageManager,
          LocalStorageManager,
          LocalStorageManager
        >
    with $Provider<LocalStorageManager> {
  LocalStorageManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageManagerHash();

  @$internal
  @override
  $ProviderElement<LocalStorageManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalStorageManager create(Ref ref) {
    return localStorageManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorageManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorageManager>(value),
    );
  }
}

String _$localStorageManagerHash() =>
    r'586fdc632a419b0be8964d71b33df08e5a13a9da';
