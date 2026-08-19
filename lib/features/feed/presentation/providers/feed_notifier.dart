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

  Future<void> toggleLike(Post post) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(postRepositoryProvider);
    state = AsyncData(current.copyWith(posts: applyOptimisticLike(current.posts, post)));
    try {
      final result = await repo.toggleLike(post.id);
      final latest = state.value ?? current;
      state = AsyncData(latest.copyWith(posts: applyLikeResult(latest.posts, post.id, result)));
    } catch (_) {
      state = AsyncData(current);
    }
  }

  Future<bool> editPost(int id, {String? content, File? imageFile, bool removeImage = false}) async {
    final current = state.value;
    if (current == null) return false;
    try {
      final updated = await ref
          .read(postRepositoryProvider)
          .editPost(id, content: content, imageFile: imageFile, removeImage: removeImage);
      state = AsyncData(current.copyWith(posts: replacePost(current.posts, updated)));
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(error: e is ApiException ? e.message : 'Failed to update post'));
      return false;
    }
  }

  Future<void> deletePost(int id) async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(posts: removePost(current.posts, id)));
    try {
      await ref.read(postRepositoryProvider).deletePost(id);
    } catch (e) {
      state = AsyncData(current.copyWith(error: e is ApiException ? e.message : 'Failed to delete post'));
    }
  }
}
