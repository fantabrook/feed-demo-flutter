import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_demo_flutter/features/auth/presentation/providers/auth_notifier.dart';
import 'package:feed_demo_flutter/features/notifications/presentation/providers/push_notifier.dart';

import 'messenger_key.dart';
import 'router/app_router.dart';
import 'theme/theme_notifier.dart';

class FeedDemoApp extends ConsumerStatefulWidget {
  const FeedDemoApp({super.key});

  @override
  ConsumerState<FeedDemoApp> createState() => _FeedDemoAppState();
}

class _FeedDemoAppState extends ConsumerState<FeedDemoApp> {
  bool _pushInitialized = false;

  @override
  Widget build(BuildContext context) {
    // Kicks off FCM registration once, right after signing in — the
    // Riverpod equivalent of the old `_PushInitGate` post-frame callback.
    ref.listen(authProvider, (previous, next) {
      final signedIn = next.value != null;
      if (signedIn && !_pushInitialized) {
        _pushInitialized = true;
        ref.read(pushProvider.notifier).initialize();
      } else if (!signedIn) {
        _pushInitialized = false;
      }
    });

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'feed-demo (Flutter)',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootMessengerKey,
      themeMode: themeMode,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.dark, useMaterial3: true),
      routerConfig: router,
    );
  }
}
