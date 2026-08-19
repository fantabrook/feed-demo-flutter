import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../services/api_client.dart';

/// Loads the notification list and polls the unread count every 20s —
/// same interval and behavior as `context/notifications.tsx` on the Expo
/// side (that one also uses polling rather than a push-driven badge).
class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider(this._api) {
    _pollUnreadCount();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _pollUnreadCount());
  }

  final ApiClient _api;
  Timer? _timer;

  List<AppNotification> notifications = [];
  int unreadCount = 0;
  bool isLoading = false;
  String? error;

  Future<void> _pollUnreadCount() async {
    try {
      unreadCount = await _api.fetchUnreadCount();
      notifyListeners();
    } catch (_) {
      // Silent — a missed poll isn't worth surfacing an error for.
    }
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      notifications = await _api.fetchNotifications();
    } catch (e) {
      error = e is ApiException ? e.message : 'Failed to load notifications';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Call when the notifications tab is opened — mirrors the Expo screen
  /// marking everything read on focus.
  Future<void> markAllRead() async {
    if (unreadCount == 0) return;
    unreadCount = 0;
    notifyListeners();
    try {
      await _api.markAllNotificationsRead();
    } catch (_) {
      // Best-effort; the next poll will resync the true count if this failed.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
