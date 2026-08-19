// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
};
