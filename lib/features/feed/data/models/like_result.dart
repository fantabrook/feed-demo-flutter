import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_result.freezed.dart';
part 'like_result.g.dart';

@freezed
abstract class LikeResult with _$LikeResult {
  const factory LikeResult({
    required bool liked,
    required int likeCount,
  }) = _LikeResult;

  factory LikeResult.fromJson(Map<String, dynamic> json) => _$LikeResultFromJson(json);
}
