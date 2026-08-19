import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_shell.dart';
import 'screens/sign_in_screen.dart';
import 'services/push_service.dart';

/// Used by [PushService] to surface foreground push messages as a
/// SnackBar from outside the widget tree.
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FeedDemoApp());
}

class FeedDemoApp extends StatelessWidget {
  const FeedDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) {
          final theme = context.watch<ThemeProvider>();
          return MaterialApp(
            title: 'feed-demo (Flutter)',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: rootMessengerKey,
            themeMode: theme.mode,
            theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
            darkTheme: ThemeData(colorSchemeSeed: Colors.blue, brightness: Brightness.dark, useMaterial3: true),
            home: const _RootGate(),
          );
        },
      ),
    );
  }
}

/// Watches auth status and swaps between sign-in and the tabbed home
/// shell — the Flutter equivalent of the redirect logic in `app/_layout.tsx`.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.signedOut:
        return const SignInScreen();
      case AuthStatus.signedIn:
        return MultiProvider(
          // Recreated whenever we sign in, so a stale session's data never
          // leaks into a new one.
          key: ValueKey(auth.user?.id),
          providers: [
            ChangeNotifierProvider(create: (_) => FeedProvider(auth.api)),
            ChangeNotifierProvider(create: (_) => ProfileProvider(auth.api)),
            ChangeNotifierProvider(create: (_) => NotificationsProvider(auth.api)),
            Provider(create: (_) => PushService(auth.api, rootMessengerKey)),
          ],
          child: const _PushInitGate(child: HomeShell()),
        );
    }
  }
}

/// Kicks off FCM registration once, right after signing in.
class _PushInitGate extends StatefulWidget {
  const _PushInitGate({required this.child});

  final Widget child;

  @override
  State<_PushInitGate> createState() => _PushInitGateState();
}

class _PushInitGateState extends State<_PushInitGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PushService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
