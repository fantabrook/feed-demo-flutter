// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Signed-in session: `null` data = signed out, non-null = signed in.
/// Loading = still restoring the persisted session on app start, or a
/// sign-in/sign-up submission in flight.

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Signed-in session: `null` data = signed out, non-null = signed in.
/// Loading = still restoring the persisted session on app start, or a
/// sign-in/sign-up submission in flight.
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, AppUser?> {
  /// Signed-in session: `null` data = signed out, non-null = signed in.
  /// Loading = still restoring the persisted session on app start, or a
  /// sign-in/sign-up submission in flight.
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'32b6177ede6b1edf579641c94daeab363872cf18';

/// Signed-in session: `null` data = signed out, non-null = signed in.
/// Loading = still restoring the persisted session on app start, or a
/// sign-in/sign-up submission in flight.

abstract class _$AuthNotifier extends $AsyncNotifier<AppUser?> {
  FutureOr<AppUser?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
              AsyncValue<AppUser?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
