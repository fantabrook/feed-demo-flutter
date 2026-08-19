import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/app_notification.dart';
import '../../data/repositories/notifications_repository_impl.dart';

part 'notifications_notifier.g.dart';

class NotificationsState {
  const NotificationsState({this.notifications = const [], this.unreadCount = 0});

  final List<AppNotification> notifications;
  final int unreadCount;

  NotificationsState copyWith({List<AppNotification>? notifications, int? unreadCount}) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Loads the notification list and polls the unread count every 20s.
@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<NotificationsState> build() async {
    final repo = ref.watch(notificationsRepositoryProvider);

    final timer = Timer.periodic(const Duration(seconds: 20), (_) => _pollUnreadCount());
    ref.onDispose(timer.cancel);

    final notifications = await repo.fetchNotifications();
    final unreadCount = await repo.fetchUnreadCount();
    return NotificationsState(notifications: notifications, unreadCount: unreadCount);
  }

  Future<void> _pollUnreadCount() async {
    final current = state.value;
    if (current == null) return;
    try {
      final unreadCount = await ref.read(notificationsRepositoryProvider).fetchUnreadCount();
      state = AsyncData(current.copyWith(unreadCount: unreadCount));
    } catch (_) {
      // Silent — a missed poll isn't worth surfacing an error for.
    }
  }

  /// Call when the notifications tab is opened.
  Future<void> markAllRead() async {
    final current = state.value;
    if (current == null || current.unreadCount == 0) return;
    state = AsyncData(current.copyWith(unreadCount: 0));
    try {
      await ref.read(notificationsRepositoryProvider).markAllRead();
    } catch (_) {
      // Best-effort; the next poll will resync the true count if this failed.
    }
  }
}
