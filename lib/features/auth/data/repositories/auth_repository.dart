import 'package:feed_demo_flutter/shared/models/app_user.dart';
import '../models/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(String email, String password, String name);

  /// Reads the persisted session (token + cached user profile), if any.
  /// The backend has no "who am I" endpoint, so the user profile is
  /// cached locally alongside the token rather than re-fetched on restore.
  Future<AppUser?> restoreSession();

  Future<void> persistSession(AuthResult result);
  Future<void> clearSession();
}
