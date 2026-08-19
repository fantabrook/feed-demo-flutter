// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The main feed — everyone's posts, newest first. Adds `createPost` on
/// top of the shared like/edit/delete logic in `shared/providers`.

@ProviderFor(FeedNotifier)
final feedProvider = FeedNotifierProvider._();

/// The main feed — everyone's posts, newest first. Adds `createPost` on
/// top of the shared like/edit/delete logic in `shared/providers`.
final class FeedNotifierProvider
    extends $AsyncNotifierProvider<FeedNotifier, PostListState> {
  /// The main feed — everyone's posts, newest first. Adds `createPost` on
  /// top of the shared like/edit/delete logic in `shared/providers`.
  FeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedNotifierHash();

  @$internal
  @override
  FeedNotifier create() => FeedNotifier();
}

String _$feedNotifierHash() => r'670fde8898fe315443ad55b52d2f73591675dfa4';

/// The main feed — everyone's posts, newest first. Adds `createPost` on
/// top of the shared like/edit/delete logic in `shared/providers`.

abstract class _$FeedNotifier extends $AsyncNotifier<PostListState> {
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
