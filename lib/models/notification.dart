import 'user.dart';

/// A "like" (for now) notification. Mirrors the shape returned by
/// `GET /notifications` in `feed-demo-backend/src/routes/notifications.js`.
class AppNotification {
  final int id;
  final String type;
  final bool read;
  final DateTime createdAt;
  final AppUser actor;
  final NotificationPost? post;

  AppNotification({
    required this.id,
    required this.type,
    required this.read,
    required this.createdAt,
    required this.actor,
    required this.post,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      type: json['type'] as String,
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actor: AppUser.fromJson(json['actor'] as Map<String, dynamic>),
      post: json['post'] != null ? NotificationPost.fromJson(json['post'] as Map<String, dynamic>) : null,
    );
  }

  String get message {
    switch (type) {
      case 'like':
        return '${actor.name} liked your post';
      default:
        return '${actor.name} did something';
    }
  }
}

/// The trimmed-down post payload embedded in a notification.
class NotificationPost {
  final int id;
  final String? content;
  final String? imageUrl;

  NotificationPost({required this.id, required this.content, required this.imageUrl});

  factory NotificationPost.fromJson(Map<String, dynamic> json) {
    return NotificationPost(
      id: json['id'] as int,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
