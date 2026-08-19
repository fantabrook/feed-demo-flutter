import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/api_client.dart';

enum AuthStatus { unknown, signedOut, signedIn }

/// Holds the signed-in session and persists the JWT + user profile across
/// app restarts — the Flutter equivalent of `context/ctx.tsx` on the Expo
/// side. The backend has no "who am I" endpoint (see
/// `feed-demo-backend/src/routes/auth.js`), so the user profile is cached
/// locally alongside the token rather than re-fetched on restore.
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _restoreSession();
  }

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final ApiClient api = ApiClient();
  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  String? error;
  bool isLoading = false;

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) {
      status = AuthStatus.signedOut;
      notifyListeners();
      return;
    }
    api.token = token;
    user = AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    status = AuthStatus.signedIn;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) => _submit(
        () => api.login(email, password),
      );

  Future<bool> signUp(String email, String password, String name) => _submit(
        () => api.register(email, password, name),
      );

  Future<bool> _submit(Future<AuthResult> Function() action) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final result = await action();
      api.token = result.token;
      user = result.user;
      status = AuthStatus.signedIn;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, result.token);
      await prefs.setString(_userKey, jsonEncode(result.user.toJson()));

      return true;
    } catch (e) {
      error = e is ApiException ? e.message : 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    api.token = null;
    user = null;
    status = AuthStatus.signedOut;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    notifyListeners();
  }
}
