// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductionItem {

/// ID позиции.
 String get id;/// Наименование позиции.
 String get name;/// Единица измерения.
 String get unit;/// Суммарное количество за все время.
 double get total;
/// Create a copy of ProductionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionItemCopyWith<ProductionItem> get copyWith => _$ProductionItemCopyWithImpl<ProductionItem>(this as ProductionItem, _$identity);

  /// Serializes this ProductionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,total);

@override
String toString() {
  return 'ProductionItem(id: $id, name: $name, unit: $unit, total: $total)';
}


}

/// @nodoc
abstract mixin class $ProductionItemCopyWith<$Res>  {
  factory $ProductionItemCopyWith(ProductionItem value, $Res Function(ProductionItem) _then) = _$ProductionItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit, double total
});




}
/// @nodoc
class _$ProductionItemCopyWithImpl<$Res>
    implements $ProductionItemCopyWith<$Res> {
  _$ProductionItemCopyWithImpl(this._self, this._then);

  final ProductionItem _self;
  final $Res Function(ProductionItem) _then;

/// Create a copy of ProductionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? total = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionItem].
extension ProductionItemPatterns on ProductionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionItem value)  $default,){
final _that = this;
switch (_that) {
case _ProductionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionItem value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionItem() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  double total)  $default,) {final _that = this;
switch (_that) {
case _ProductionItem():
return $default(_that.id,_that.name,_that.unit,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit,  double total)?  $default,) {final _that = this;
switch (_that) {
case _ProductionItem() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionItem implements ProductionItem {
  const _ProductionItem({required this.id, required this.name, required this.unit, required this.total});
  factory _ProductionItem.fromJson(Map<String, dynamic> json) => _$ProductionItemFromJson(json);

/// ID позиции.
@override final  String id;
/// Наименование позиции.
@override final  String name;
/// Единица измерения.
@override final  String unit;
/// Суммарное количество за все время.
@override final  double total;

/// Create a copy of ProductionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionItemCopyWith<_ProductionItem> get copyWith => __$ProductionItemCopyWithImpl<_ProductionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,total);

@override
String toString() {
  return 'ProductionItem(id: $id, name: $name, unit: $unit, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ProductionItemCopyWith<$Res> implements $ProductionItemCopyWith<$Res> {
  factory _$ProductionItemCopyWith(_ProductionItem value, $Res Function(_ProductionItem) _then) = __$ProductionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit, double total
});




}
/// @nodoc
class __$ProductionItemCopyWithImpl<$Res>
    implements _$ProductionItemCopyWith<$Res> {
  __$ProductionItemCopyWithImpl(this._self, this._then);

  final _ProductionItem _self;
  final $Res Function(_ProductionItem) _then;

/// Create a copy of ProductionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? total = null,}) {
  return _then(_ProductionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
