import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import '../models/app_notification.dart';
import 'notifications_repository.dart';

part 'notifications_repository_impl.g.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final res = await _dio.get('/notifications');
      return (res.data as List).map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<int> fetchUnreadCount() async {
    try {
      final res = await _dio.get('/notifications/unread-count');
      return (res.data as Map<String, dynamic>)['count'] as int;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _dio.post('/notifications/read-all');
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

@riverpod
NotificationsRepository notificationsRepository(Ref ref) => NotificationsRepositoryImpl(ref.watch(dioProvider));
