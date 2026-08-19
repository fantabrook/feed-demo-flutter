import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_demo_flutter/core/theme/theme_notifier.dart';
import 'package:feed_demo_flutter/features/auth/presentation/providers/auth_notifier.dart';
import 'package:feed_demo_flutter/features/notifications/presentation/providers/push_notifier.dart';
import 'package:feed_demo_flutter/shared/models/app_user.dart';
import 'package:feed_demo_flutter/shared/providers/post_list_notifier.dart';
import 'package:feed_demo_flutter/shared/widgets/edit_post_sheet.dart';
import 'package:feed_demo_flutter/shared/widgets/post_card.dart';
import '../providers/profile_notifier.dart';

/// Profile tab — the signed-in user's own posts, plus account actions
/// (theme, sign out).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _refresh(WidgetRef ref) {
    ref.invalidate(profileProvider);
    return ref.read(profileProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final profileAsync = ref.watch(profileProvider);
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: profileAsync.when(
          data: (profile) => _buildContent(context, ref, profile, auth, themeMode),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, PostListState profile, AppUser? auth, ThemeMode themeMode) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _ProfileHeader(name: auth?.name ?? '', email: auth?.email ?? '', postCount: profile.posts.length),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Appearance', style: Theme.of(context).textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
              ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) => ref.read(themeProvider.notifier).setMode(selection.first),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () async {
              // Stop pushes for this account before dropping the session
              // that authorizes removing the token.
              await ref.read(pushProvider.notifier).unregister();
              await ref.read(authProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ),
        const Divider(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('My posts', style: Theme.of(context).textTheme.titleSmall),
        ),
        const SizedBox(height: 8),
        _buildPosts(context, ref, profile, auth),
      ],
    );
  }

  Widget _buildPosts(BuildContext context, WidgetRef ref, PostListState profile, AppUser? auth) {
    if (profile.posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text("You haven't posted anything yet.")),
      );
    }
    return Column(
      children: profile.posts
          .map(
            (post) => PostCard(
              post: post,
              currentUserId: auth?.id,
              onLike: () => ref.read(profileProvider.notifier).toggleLike(post),
              onDelete: () => ref.read(profileProvider.notifier).deletePost(post.id),
              onEdit: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => EditPostSheet(
                  post: post,
                  onSave: ({content, imageFile, removeImage = false}) async {
                    final notifier = ref.read(profileProvider.notifier);
                    final ok = await notifier.editPost(post.id, content: content, imageFile: imageFile, removeImage: removeImage);
                    return ok ? null : ref.read(profileProvider).value?.error;
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email, required this.postCount});

  final String name;
  final String email;
  final int postCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(email, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('$postCount post${postCount == 1 ? '' : 's'}', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
