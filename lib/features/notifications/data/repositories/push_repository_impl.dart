import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import 'push_repository.dart';

part 'push_repository_impl.g.dart';

class PushRepositoryImpl implements PushRepository {
  PushRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> registerToken(String token) async {
    try {
      await _dio.post('/users/push-token', data: {'token': token});
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> removeToken(String token) async {
    try {
      await _dio.delete('/users/push-token', data: {'token': token});
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
PushRepository pushRepository(Ref ref) => PushRepositoryImpl(ref.watch(dioProvider));
