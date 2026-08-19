import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'token_storage.g.dart';

/// Persists the auth JWT across app restarts. Lives in `core/network`
/// (rather than the auth feature) because the Dio auth interceptor needs
/// access to it without creating an import cycle with `features/auth`.
class TokenStorage {
  static const _key = 'auth_token';

  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

@riverpod
TokenStorage tokenStorage(Ref ref) => TokenStorage();
