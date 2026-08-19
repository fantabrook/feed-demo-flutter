import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:feed_demo_flutter/shared/models/app_user.dart';

part 'auth_result.freezed.dart';
part 'auth_result.g.dart';

@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
    required AppUser user,
  }) = _AuthResult;

  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);
}
