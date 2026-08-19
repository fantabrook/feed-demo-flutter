// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted light/dark/system preference. App-wide UI state, so it lives
/// in `core/` rather than under any one feature.

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

/// Persisted light/dark/system preference. App-wide UI state, so it lives
/// in `core/` rather than under any one feature.
final class ThemeNotifierProvider
    extends $AsyncNotifierProvider<ThemeNotifier, ThemeMode> {
  /// Persisted light/dark/system preference. App-wide UI state, so it lives
  /// in `core/` rather than under any one feature.
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();
}

String _$themeNotifierHash() => r'42848ae9b0877fcc311a39c1f2a6e8840885fa4e';

/// Persisted light/dark/system preference. App-wide UI state, so it lives
/// in `core/` rather than under any one feature.

abstract class _$ThemeNotifier extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
