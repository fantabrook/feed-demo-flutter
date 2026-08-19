import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'api_client.dart';

/// Wires up FCM: requests permission, registers the device token with the
/// backend, keeps it fresh, and surfaces foreground messages (Android only
/// shows a system-tray notification automatically when the app is
/// backgrounded/terminated — a foreground app has to display it itself,
/// hence the SnackBar here).
///
/// Counterpart of `lib/pushNotifications.ts` on the Expo side, except that
/// side talks to Expo's push service; this one talks to Firebase directly
/// since a Flutter app has no Expo runtime to mint an Expo push token with
/// (see the note on `feed-demo-backend/src/lib/push.js`).
class PushService {
  PushService(this._api, this._messengerKey);

  final ApiClient _api;
  final GlobalKey<ScaffoldMessengerState> _messengerKey;

  String? _registeredToken;

  Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return; // user said no — nothing more to do
    }

    final token = await messaging.getToken();
    if (token != null) {
      await _register(token);
    }

    // The OS can rotate the token (app reinstall, backup restore, etc.) —
    // keep the backend's copy in sync whenever that happens.
    FirebaseMessaging.instance.onTokenRefresh.listen(_register);

    FirebaseMessaging.onMessage.listen(_showForegroundMessage);
  }

  Future<void> _register(String token) async {
    _registeredToken = token;
    try {
      await _api.registerPushToken(token);
    } catch (_) {
      // Best-effort — a failed registration just means this device won't
      // get pushes until the next successful retry (e.g. next app open).
    }
  }

  void _showForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;
    if (title == null && body == null) return;

    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text([title, body].whereType<String>().join(' — ')),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Call on sign-out so a shared/borrowed device stops receiving pushes
  /// for an account no longer signed in on it.
  Future<void> unregister() async {
    final token = _registeredToken;
    if (token == null) return;
    try {
      await _api.removePushToken(token);
    } catch (_) {
      // Best-effort.
    }
    _registeredToken = null;
  }
}
