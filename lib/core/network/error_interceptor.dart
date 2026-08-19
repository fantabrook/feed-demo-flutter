import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Maps a failed response's body into an [ApiException] and stores it on
/// [DioException.error], replacing the old hand-rolled `_handle<T>()`
/// status/error parsing that used to live on every call site.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final message = (data is Map && data['error'] is String)
        ? data['error'] as String
        : 'Request failed (${err.response?.statusCode ?? '-'})';

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: ApiException(message),
      ),
    );
  }
}
