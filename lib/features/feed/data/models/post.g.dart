// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String?,
  imageUrl: json['imageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  likeCount: (json['likeCount'] as num).toInt(),
  likedByMe: json['likedByMe'] as bool,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'user': instance.user,
  'likeCount': instance.likeCount,
  'likedByMe': instance.likedByMe,
};
