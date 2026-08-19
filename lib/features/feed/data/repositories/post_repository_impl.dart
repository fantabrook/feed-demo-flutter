import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import 'package:feed_demo_flutter/core/network/multipart_helpers.dart';
import '../models/like_result.dart';
import '../models/post.dart';
import 'post_repository.dart';

part 'post_repository_impl.g.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<LikeResult> toggleLike(int postId) async {
    try {
      final res = await _dio.post('/posts/$postId/like');
      return LikeResult.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Post> editPost(int id, {String? content, File? imageFile, bool removeImage = false}) async {
    try {
      final form = FormData.fromMap({
        'content': ?content,
        if (removeImage) 'removeImage': 'true',
        if (imageFile != null) 'image': await imageMultipartFile(imageFile),
      });
      final res = await _dio.patch('/posts/$id', data: form);
      return Post.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await _dio.delete('/posts/$id');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
PostRepository postRepository(Ref ref) => PostRepositoryImpl(ref.watch(dioProvider));
