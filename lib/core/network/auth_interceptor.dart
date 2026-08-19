import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Injects the `Authorization: Bearer <token>` header on outgoing
/// requests, replacing the old hand-rolled `_headers` getter.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _tokenStorage
        .read()
        .then((token) {
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        })
        .catchError((Object _, StackTrace _) {
          // A failed token read shouldn't hang the request forever — send
          // it unauthenticated and let the backend's normal 401 handling
          // (and the error interceptor) take it from there.
          handler.next(options);
        });
  }
}
