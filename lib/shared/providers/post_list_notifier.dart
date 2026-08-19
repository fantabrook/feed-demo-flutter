import 'package:feed_demo_flutter/features/feed/data/models/like_result.dart';
import 'package:feed_demo_flutter/features/feed/data/models/post.dart';

/// Immutable state for any notifier that shows a list of posts (the main
/// feed and the profile's "my posts" grid). `isPosting` is only ever set
/// by `FeedNotifier` (composing a new post) — `ProfileNotifier` leaves it
/// at its default.
class PostListState {
  const PostListState({this.posts = const [], this.error, this.isPosting = false});

  final List<Post> posts;
  final String? error;
  final bool isPosting;

  PostListState copyWith({List<Post>? posts, String? error, bool? isPosting}) {
    return PostListState(
      posts: posts ?? this.posts,
      error: error,
      isPosting: isPosting ?? this.isPosting,
    );
  }
}

/// Shared list-transform helpers for like/edit/delete, used by both
/// `FeedNotifier` and `ProfileNotifier`. Kept as free functions rather
/// than a shared base class, since Riverpod-generated notifiers can't
/// share a common base beyond their own generated `_$Notifier` class.
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
