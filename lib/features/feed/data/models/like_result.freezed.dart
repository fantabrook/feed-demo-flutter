// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LikeResult {

 bool get liked; int get likeCount;
/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeResultCopyWith<LikeResult> get copyWith => _$LikeResultCopyWithImpl<LikeResult>(this as LikeResult, _$identity);

  /// Serializes this LikeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeResult&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liked,likeCount);

@override
String toString() {
  return 'LikeResult(liked: $liked, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class $LikeResultCopyWith<$Res>  {
  factory $LikeResultCopyWith(LikeResult value, $Res Function(LikeResult) _then) = _$LikeResultCopyWithImpl;
@useResult
$Res call({
 bool liked, int likeCount
});




}
/// @nodoc
class _$LikeResultCopyWithImpl<$Res>
    implements $LikeResultCopyWith<$Res> {
  _$LikeResultCopyWithImpl(this._self, this._then);

  final LikeResult _self;
  final $Res Function(LikeResult) _then;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? liked = null,Object? likeCount = null,}) {
  return _then(LikeResult(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LikeResult].
extension LikeResultPatterns on LikeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikeResult value)  $default,){
final _that = this;
switch (_that) {
case _LikeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikeResult value)?  $default,){
final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool liked,  int likeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
return $default(_that.liked,_that.likeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool liked,  int likeCount)  $default,) {final _that = this;
switch (_that) {
case _LikeResult():
return $default(_that.liked,_that.likeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool liked,  int likeCount)?  $default,) {final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
return $default(_that.liked,_that.likeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikeResult implements LikeResult {
  const _LikeResult({required this.liked, required this.likeCount});
  factory _LikeResult.fromJson(Map<String, dynamic> json) => _$LikeResultFromJson(json);

@override final  bool liked;
@override final  int likeCount;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeResultCopyWith<_LikeResult> get copyWith => __$LikeResultCopyWithImpl<_LikeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikeResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikeResult&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liked,likeCount);

@override
String toString() {
  return 'LikeResult(liked: $liked, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class _$LikeResultCopyWith<$Res> implements $LikeResultCopyWith<$Res> {
  factory _$LikeResultCopyWith(_LikeResult value, $Res Function(_LikeResult) _then) = __$LikeResultCopyWithImpl;
@override @useResult
$Res call({
 bool liked, int likeCount
});




}
/// @nodoc
class __$LikeResultCopyWithImpl<$Res>
    implements _$LikeResultCopyWith<$Res> {
  __$LikeResultCopyWithImpl(this._self, this._then);

  final _LikeResult _self;
  final $Res Function(_LikeResult) _then;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? liked = null,Object? likeCount = null,}) {
  return _then(_LikeResult(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
