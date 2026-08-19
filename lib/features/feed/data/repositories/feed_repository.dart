import 'dart:io';

import '../models/post.dart';

abstract class FeedRepository {
  Future<List<Post>> fetchFeed();

  /// Creates a post. `imageFile` is optional — a post needs text and/or an
  /// image.
  Future<Post> createPost({String? content, File? imageFile});
}
