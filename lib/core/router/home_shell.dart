import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:feed_demo_flutter/features/notifications/presentation/providers/notifications_notifier.dart';

/// Bottom-tab shell shown once signed in — Feed / Notifications / Profile.
/// Hosts the [StatefulShellRoute] branches configured in `app_router.dart`.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationsProvider).value?.unreadCount ?? 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), selectedIcon: Icon(Icons.dynamic_feed), label: 'Feed'),
          NavigationDestination(
            icon: Badge(
              label: Text('$unreadCount'),
              isLabelVisible: unreadCount > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              label: Text('$unreadCount'),
              isLabelVisible: unreadCount > 0,
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
