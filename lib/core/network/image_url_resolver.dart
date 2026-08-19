import 'dio_client.dart';

/// Resolves a post's relative `imageUrl` (e.g. "/uploads/foo.jpg") from
/// the backend into an absolute URL the app can load with Image.network.
String resolveImageUrl(String imageUrl) {
  if (imageUrl.startsWith('http')) return imageUrl;
  return '$apiBaseUrl$imageUrl';
}
