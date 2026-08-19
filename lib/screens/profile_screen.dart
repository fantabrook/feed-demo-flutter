import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../services/push_service.dart';
import '../widgets/edit_post_sheet.dart';
import '../widgets/post_card.dart';

/// Profile tab — the signed-in user's own posts, plus account actions
/// (theme, sign out). Counterpart of `app/(tabs)/profile.tsx`.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        onRefresh: profile.load,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            _ProfileHeader(name: auth.user?.name ?? '', email: auth.user?.email ?? '', postCount: profile.posts.length),
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
                selected: {theme.mode},
                onSelectionChanged: (selection) => theme.setMode(selection.first),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Stop pushes for this account before dropping the
                  // session that authorizes removing the token.
                  await context.read<PushService>().unregister();
                  await auth.signOut();
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
            _buildPosts(profile, auth),
          ],
        ),
      ),
    );
  }

  Widget _buildPosts(ProfileProvider profile, AuthProvider auth) {
    if (profile.isLoading && profile.posts.isEmpty) {
      return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
    }
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
              currentUserId: auth.user?.id,
              onLike: () => profile.toggleLike(post),
              onDelete: () => profile.deletePost(post.id),
              onEdit: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => EditPostSheet(
                  post: post,
                  onSave: ({content, imageFile, removeImage = false}) async {
                    final ok = await profile.editPost(post.id, content: content, imageFile: imageFile, removeImage: removeImage);
                    return ok ? null : profile.error;
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
