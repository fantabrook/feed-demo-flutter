import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post.dart';
import '../services/api_client.dart';

/// Bottom sheet for editing an existing post — text and/or swapping or
/// removing its image. Takes an `onSave` callback rather than reading a
/// provider directly, so it works unmodified from both the feed and the
/// profile screen (whichever [PostListProvider] subclass owns the post).
/// Mirrors the edit flow in `PostCard.tsx` on the Expo side.
class EditPostSheet extends StatefulWidget {
  const EditPostSheet({super.key, required this.post, required this.onSave});

  final Post post;

  /// Returns null on success, or an error message to display.
  final Future<String?> Function({String? content, File? imageFile, bool removeImage}) onSave;

  @override
  State<EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends State<EditPostSheet> {
  late final _controller = TextEditingController(text: widget.post.content ?? '');
  File? _newImage;
  bool _removeExistingImage = false;
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasImage => _newImage != null || (!_removeExistingImage && widget.post.imageUrl != null);

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1600, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _newImage = File(picked.path);
        _removeExistingImage = false;
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty && !_hasImage) {
      setState(() => _error = 'content or an image is required');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final errorMessage = await widget.onSave(
      content: content,
      imageFile: _newImage,
      removeImage: _removeExistingImage,
    );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _error = errorMessage;
    });
    if (errorMessage == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit post', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            maxLength: 1000,
            decoration: const InputDecoration(hintText: "What's on your mind?", border: OutlineInputBorder()),
          ),
          if (_hasImage) ...[
            const SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _newImage != null
                      ? Image.file(_newImage!, height: 160, width: double.infinity, fit: BoxFit.cover)
                      : Image.network(
                          ApiClient.resolveImageUrl(widget.post.imageUrl!),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: () => setState(() {
                      _newImage = null;
                      _removeExistingImage = true;
                    }),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: _showImageSourceSheet,
                icon: const Icon(Icons.image_outlined),
                label: Text(_hasImage ? 'Change photo' : 'Add photo'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
