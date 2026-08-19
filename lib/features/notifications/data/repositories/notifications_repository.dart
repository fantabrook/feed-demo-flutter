import '../models/app_notification.dart';

abstract class NotificationsRepository {
  Future<List<AppNotification>> fetchNotifications();
  Future<int> fetchUnreadCount();
  Future<void> markAllRead();
}
