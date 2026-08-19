import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/api_client.dart';

/// Shared like/edit/delete logic for any screen that shows a list of posts
/// (the main feed and the profile's "my posts" grid). Subclasses just say
/// where the initial list comes from.
abstract class PostListProvider extends ChangeNotifier {
  PostListProvider(this.api);

  final ApiClient api;

  List<Post> posts = [];
  bool isLoading = false;
  String? error;

  /// Subclasses fetch from whichever endpoint is appropriate
  /// (`/posts` for the feed, `/posts/mine` for the profile).
  Future<List<Post>> fetchSource();

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      posts = await fetchSource();
    } catch (e) {
      error = e is ApiException ? e.message : 'Failed to load posts';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(Post post) async {
    final index = posts.indexWhere((p) => p.id == post.id);
    if (index == -1) return;

    final previous = posts[index];
    posts[index] = previous.copyWith(
      likedByMe: !previous.likedByMe,
      likeCount: previous.likedByMe ? previous.likeCount - 1 : previous.likeCount + 1,
    );
    notifyListeners();

    try {
      final result = await api.toggleLike(post.id);
      final current = posts.indexWhere((p) => p.id == post.id);
      if (current != -1) {
        posts[current] = posts[current].copyWith(likedByMe: result.liked, likeCount: result.likeCount);
        notifyListeners();
      }
    } catch (_) {
      final current = posts.indexWhere((p) => p.id == post.id);
      if (current != -1) {
        posts[current] = previous;
        notifyListeners();
      }
    }
  }

  Future<bool> editPost(int id, {String? content, File? imageFile, bool removeImage = false}) async {
    error = null;
    try {
      final updated = await api.editPost(id, content: content, imageFile: imageFile, removeImage: removeImage);
      final index = posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        posts[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      error = e is ApiException ? e.message : 'Failed to update post';
      notifyListeners();
      return false;
    }
  }

  Future<void> deletePost(int id) async {
    final previous = posts;
    posts = posts.where((p) => p.id != id).toList();
    notifyListeners();
    try {
      await api.deletePost(id);
    } catch (e) {
      posts = previous;
      error = e is ApiException ? e.message : 'Failed to delete post';
      notifyListeners();
    }
  }
}
