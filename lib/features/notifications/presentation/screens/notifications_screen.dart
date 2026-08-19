import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:feed_demo_flutter/core/network/image_url_resolver.dart';
import '../../data/models/app_notification.dart';
import '../providers/notifications_notifier.dart';

/// Notifications tab — list of "so-and-so liked your post" events, marked
/// read on open.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).markAllRead();
    });
  }

  Future<void> _refresh() {
    ref.invalidate(notificationsProvider);
    return ref.read(notificationsProvider.future);
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.yMMMd().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: notificationsAsync.when(
          data: (state) => _buildBody(state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error'),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _refresh, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NotificationsState state) {
    if (state.notifications.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text("No notifications yet — likes on your posts will show up here.")),
        ],
      );
    }
    return ListView.separated(
      itemCount: state.notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _NotificationTile(
        notification: state.notifications[index],
        relativeTime: _relativeTime,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.relativeTime});

  final AppNotification notification;
  final String Function(DateTime) relativeTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(notification.actor.name.isNotEmpty ? notification.actor.name[0].toUpperCase() : '?'),
      ),
      title: Text(notification.message),
      subtitle: Text(relativeTime(notification.createdAt)),
      trailing: notification.post?.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                resolveImageUrl(notification.post!.imageUrl!),
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            )
          : null,
      tileColor: notification.read ? null : Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
    );
  }
}
