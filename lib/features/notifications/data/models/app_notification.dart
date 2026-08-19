import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:feed_demo_flutter/shared/models/app_user.dart';
import 'notification_post.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// A "like" (for now) notification.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required int id,
    required String type,
    required bool read,
    required DateTime createdAt,
    required AppUser actor,
    NotificationPost? post,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

  String get message => switch (type) {
        'like' => '${actor.name} liked your post',
        _ => '${actor.name} did something',
      };
}
