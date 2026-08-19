import 'user.dart';

class Post {
  final int id;
  final String? content;
  final String? imageUrl;
  final DateTime createdAt;
  final AppUser user;
  final int likeCount;
  final bool likedByMe;

  Post({
    required this.id,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.user,
    required this.likeCount,
    required this.likedByMe,
  });

  bool get isMine => false; // set contextually by the feed provider when needed

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      likeCount: json['likeCount'] as int,
      likedByMe: json['likedByMe'] as bool,
    );
  }

  Post copyWith({int? likeCount, bool? likedByMe}) {
    return Post(
      id: id,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
      user: user,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}
