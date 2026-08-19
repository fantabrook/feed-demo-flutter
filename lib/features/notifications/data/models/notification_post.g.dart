// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPost _$NotificationPostFromJson(Map<String, dynamic> json) =>
    _NotificationPost(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$NotificationPostToJson(_NotificationPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
    };
