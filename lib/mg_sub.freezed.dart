// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mg_sub.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubState<TSuccess> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubState<TSuccess>);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $SubStateCopyWith<TSuccess,$Res>  {
$SubStateCopyWith(SubState<TSuccess> _, $Res Function(SubState<TSuccess>) __);
}


/// Adds pattern-matching-related methods to [SubState].
extension SubStatePatterns<TSuccess> on SubState<TSuccess> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _SubInitial<TSuccess> value)?  initial,TResult Function( _SubLoading<TSuccess> value)?  loading,TResult Function( _SubSuccess<TSuccess> value)?  success,TResult Function( _SubFailure<TSuccess> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubInitial() when initial != null:
return initial(_that);case _SubLoading() when loading != null:
return loading(_that);case _SubSuccess() when success != null:
return success(_that);case _SubFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _SubInitial<TSuccess> value)  initial,required TResult Function( _SubLoading<TSuccess> value)  loading,required TResult Function( _SubSuccess<TSuccess> value)  success,required TResult Function( _SubFailure<TSuccess> value)  failure,}){
final _that = this;
switch (_that) {
case _SubInitial():
return initial(_that);case _SubLoading():
return loading(_that);case _SubSuccess():
return success(_that);case _SubFailure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _SubInitial<TSuccess> value)?  initial,TResult? Function( _SubLoading<TSuccess> value)?  loading,TResult? Function( _SubSuccess<TSuccess> value)?  success,TResult? Function( _SubFailure<TSuccess> value)?  failure,}){
final _that = this;
switch (_that) {
case _SubInitial() when initial != null:
return initial(_that);case _SubLoading() when loading != null:
return loading(_that);case _SubSuccess() when success != null:
return success(_that);case _SubFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TSuccess data)?  success,TResult Function( String error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubInitial() when initial != null:
return initial();case _SubLoading() when loading != null:
return loading();case _SubSuccess() when success != null:
return success(_that.data);case _SubFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TSuccess data)  success,required TResult Function( String error)  failure,}) {final _that = this;
switch (_that) {
case _SubInitial():
return initial();case _SubLoading():
return loading();case _SubSuccess():
return success(_that.data);case _SubFailure():
return failure(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TSuccess data)?  success,TResult? Function( String error)?  failure,}) {final _that = this;
switch (_that) {
case _SubInitial() when initial != null:
return initial();case _SubLoading() when loading != null:
return loading();case _SubSuccess() when success != null:
return success(_that.data);case _SubFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SubInitial<TSuccess> extends SubState<TSuccess> {
  const _SubInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubInitial<TSuccess>);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class _SubLoading<TSuccess> extends SubState<TSuccess> {
  const _SubLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubLoading<TSuccess>);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class _SubSuccess<TSuccess> extends SubState<TSuccess> {
  const _SubSuccess(this.data): super._();
  

 final  TSuccess data;

/// Create a copy of SubState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubSuccessCopyWith<TSuccess, _SubSuccess<TSuccess>> get copyWith => __$SubSuccessCopyWithImpl<TSuccess, _SubSuccess<TSuccess>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubSuccess<TSuccess>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));



}

/// @nodoc
abstract mixin class _$SubSuccessCopyWith<TSuccess,$Res> implements $SubStateCopyWith<TSuccess, $Res> {
  factory _$SubSuccessCopyWith(_SubSuccess<TSuccess> value, $Res Function(_SubSuccess<TSuccess>) _then) = __$SubSuccessCopyWithImpl;
@useResult
$Res call({
 TSuccess data
});




}
/// @nodoc
class __$SubSuccessCopyWithImpl<TSuccess,$Res>
    implements _$SubSuccessCopyWith<TSuccess, $Res> {
  __$SubSuccessCopyWithImpl(this._self, this._then);

  final _SubSuccess<TSuccess> _self;
  final $Res Function(_SubSuccess<TSuccess>) _then;

/// Create a copy of SubState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_SubSuccess<TSuccess>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TSuccess,
  ));
}


}

/// @nodoc


class _SubFailure<TSuccess> extends SubState<TSuccess> {
  const _SubFailure(this.error): super._();
  

 final  String error;

/// Create a copy of SubState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubFailureCopyWith<TSuccess, _SubFailure<TSuccess>> get copyWith => __$SubFailureCopyWithImpl<TSuccess, _SubFailure<TSuccess>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubFailure<TSuccess>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);



}

/// @nodoc
abstract mixin class _$SubFailureCopyWith<TSuccess,$Res> implements $SubStateCopyWith<TSuccess, $Res> {
  factory _$SubFailureCopyWith(_SubFailure<TSuccess> value, $Res Function(_SubFailure<TSuccess>) _then) = __$SubFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$SubFailureCopyWithImpl<TSuccess,$Res>
    implements _$SubFailureCopyWith<TSuccess, $Res> {
  __$SubFailureCopyWithImpl(this._self, this._then);

  final _SubFailure<TSuccess> _self;
  final $Res Function(_SubFailure<TSuccess>) _then;

/// Create a copy of SubState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_SubFailure<TSuccess>(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
