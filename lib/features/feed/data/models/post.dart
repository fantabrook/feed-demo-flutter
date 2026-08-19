import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:feed_demo_flutter/shared/models/app_user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    String? content,
    String? imageUrl,
    required DateTime createdAt,
    required AppUser user,
    required int likeCount,
    required bool likedByMe,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
