import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
