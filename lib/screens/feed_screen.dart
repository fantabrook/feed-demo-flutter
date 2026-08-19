import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/compose_post_sheet.dart';
import '../widgets/edit_post_sheet.dart';
import '../widgets/post_card.dart';

/// Main feed — the Flutter counterpart of `app/(tabs)/index.tsx`.
/// Lives inside the bottom-tab shell in `home_shell.dart`.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().load();
    });
  }

  void _openComposeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<FeedProvider>(),
        child: const ComposePostSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final feed = context.watch<FeedProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: RefreshIndicator(
        onRefresh: feed.load,
        child: _buildBody(feed, auth),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openComposeSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(FeedProvider feed, AuthProvider auth) {
    if (feed.isLoading && feed.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (feed.error != null && feed.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(feed.error!),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: feed.load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (feed.posts.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No posts yet — be the first to share something!')),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: feed.posts.length,
      itemBuilder: (context, index) {
        final post = feed.posts[index];
        return PostCard(
          post: post,
          currentUserId: auth.user?.id,
          onLike: () => feed.toggleLike(post),
          onDelete: () => feed.deletePost(post.id),
          onEdit: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => EditPostSheet(
              post: post,
              onSave: ({content, imageFile, removeImage = false}) async {
                final ok = await feed.editPost(post.id, content: content, imageFile: imageFile, removeImage: removeImage);
                return ok ? null : feed.error;
              },
            ),
          ),
        );
      },
    );
  }
}
