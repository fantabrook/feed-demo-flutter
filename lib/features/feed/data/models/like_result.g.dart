// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LikeResult _$LikeResultFromJson(Map<String, dynamic> json) => _LikeResult(
  liked: json['liked'] as bool,
  likeCount: (json['likeCount'] as num).toInt(),
);

Map<String, dynamic> _$LikeResultToJson(_LikeResult instance) =>
    <String, dynamic>{'liked': instance.liked, 'likeCount': instance.likeCount};
