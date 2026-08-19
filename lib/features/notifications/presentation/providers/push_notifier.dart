import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/messenger_key.dart';
import '../../data/repositories/push_repository_impl.dart';

part 'push_notifier.g.dart';

/// Wires up FCM: requests permission, registers the device token with the
/// backend, keeps it fresh, and surfaces foreground messages as a
/// SnackBar (Android only shows a system-tray notification automatically
/// when the app is backgrounded/terminated — a foreground app has to
/// display it itself, hence the SnackBar here).
///
/// Kept alive for the lifetime of the app (`keepAlive: true`): nothing
/// ever `watch`es/`listen`s this provider, only `ref.read`s it, so as a
/// plain autoDispose provider it would be torn down right after
/// `initialize()` returns — while its `onTokenRefresh`/`onMessage`
/// subscriptions are still live and would call back into a disposed `ref`.
@Riverpod(keepAlive: true)
class PushNotifier extends _$PushNotifier {
  String? _registeredToken;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;

  @override
  void build() {
    ref.onDispose(() {
      _tokenRefreshSub?.cancel();
      _onMessageSub?.cancel();
      _registeredToken = null;
    });
  }

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
    // keep the backend's copy in sync whenever that happens. Guarded so a
    // second `initialize()` call (e.g. re-sign-in) doesn't stack listeners.
    _tokenRefreshSub ??= FirebaseMessaging.instance.onTokenRefresh.listen(_register);
    _onMessageSub ??= FirebaseMessaging.onMessage.listen(_showForegroundMessage);
  }

  Future<void> _register(String token) async {
    _registeredToken = token;
    try {
      await ref.read(pushRepositoryProvider).registerToken(token);
    } catch (_) {
      // Best-effort — a failed registration just means this device won't
      // get pushes until the next successful retry (e.g. next app open).
    }
  }

  void _showForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;
    if (title == null && body == null) return;

    rootMessengerKey.currentState?.showSnackBar(
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
      await ref.read(pushRepositoryProvider).removeToken(token);
    } catch (_) {
      // Best-effort.
    }
    _registeredToken = null;
  }
}
