import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:feed_demo_flutter/core/network/api_exception.dart';
import 'package:feed_demo_flutter/core/network/dio_client.dart';
import 'package:feed_demo_flutter/core/network/token_storage.dart';
import 'package:feed_demo_flutter/shared/models/app_user.dart';
import '../models/auth_result.dart';
import 'auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._tokenStorage);

  static const _userKey = 'auth_user';

  final Dio _dio;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
      return AuthResult.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<AuthResult> register(String email, String password, String name) async {
    try {
      final res = await _dio.post('/auth/register', data: {'email': email, 'password': password, 'name': name});
      return AuthResult.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<AppUser?> restoreSession() async {
    final token = await _tokenStorage.read();
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return null;
    return AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  @override
  Future<void> persistSession(AuthResult result) async {
    await _tokenStorage.save(result.token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(result.user.toJson()));
  }

  @override
  Future<void> clearSession() async {
    await _tokenStorage.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(ref.watch(dioProvider), ref.watch(tokenStorageProvider));
