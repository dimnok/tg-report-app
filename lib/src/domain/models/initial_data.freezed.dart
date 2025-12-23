// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initial_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InitialData {

 String get userName;
/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialDataCopyWith<InitialData> get copyWith => _$InitialDataCopyWithImpl<InitialData>(this as InitialData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialData&&(identical(other.userName, userName) || other.userName == userName));
}


@override
int get hashCode => Object.hash(runtimeType,userName);

@override
String toString() {
  return 'InitialData(userName: $userName)';
}


}

/// @nodoc
abstract mixin class $InitialDataCopyWith<$Res>  {
  factory $InitialDataCopyWith(InitialData value, $Res Function(InitialData) _then) = _$InitialDataCopyWithImpl;
@useResult
$Res call({
 String userName
});




}
/// @nodoc
class _$InitialDataCopyWithImpl<$Res>
    implements $InitialDataCopyWith<$Res> {
  _$InitialDataCopyWithImpl(this._self, this._then);

  final InitialData _self;
  final $Res Function(InitialData) _then;

/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InitialData].
extension InitialDataPatterns on InitialData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthorizedData value)?  authorized,TResult Function( UnauthorizedData value)?  unauthorized,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthorizedData() when authorized != null:
return authorized(_that);case UnauthorizedData() when unauthorized != null:
return unauthorized(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthorizedData value)  authorized,required TResult Function( UnauthorizedData value)  unauthorized,}){
final _that = this;
switch (_that) {
case AuthorizedData():
return authorized(_that);case UnauthorizedData():
return unauthorized(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthorizedData value)?  authorized,TResult? Function( UnauthorizedData value)?  unauthorized,}){
final _that = this;
switch (_that) {
case AuthorizedData() when authorized != null:
return authorized(_that);case UnauthorizedData() when unauthorized != null:
return unauthorized(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<PositionModel> positions,  List<WorkObject> objects,  String userName,  String role)?  authorized,TResult Function( String userId,  String userName)?  unauthorized,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthorizedData() when authorized != null:
return authorized(_that.positions,_that.objects,_that.userName,_that.role);case UnauthorizedData() when unauthorized != null:
return unauthorized(_that.userId,_that.userName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<PositionModel> positions,  List<WorkObject> objects,  String userName,  String role)  authorized,required TResult Function( String userId,  String userName)  unauthorized,}) {final _that = this;
switch (_that) {
case AuthorizedData():
return authorized(_that.positions,_that.objects,_that.userName,_that.role);case UnauthorizedData():
return unauthorized(_that.userId,_that.userName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<PositionModel> positions,  List<WorkObject> objects,  String userName,  String role)?  authorized,TResult? Function( String userId,  String userName)?  unauthorized,}) {final _that = this;
switch (_that) {
case AuthorizedData() when authorized != null:
return authorized(_that.positions,_that.objects,_that.userName,_that.role);case UnauthorizedData() when unauthorized != null:
return unauthorized(_that.userId,_that.userName);case _:
  return null;

}
}

}

/// @nodoc


class AuthorizedData implements InitialData {
  const AuthorizedData({required final  List<PositionModel> positions, required final  List<WorkObject> objects, required this.userName, this.role = 'user'}): _positions = positions,_objects = objects;
  

 final  List<PositionModel> _positions;
 List<PositionModel> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}

 final  List<WorkObject> _objects;
 List<WorkObject> get objects {
  if (_objects is EqualUnmodifiableListView) return _objects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objects);
}

@override final  String userName;
@JsonKey() final  String role;

/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorizedDataCopyWith<AuthorizedData> get copyWith => _$AuthorizedDataCopyWithImpl<AuthorizedData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorizedData&&const DeepCollectionEquality().equals(other._positions, _positions)&&const DeepCollectionEquality().equals(other._objects, _objects)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_positions),const DeepCollectionEquality().hash(_objects),userName,role);

@override
String toString() {
  return 'InitialData.authorized(positions: $positions, objects: $objects, userName: $userName, role: $role)';
}


}

/// @nodoc
abstract mixin class $AuthorizedDataCopyWith<$Res> implements $InitialDataCopyWith<$Res> {
  factory $AuthorizedDataCopyWith(AuthorizedData value, $Res Function(AuthorizedData) _then) = _$AuthorizedDataCopyWithImpl;
@override @useResult
$Res call({
 List<PositionModel> positions, List<WorkObject> objects, String userName, String role
});




}
/// @nodoc
class _$AuthorizedDataCopyWithImpl<$Res>
    implements $AuthorizedDataCopyWith<$Res> {
  _$AuthorizedDataCopyWithImpl(this._self, this._then);

  final AuthorizedData _self;
  final $Res Function(AuthorizedData) _then;

/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? positions = null,Object? objects = null,Object? userName = null,Object? role = null,}) {
  return _then(AuthorizedData(
positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<PositionModel>,objects: null == objects ? _self._objects : objects // ignore: cast_nullable_to_non_nullable
as List<WorkObject>,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnauthorizedData implements InitialData {
  const UnauthorizedData({required this.userId, required this.userName});
  

 final  String userId;
@override final  String userName;

/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedDataCopyWith<UnauthorizedData> get copyWith => _$UnauthorizedDataCopyWithImpl<UnauthorizedData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedData&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName));
}


@override
int get hashCode => Object.hash(runtimeType,userId,userName);

@override
String toString() {
  return 'InitialData.unauthorized(userId: $userId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedDataCopyWith<$Res> implements $InitialDataCopyWith<$Res> {
  factory $UnauthorizedDataCopyWith(UnauthorizedData value, $Res Function(UnauthorizedData) _then) = _$UnauthorizedDataCopyWithImpl;
@override @useResult
$Res call({
 String userId, String userName
});




}
/// @nodoc
class _$UnauthorizedDataCopyWithImpl<$Res>
    implements $UnauthorizedDataCopyWith<$Res> {
  _$UnauthorizedDataCopyWithImpl(this._self, this._then);

  final UnauthorizedData _self;
  final $Res Function(UnauthorizedData) _then;

/// Create a copy of InitialData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? userName = null,}) {
  return _then(UnauthorizedData(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
