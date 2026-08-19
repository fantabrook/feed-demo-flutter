import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_demo_flutter/features/auth/presentation/providers/auth_notifier.dart';
import 'package:feed_demo_flutter/shared/providers/post_list_notifier.dart';
import 'package:feed_demo_flutter/shared/widgets/edit_post_sheet.dart';
import 'package:feed_demo_flutter/shared/widgets/post_card.dart';
import '../providers/feed_notifier.dart';
import '../widgets/compose_post_sheet.dart';

/// Main feed — lives inside the bottom-tab shell in `core/router/home_shell.dart`.
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  Future<void> _refresh(WidgetRef ref) {
    ref.invalidate(feedProvider);
    return ref.read(feedProvider.future);
  }

  void _openComposeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ComposePostSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authProvider).value?.id;
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: feedAsync.when(
          data: (feed) => _buildBody(context, ref, feed, userId),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildError(ref, error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openComposeSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$error'),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => _refresh(ref), child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PostListState feed, int? userId) {
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
          currentUserId: userId,
          onLike: () => ref.read(feedProvider.notifier).toggleLike(post),
          onDelete: () => ref.read(feedProvider.notifier).deletePost(post.id),
          onEdit: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => EditPostSheet(
              post: post,
              onSave: ({content, imageFile, removeImage = false}) async {
                final notifier = ref.read(feedProvider.notifier);
                final ok = await notifier.editPost(post.id, content: content, imageFile: imageFile, removeImage: removeImage);
                return ok ? null : ref.read(feedProvider).value?.error;
              },
            ),
          ),
        );
      },
    );
  }
}
