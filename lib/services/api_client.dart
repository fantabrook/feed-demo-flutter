import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/notification.dart';
import '../models/post.dart';
import '../models/user.dart';

/// Thin wrapper around the existing Node/Express backend
/// (`feed-demo-backend`, see its `src/routes/*.js`). Mirrors what
/// `lib/api.ts` does on the Expo side of this project.
class ApiClient {
  ApiClient({this.token});

  String? token;

  /// Android emulators can't reach the host machine via `localhost` — they
  /// need the special `10.0.2.2` alias. iOS simulator and desktop/web can
  /// use `localhost` directly since they share the host's network stack.
  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:4000';
    return 'http://localhost:4000';
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Builds the "image" multipart part for a post upload, sniffing the
  /// real MIME type from the file's bytes rather than trusting its
  /// extension. `image_picker`'s temp files (especially from the camera)
  /// don't always have an extension `package:mime` can resolve on its
  /// own, and an unresolved type falls back to `application/octet-stream`
  /// — which the backend's upload whitelist (see
  /// `feed-demo-backend/src/lib/upload.js`) then rejects outright.
  Future<http.MultipartFile> _imagePart(String field, File file) async {
    final bytes = await file.readAsBytes();
    final mimeType = lookupMimeType(file.path, headerBytes: bytes) ?? 'image/jpeg';
    final parts = mimeType.split('/');
    return http.MultipartFile.fromBytes(
      field,
      bytes,
      filename: file.uri.pathSegments.last,
      contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
    );
  }

  /// Resolves a post's relative `imageUrl` (e.g. "/uploads/foo.jpg") from
  /// the backend into an absolute URL the app can load with Image.network.
  static String resolveImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) return imageUrl;
    return '$baseUrl$imageUrl';
  }

  Future<T> _handle<T>(
    http.Response res,
    T Function(dynamic body) onOk,
  ) {
    final ok = res.statusCode >= 200 && res.statusCode < 300;
    dynamic body;
    try {
      body = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    } catch (_) {
      body = null;
    }
    if (!ok) {
      final message = (body is Map && body['error'] is String)
          ? body['error'] as String
          : 'Request failed (${res.statusCode})';
      return Future.error(ApiException(message));
    }
    return Future.value(onOk(body));
  }

  // --- Auth -----------------------------------------------------------

  Future<AuthResult> login(String email, String password) async {
    final res = await http.post(
      _uri('/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handle(res, (body) => AuthResult.fromJson(body as Map<String, dynamic>));
  }

  Future<AuthResult> register(String email, String password, String name) async {
    final res = await http.post(
      _uri('/auth/register'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    return _handle(res, (body) => AuthResult.fromJson(body as Map<String, dynamic>));
  }

  // --- Posts ------------------------------------------------------------

  Future<List<Post>> fetchFeed() async {
    final res = await http.get(_uri('/posts'), headers: _headers);
    return _handle(res, (body) => (body as List).map((e) => Post.fromJson(e)).toList());
  }

  Future<List<Post>> fetchMyPosts() async {
    final res = await http.get(_uri('/posts/mine'), headers: _headers);
    return _handle(res, (body) => (body as List).map((e) => Post.fromJson(e)).toList());
  }

  /// Creates a post. `imageFile` is optional — a post needs text and/or an image.
  Future<Post> createPost({String? content, File? imageFile}) async {
    final request = http.MultipartRequest('POST', _uri('/posts'));
    request.headers.addAll({if (token != null) 'Authorization': 'Bearer $token'});
    if (content != null && content.isNotEmpty) {
      request.fields['content'] = content;
    }
    if (imageFile != null) {
      request.files.add(await _imagePart('image', imageFile));
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _handle(res, (body) => Post.fromJson(body as Map<String, dynamic>));
  }

  /// Edits a post's text and/or image. `removeImage: true` drops the
  /// current image (ignored if `imageFile` is also given). Passing
  /// nothing for an argument leaves that field untouched server-side.
  Future<Post> editPost(
    int id, {
    String? content,
    File? imageFile,
    bool removeImage = false,
  }) async {
    final request = http.MultipartRequest('PATCH', _uri('/posts/$id'));
    request.headers.addAll({if (token != null) 'Authorization': 'Bearer $token'});
    if (content != null) {
      request.fields['content'] = content;
    }
    if (removeImage) {
      request.fields['removeImage'] = 'true';
    }
    if (imageFile != null) {
      request.files.add(await _imagePart('image', imageFile));
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _handle(res, (body) => Post.fromJson(body as Map<String, dynamic>));
  }

  Future<void> deletePost(int id) async {
    final res = await http.delete(_uri('/posts/$id'), headers: _headers);
    return _handle(res, (_) {});
  }

  Future<LikeResult> toggleLike(int postId) async {
    final res = await http.post(_uri('/posts/$postId/like'), headers: _headers);
    return _handle(res, (body) => LikeResult.fromJson(body as Map<String, dynamic>));
  }

  // --- Notifications ------------------------------------------------------

  Future<List<AppNotification>> fetchNotifications() async {
    final res = await http.get(_uri('/notifications'), headers: _headers);
    return _handle(res, (body) => (body as List).map((e) => AppNotification.fromJson(e)).toList());
  }

  Future<int> fetchUnreadCount() async {
    final res = await http.get(_uri('/notifications/unread-count'), headers: _headers);
    return _handle(res, (body) => (body as Map<String, dynamic>)['count'] as int);
  }

  Future<void> markAllNotificationsRead() async {
    final res = await http.post(_uri('/notifications/read-all'), headers: _headers);
    return _handle(res, (_) {});
  }

  // --- Push token -----------------------------------------------------

  /// Registers this device's FCM token so the backend's like/notification
  /// flow (see `feed-demo-backend/src/lib/push.js`) can reach it. Same
  /// endpoint the Expo app uses for its Expo push tokens — the backend
  /// tells them apart by token shape.
  Future<void> registerPushToken(String token) async {
    final res = await http.post(
      _uri('/users/push-token'),
      headers: _headers,
      body: jsonEncode({'token': token}),
    );
    return _handle(res, (_) {});
  }

  Future<void> removePushToken(String token) async {
    final res = await http.delete(
      _uri('/users/push-token'),
      headers: _headers,
      body: jsonEncode({'token': token}),
    );
    return _handle(res, (_) {});
  }
}

class AuthResult {
  final String token;
  final AppUser user;
  AuthResult({required this.token, required this.user});
  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        token: json['token'] as String,
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class LikeResult {
  final bool liked;
  final int likeCount;
  LikeResult({required this.liked, required this.likeCount});
  factory LikeResult.fromJson(Map<String, dynamic> json) => LikeResult(
        liked: json['liked'] as bool,
        likeCount: json['likeCount'] as int,
      );
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
