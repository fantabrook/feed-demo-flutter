import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_post.freezed.dart';
part 'notification_post.g.dart';

/// The trimmed-down post payload embedded in a notification.
@freezed
abstract class NotificationPost with _$NotificationPost {
  const factory NotificationPost({
    required int id,
    String? content,
    String? imageUrl,
  }) = _NotificationPost;

  factory NotificationPost.fromJson(Map<String, dynamic> json) => _$NotificationPostFromJson(json);
}
