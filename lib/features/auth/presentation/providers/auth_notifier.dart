import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:feed_demo_flutter/shared/models/app_user.dart';
import '../../data/models/auth_result.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_notifier.g.dart';

/// Signed-in session: `null` data = signed out, non-null = signed in.
/// Loading = still restoring the persisted session on app start, or a
/// sign-in/sign-up submission in flight.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AppUser?> build() => ref.watch(authRepositoryProvider).restoreSession();

  Future<bool> signIn(String email, String password) =>
      _submit(() => ref.read(authRepositoryProvider).login(email, password));

  Future<bool> signUp(String email, String password, String name) =>
      _submit(() => ref.read(authRepositoryProvider).register(email, password, name));

  Future<bool> _submit(Future<AuthResult> Function() action) async {
    state = const AsyncLoading<AppUser?>();
    final repo = ref.read(authRepositoryProvider);
    try {
      final result = await action();
      await repo.persistSession(result);
      state = AsyncData(result.user);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).clearSession();
    state = const AsyncData(null);
  }
}
