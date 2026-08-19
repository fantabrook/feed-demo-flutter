import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'token_storage.dart';

part 'dio_client.g.dart';

/// Android emulators can't reach the host machine via `localhost` — they
/// need the special `10.0.2.2` alias. iOS simulator and desktop/web can
/// use `localhost` directly since they share the host's network stack.
String get apiBaseUrl {
  if (Platform.isAndroid) return 'http://10.0.2.2:4000';
  return 'http://localhost:4000';
}

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
  dio.interceptors.add(AuthInterceptor(ref.watch(tokenStorageProvider)));
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
