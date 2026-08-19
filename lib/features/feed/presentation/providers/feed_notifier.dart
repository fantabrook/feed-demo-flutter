import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/shared/providers/post_list_notifier.dart';
import '../../data/models/post.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../data/repositories/post_repository_impl.dart';

part 'feed_notifier.g.dart';

/// The main feed — everyone's posts, newest first. Adds `createPost` on
/// top of the shared like/edit/delete logic in `shared/providers`.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  Future<PostListState> build() async {
    final posts = await ref.watch(feedRepositoryProvider).fetchFeed();
    return PostListState(posts: posts);
  }

  Future<bool> createPost({String? content, File? imageFile}) async {
    final current = state.value ?? const PostListState();
    state = AsyncData(current.copyWith(isPosting: true, error: null));
    try {
      final post = await ref.read(feedRepositoryProvider).createPost(content: content, imageFile: imageFile);
      state = AsyncData((state.value ?? current).copyWith(posts: [post, ...current.posts], isPosting: false));
      return true;
    } catch (e) {
      state = AsyncData(
        (state.value ?? current).copyWith(
          isPosting: false,
          error: e is ApiException ? e.message : 'Failed to create post',
        ),
      );
      return false;
    }
  }

  Future<void> toggleLike(Post post) {
    final current = state.value;
    if (current == null) return Future.value();
    return toggleLikeInList(
      current: current,
      repo: ref.read(postRepositoryProvider),
      post: post,
      readState: () => state.value ?? current,
      setState: (s) => state = AsyncData(s),
    );
  }

  Future<bool> editPost(int id, {String? content, File? imageFile, bool removeImage = false}) {
    final current = state.value;
    if (current == null) return Future.value(false);
    return editPostInList(
      current: current,
      repo: ref.read(postRepositoryProvider),
      id: id,
      content: content,
      imageFile: imageFile,
      removeImage: removeImage,
      setState: (s) => state = AsyncData(s),
    );
  }

  Future<void> deletePost(int id) {
    final current = state.value;
    if (current == null) return Future.value();
    return deletePostInList(
      current: current,
      repo: ref.read(postRepositoryProvider),
      id: id,
      setState: (s) => state = AsyncData(s),
    );
  }
}
