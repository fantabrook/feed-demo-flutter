import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Builds the "image" multipart part for a post upload, sniffing the real
/// MIME type from the file's bytes rather than trusting its extension.
/// `image_picker`'s temp files (especially from the camera) don't always
/// have an extension `package:mime` can resolve on its own, and an
/// unresolved type falls back to `application/octet-stream` — which the
/// backend's upload whitelist then rejects outright.
Future<MultipartFile> imageMultipartFile(File file) async {
  final bytes = await file.readAsBytes();
  final mimeType = lookupMimeType(file.path, headerBytes: bytes) ?? 'image/jpeg';
  final parts = mimeType.split('/');
  return MultipartFile.fromBytes(
    bytes,
    filename: file.uri.pathSegments.last,
    contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
  );
}
