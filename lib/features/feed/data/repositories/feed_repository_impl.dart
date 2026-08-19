import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import 'package:feed_demo_flutter/core/network/multipart_helpers.dart';
import '../models/post.dart';
import 'feed_repository.dart';

part 'feed_repository_impl.g.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Post>> fetchFeed() async {
    try {
      final res = await _dio.get('/posts');
      return (res.data as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Post> createPost({String? content, File? imageFile}) async {
    try {
      final form = FormData.fromMap({
        if (content != null && content.isNotEmpty) 'content': content,
        if (imageFile != null) 'image': await imageMultipartFile(imageFile),
      });
      final res = await _dio.post('/posts', data: form);
      return Post.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
FeedRepository feedRepository(Ref ref) => FeedRepositoryImpl(ref.watch(dioProvider));
