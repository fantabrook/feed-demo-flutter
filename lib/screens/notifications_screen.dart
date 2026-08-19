import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/notification.dart';
import '../providers/notifications_provider.dart';
import '../services/api_client.dart';

/// Notifications tab — list of "so-and-so liked your post" events, marked
/// read on open. Counterpart of `app/(tabs)/notifications.tsx` (the Expo
/// side additionally registers for push via Expo's push service, which
/// has no Flutter equivalent here — see the note on [NotificationsProvider]).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotificationsProvider>();
      provider.loadNotifications();
      provider.markAllRead();
    });
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
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: provider.loadNotifications,
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(NotificationsProvider provider) {
    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.error!),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: provider.loadNotifications, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (provider.notifications.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text("No notifications yet — likes on your posts will show up here.")),
        ],
      );
    }
    return ListView.separated(
      itemCount: provider.notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _NotificationTile(
        notification: provider.notifications[index],
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
                ApiClient.resolveImageUrl(notification.post!.imageUrl!),
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
