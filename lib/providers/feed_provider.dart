import 'dart:io';

import '../models/post.dart';
import '../services/api_client.dart';
import 'post_list_provider.dart';

/// The main feed — everyone's posts, newest first. Adds `createPost` on
/// top of the shared like/edit/delete logic in [PostListProvider].
class FeedProvider extends PostListProvider {
  FeedProvider(super.api);

  bool isPosting = false;

  @override
  Future<List<Post>> fetchSource() => api.fetchFeed();

  Future<bool> createPost({String? content, File? imageFile}) async {
    isPosting = true;
    error = null;
    notifyListeners();
    try {
      final post = await api.createPost(content: content, imageFile: imageFile);
      posts = [post, ...posts];
      return true;
    } catch (e) {
      error = e is ApiException ? e.message : 'Failed to create post';
      return false;
    } finally {
      isPosting = false;
      notifyListeners();
    }
  }
}
