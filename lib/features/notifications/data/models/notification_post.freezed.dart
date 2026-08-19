// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPost {

 int get id; String? get content; String? get imageUrl;
/// Create a copy of NotificationPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPostCopyWith<NotificationPost> get copyWith => _$NotificationPostCopyWithImpl<NotificationPost>(this as NotificationPost, _$identity);

  /// Serializes this NotificationPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,imageUrl);

@override
String toString() {
  return 'NotificationPost(id: $id, content: $content, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $NotificationPostCopyWith<$Res>  {
  factory $NotificationPostCopyWith(NotificationPost value, $Res Function(NotificationPost) _then) = _$NotificationPostCopyWithImpl;
@useResult
$Res call({
 int id, String? content, String? imageUrl
});




}
/// @nodoc
class _$NotificationPostCopyWithImpl<$Res>
    implements $NotificationPostCopyWith<$Res> {
  _$NotificationPostCopyWithImpl(this._self, this._then);

  final NotificationPost _self;
  final $Res Function(NotificationPost) _then;

/// Create a copy of NotificationPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = freezed,Object? imageUrl = freezed,}) {
  return _then(NotificationPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPost].
extension NotificationPostPatterns on NotificationPost {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPost() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPost value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPost():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPost value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPost() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? content,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPost() when $default != null:
return $default(_that.id,_that.content,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? content,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _NotificationPost():
return $default(_that.id,_that.content,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? content,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPost() when $default != null:
return $default(_that.id,_that.content,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPost implements NotificationPost {
  const _NotificationPost({required this.id, this.content, this.imageUrl});
  factory _NotificationPost.fromJson(Map<String, dynamic> json) => _$NotificationPostFromJson(json);

@override final  int id;
@override final  String? content;
@override final  String? imageUrl;

/// Create a copy of NotificationPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPostCopyWith<_NotificationPost> get copyWith => __$NotificationPostCopyWithImpl<_NotificationPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,imageUrl);

@override
String toString() {
  return 'NotificationPost(id: $id, content: $content, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$NotificationPostCopyWith<$Res> implements $NotificationPostCopyWith<$Res> {
  factory _$NotificationPostCopyWith(_NotificationPost value, $Res Function(_NotificationPost) _then) = __$NotificationPostCopyWithImpl;
@override @useResult
$Res call({
 int id, String? content, String? imageUrl
});




}
/// @nodoc
class __$NotificationPostCopyWithImpl<$Res>
    implements _$NotificationPostCopyWith<$Res> {
  __$NotificationPostCopyWithImpl(this._self, this._then);

  final _NotificationPost _self;
  final $Res Function(_NotificationPost) _then;

/// Create a copy of NotificationPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = freezed,Object? imageUrl = freezed,}) {
  return _then(_NotificationPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
