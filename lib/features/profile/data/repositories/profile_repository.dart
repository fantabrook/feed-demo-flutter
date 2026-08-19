import 'package:feed_demo_flutter/features/feed/data/models/post.dart';

abstract class ProfileRepository {
  Future<List<Post>> fetchMyPosts();
}
