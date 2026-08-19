import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Maps a failed [DioException] into the app's [ApiException] type, so
/// every repository gets consistent error messages without re-parsing the
/// response body at each call site.
ApiException mapDioError(DioException e) {
  return e.error is ApiException
      ? e.error as ApiException
      : ApiException('Something went wrong. Please try again.');
}
