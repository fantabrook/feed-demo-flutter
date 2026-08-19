// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wires up FCM: requests permission, registers the device token with the
/// backend, keeps it fresh, and surfaces foreground messages as a
/// SnackBar (Android only shows a system-tray notification automatically
/// when the app is backgrounded/terminated — a foreground app has to
/// display it itself, hence the SnackBar here).
///
/// Kept alive for the lifetime of the app (`keepAlive: true`): nothing
/// ever `watch`es/`listen`s this provider, only `ref.read`s it, so as a
/// plain autoDispose provider it would be torn down right after
/// `initialize()` returns — while its `onTokenRefresh`/`onMessage`
/// subscriptions are still live and would call back into a disposed `ref`.

@ProviderFor(PushNotifier)
final pushProvider = PushNotifierProvider._();

/// Wires up FCM: requests permission, registers the device token with the
/// backend, keeps it fresh, and surfaces foreground messages as a
/// SnackBar (Android only shows a system-tray notification automatically
/// when the app is backgrounded/terminated — a foreground app has to
/// display it itself, hence the SnackBar here).
///
/// Kept alive for the lifetime of the app (`keepAlive: true`): nothing
/// ever `watch`es/`listen`s this provider, only `ref.read`s it, so as a
/// plain autoDispose provider it would be torn down right after
/// `initialize()` returns — while its `onTokenRefresh`/`onMessage`
/// subscriptions are still live and would call back into a disposed `ref`.
final class PushNotifierProvider extends $NotifierProvider<PushNotifier, void> {
  /// Wires up FCM: requests permission, registers the device token with the
  /// backend, keeps it fresh, and surfaces foreground messages as a
  /// SnackBar (Android only shows a system-tray notification automatically
  /// when the app is backgrounded/terminated — a foreground app has to
  /// display it itself, hence the SnackBar here).
  ///
  /// Kept alive for the lifetime of the app (`keepAlive: true`): nothing
  /// ever `watch`es/`listen`s this provider, only `ref.read`s it, so as a
  /// plain autoDispose provider it would be torn down right after
  /// `initialize()` returns — while its `onTokenRefresh`/`onMessage`
  /// subscriptions are still live and would call back into a disposed `ref`.
  PushNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotifierHash();

  @$internal
  @override
  PushNotifier create() => PushNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushNotifierHash() => r'a6d1dc6a110e1224101d7cae0e71ba016d1cd30b';

/// Wires up FCM: requests permission, registers the device token with the
/// backend, keeps it fresh, and surfaces foreground messages as a
/// SnackBar (Android only shows a system-tray notification automatically
/// when the app is backgrounded/terminated — a foreground app has to
/// display it itself, hence the SnackBar here).
///
/// Kept alive for the lifetime of the app (`keepAlive: true`): nothing
/// ever `watch`es/`listen`s this provider, only `ref.read`s it, so as a
/// plain autoDispose provider it would be torn down right after
/// `initialize()` returns — while its `onTokenRefresh`/`onMessage`
/// subscriptions are still live and would call back into a disposed `ref`.

abstract class _$PushNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
