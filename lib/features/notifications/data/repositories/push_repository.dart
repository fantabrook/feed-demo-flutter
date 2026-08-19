/// Registers this device's FCM token so the backend's like/notification
/// flow can reach it.
abstract class PushRepository {
  Future<void> registerToken(String token);
  Future<void> removeToken(String token);
}
