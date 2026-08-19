// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's own posts — backs the Profile tab. Same
/// like/edit/delete behavior as the feed (via the shared `PostRepository`),
/// sourced from `/posts/mine`.

@ProviderFor(ProfileNotifier)
final profileProvider = ProfileNotifierProvider._();

/// The signed-in user's own posts — backs the Profile tab. Same
/// like/edit/delete behavior as the feed (via the shared `PostRepository`),
/// sourced from `/posts/mine`.
final class ProfileNotifierProvider
    extends $AsyncNotifierProvider<ProfileNotifier, PostListState> {
  /// The signed-in user's own posts — backs the Profile tab. Same
  /// like/edit/delete behavior as the feed (via the shared `PostRepository`),
  /// sourced from `/posts/mine`.
  ProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();
}

String _$profileNotifierHash() => r'ac6d632354ec134c9b66c777f89de0067c964a24';

/// The signed-in user's own posts — backs the Profile tab. Same
/// like/edit/delete behavior as the feed (via the shared `PostRepository`),
/// sourced from `/posts/mine`.

abstract class _$ProfileNotifier extends $AsyncNotifier<PostListState> {
  FutureOr<PostListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostListState>, PostListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostListState>, PostListState>,
              AsyncValue<PostListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
