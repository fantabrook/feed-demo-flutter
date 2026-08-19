import 'dart:io';

import '../models/like_result.dart';
import '../models/post.dart';

/// Post operations shared between the feed and profile screens: like,
/// edit, delete. Fetching the initial list is feature-specific (see
/// `FeedRepository`/`ProfileRepository`).
abstract class PostRepository {
  Future<LikeResult> toggleLike(int postId);

  /// Edits a post's text and/or image. `removeImage: true` drops the
  /// current image (ignored if `imageFile` is also given). Passing
  /// nothing for an argument leaves that field untouched server-side.
  Future<Post> editPost(int id, {String? content, File? imageFile, bool removeImage = false});

  Future<void> deletePost(int id);
}
