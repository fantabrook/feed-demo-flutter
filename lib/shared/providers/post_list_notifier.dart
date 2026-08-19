import 'dart:io';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/features/feed/data/models/like_result.dart';
import 'package:feed_demo_flutter/features/feed/data/models/post.dart';
import 'package:feed_demo_flutter/features/feed/data/repositories/post_repository.dart';

/// Sentinel distinguishing "not passed" from "explicitly passed null" in
/// [PostListState.copyWith], so omitting `error:` preserves the existing
/// error instead of silently clearing it.
class _Unset {
  const _Unset();
}

const _unset = _Unset();

/// Immutable state for any notifier that shows a list of posts (the main
/// feed and the profile's "my posts" grid). `isPosting` is only ever set
/// by `FeedNotifier` (composing a new post) — `ProfileNotifier` leaves it
/// at its default.
class PostListState {
  const PostListState({this.posts = const [], this.error, this.isPosting = false});

  final List<Post> posts;
  final String? error;
  final bool isPosting;

  /// Pass `error: null` to explicitly clear the error, or omit it to
  /// leave whatever error (if any) was already set.
  PostListState copyWith({List<Post>? posts, Object? error = _unset, bool? isPosting}) {
    return PostListState(
      posts: posts ?? this.posts,
      error: identical(error, _unset) ? this.error : error as String?,
      isPosting: isPosting ?? this.isPosting,
    );
  }
}

/// Shared list-transform helpers for like/edit/delete, used by both
/// `FeedNotifier` and `ProfileNotifier`.
List<Post> applyOptimisticLike(List<Post> posts, Post post) {
  final index = posts.indexWhere((p) => p.id == post.id);
  if (index == -1) return posts;
  final updated = [...posts];
  updated[index] = post.copyWith(
    likedByMe: !post.likedByMe,
    likeCount: post.likedByMe ? post.likeCount - 1 : post.likeCount + 1,
  );
  return updated;
}

List<Post> applyLikeResult(List<Post> posts, int postId, LikeResult result) {
  final index = posts.indexWhere((p) => p.id == postId);
  if (index == -1) return posts;
  final updated = [...posts];
  updated[index] = updated[index].copyWith(likedByMe: result.liked, likeCount: result.likeCount);
  return updated;
}

List<Post> replacePost(List<Post> posts, Post updated) {
  final index = posts.indexWhere((p) => p.id == updated.id);
  if (index == -1) return posts;
  final list = [...posts];
  list[index] = updated;
  return list;
}

List<Post> removePost(List<Post> posts, int id) => posts.where((p) => p.id != id).toList();

/// Shared like/edit/delete control flow (optimistic update → call the
/// repository → reconcile or revert), used by both `FeedNotifier` and
/// `ProfileNotifier`. Implemented as free functions taking a `setState`
/// callback rather than a shared base class, since Riverpod-generated
/// notifiers can't share a common base beyond their own generated
/// `_$Notifier` class.
Future<void> toggleLikeInList({
  required PostListState current,
  required PostRepository repo,
  required Post post,
  required PostListState Function() readState,
  required void Function(PostListState) setState,
}) async {
  setState(current.copyWith(posts: applyOptimisticLike(current.posts, post)));
  try {
    final result = await repo.toggleLike(post.id);
    final latest = readState();
    setState(latest.copyWith(posts: applyLikeResult(latest.posts, post.id, result)));
  } catch (_) {
    setState(current);
  }
}

Future<bool> editPostInList({
  required PostListState current,
  required PostRepository repo,
  required int id,
  required void Function(PostListState) setState,
  String? content,
  File? imageFile,
  bool removeImage = false,
}) async {
  try {
    final updated = await repo.editPost(id, content: content, imageFile: imageFile, removeImage: removeImage);
    setState(current.copyWith(posts: replacePost(current.posts, updated)));
    return true;
  } catch (e) {
    setState(current.copyWith(error: e is ApiException ? e.message : 'Failed to update post'));
    return false;
  }
}

Future<void> deletePostInList({
  required PostListState current,
  required PostRepository repo,
  required int id,
  required void Function(PostListState) setState,
}) async {
  setState(current.copyWith(posts: removePost(current.posts, id)));
  try {
    await repo.deletePost(id);
  } catch (e) {
    setState(current.copyWith(error: e is ApiException ? e.message : 'Failed to delete post'));
  }
}
