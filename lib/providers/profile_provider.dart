import '../models/post.dart';
import 'post_list_provider.dart';

/// The signed-in user's own posts — backs the Profile tab. Same
/// like/edit/delete behavior as the feed, sourced from `/posts/mine`.
class ProfileProvider extends PostListProvider {
  ProfileProvider(super.api);

  @override
  Future<List<Post>> fetchSource() => api.fetchMyPosts();
}
