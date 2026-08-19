import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import 'package:feed_demo_flutter/features/feed/data/models/post.dart';
import 'profile_repository.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Post>> fetchMyPosts() async {
    try {
      final res = await _dio.get('/posts/mine');
      return (res.data as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) => ProfileRepositoryImpl(ref.watch(dioProvider));
