import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/features/auth/auth.dart';
import 'package:feed_demo_flutter/features/feed/feed.dart';
import 'package:feed_demo_flutter/features/notifications/notifications.dart';
import 'package:feed_demo_flutter/features/profile/profile.dart';

import 'home_shell.dart';
import 'route_names.dart';

part 'app_router.g.dart';

/// Bridges [AuthNotifier] state changes into a [Listenable] so GoRouter's
/// `redirect` re-evaluates whenever the signed-in/out state changes,
/// without rebuilding the whole [GoRouter] instance (which would lose
/// navigation state).
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final refresh = _AuthRefreshListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/sign-in',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final isSignedIn = auth.value != null;
      final onAuthPages = state.matchedLocation == '/sign-in' || state.matchedLocation == '/sign-up';

      if (auth.isLoading) return null;
      if (!isSignedIn && !onAuthPages) return '/sign-in';
      if (isSignedIn && onAuthPages) return '/feed';
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: RouteNames.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: RouteNames.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/feed', name: RouteNames.feed, builder: (context, state) => const FeedScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                name: RouteNames.notifications,
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', name: RouteNames.profile, builder: (context, state) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
}
