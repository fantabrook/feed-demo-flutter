// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actor: AppUser.fromJson(json['actor'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : NotificationPost.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
      'actor': instance.actor,
      'post': instance.post,
    };
