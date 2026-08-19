import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/features/feed/data/models/post.dart';
import 'package:feed_demo_flutter/features/feed/data/repositories/post_repository_impl.dart';
import 'package:feed_demo_flutter/shared/providers/post_list_notifier.dart';
import '../../data/repositories/profile_repository_impl.dart';

part 'profile_notifier.g.dart';

/// The signed-in user's own posts — backs the Profile tab. Same
/// like/edit/delete behavior as the feed (via the shared `PostRepository`),
/// sourced from `/posts/mine`.
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<PostListState> build() async {
    final posts = await ref.watch(profileRepositoryProvider).fetchMyPosts();
    return PostListState(posts: posts);
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
