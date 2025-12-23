// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'economy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EconomyItem {

/// Дата записи.
 String get date;/// Общая сумма (выручка).
 double get totalAmount;/// Сумма подрядчика (себестоимость).
 double get contractorAmount;/// Прибыль (выручка - себестоимость).
 double get profit;
/// Create a copy of EconomyItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EconomyItemCopyWith<EconomyItem> get copyWith => _$EconomyItemCopyWithImpl<EconomyItem>(this as EconomyItem, _$identity);

  /// Serializes this EconomyItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EconomyItem&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.contractorAmount, contractorAmount) || other.contractorAmount == contractorAmount)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalAmount,contractorAmount,profit);

@override
String toString() {
  return 'EconomyItem(date: $date, totalAmount: $totalAmount, contractorAmount: $contractorAmount, profit: $profit)';
}


}

/// @nodoc
abstract mixin class $EconomyItemCopyWith<$Res>  {
  factory $EconomyItemCopyWith(EconomyItem value, $Res Function(EconomyItem) _then) = _$EconomyItemCopyWithImpl;
@useResult
$Res call({
 String date, double totalAmount, double contractorAmount, double profit
});




}
/// @nodoc
class _$EconomyItemCopyWithImpl<$Res>
    implements $EconomyItemCopyWith<$Res> {
  _$EconomyItemCopyWithImpl(this._self, this._then);

  final EconomyItem _self;
  final $Res Function(EconomyItem) _then;

/// Create a copy of EconomyItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalAmount = null,Object? contractorAmount = null,Object? profit = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,contractorAmount: null == contractorAmount ? _self.contractorAmount : contractorAmount // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [EconomyItem].
extension EconomyItemPatterns on EconomyItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EconomyItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EconomyItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EconomyItem value)  $default,){
final _that = this;
switch (_that) {
case _EconomyItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EconomyItem value)?  $default,){
final _that = this;
switch (_that) {
case _EconomyItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  double totalAmount,  double contractorAmount,  double profit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EconomyItem() when $default != null:
return $default(_that.date,_that.totalAmount,_that.contractorAmount,_that.profit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  double totalAmount,  double contractorAmount,  double profit)  $default,) {final _that = this;
switch (_that) {
case _EconomyItem():
return $default(_that.date,_that.totalAmount,_that.contractorAmount,_that.profit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  double totalAmount,  double contractorAmount,  double profit)?  $default,) {final _that = this;
switch (_that) {
case _EconomyItem() when $default != null:
return $default(_that.date,_that.totalAmount,_that.contractorAmount,_that.profit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EconomyItem implements EconomyItem {
  const _EconomyItem({required this.date, required this.totalAmount, required this.contractorAmount, required this.profit});
  factory _EconomyItem.fromJson(Map<String, dynamic> json) => _$EconomyItemFromJson(json);

/// Дата записи.
@override final  String date;
/// Общая сумма (выручка).
@override final  double totalAmount;
/// Сумма подрядчика (себестоимость).
@override final  double contractorAmount;
/// Прибыль (выручка - себестоимость).
@override final  double profit;

/// Create a copy of EconomyItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EconomyItemCopyWith<_EconomyItem> get copyWith => __$EconomyItemCopyWithImpl<_EconomyItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EconomyItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EconomyItem&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.contractorAmount, contractorAmount) || other.contractorAmount == contractorAmount)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalAmount,contractorAmount,profit);

@override
String toString() {
  return 'EconomyItem(date: $date, totalAmount: $totalAmount, contractorAmount: $contractorAmount, profit: $profit)';
}


}

/// @nodoc
abstract mixin class _$EconomyItemCopyWith<$Res> implements $EconomyItemCopyWith<$Res> {
  factory _$EconomyItemCopyWith(_EconomyItem value, $Res Function(_EconomyItem) _then) = __$EconomyItemCopyWithImpl;
@override @useResult
$Res call({
 String date, double totalAmount, double contractorAmount, double profit
});




}
/// @nodoc
class __$EconomyItemCopyWithImpl<$Res>
    implements _$EconomyItemCopyWith<$Res> {
  __$EconomyItemCopyWithImpl(this._self, this._then);

  final _EconomyItem _self;
  final $Res Function(_EconomyItem) _then;

/// Create a copy of EconomyItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalAmount = null,Object? contractorAmount = null,Object? profit = null,}) {
  return _then(_EconomyItem(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,contractorAmount: null == contractorAmount ? _self.contractorAmount : contractorAmount // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ContractorEconomy {

/// Наименование подрядчика.
 String get contractorName;/// Список записей по датам.
 List<EconomyItem> get items;/// Итоговая сумма выручки по подрядчику.
 double get totalRevenue;/// Итоговая сумма выплат подрядчику.
 double get totalContractorAmount;/// Итоговая прибыль.
 double get totalProfit;
/// Create a copy of ContractorEconomy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractorEconomyCopyWith<ContractorEconomy> get copyWith => _$ContractorEconomyCopyWithImpl<ContractorEconomy>(this as ContractorEconomy, _$identity);

  /// Serializes this ContractorEconomy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractorEconomy&&(identical(other.contractorName, contractorName) || other.contractorName == contractorName)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalContractorAmount, totalContractorAmount) || other.totalContractorAmount == totalContractorAmount)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contractorName,const DeepCollectionEquality().hash(items),totalRevenue,totalContractorAmount,totalProfit);

@override
String toString() {
  return 'ContractorEconomy(contractorName: $contractorName, items: $items, totalRevenue: $totalRevenue, totalContractorAmount: $totalContractorAmount, totalProfit: $totalProfit)';
}


}

/// @nodoc
abstract mixin class $ContractorEconomyCopyWith<$Res>  {
  factory $ContractorEconomyCopyWith(ContractorEconomy value, $Res Function(ContractorEconomy) _then) = _$ContractorEconomyCopyWithImpl;
@useResult
$Res call({
 String contractorName, List<EconomyItem> items, double totalRevenue, double totalContractorAmount, double totalProfit
});




}
/// @nodoc
class _$ContractorEconomyCopyWithImpl<$Res>
    implements $ContractorEconomyCopyWith<$Res> {
  _$ContractorEconomyCopyWithImpl(this._self, this._then);

  final ContractorEconomy _self;
  final $Res Function(ContractorEconomy) _then;

/// Create a copy of ContractorEconomy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contractorName = null,Object? items = null,Object? totalRevenue = null,Object? totalContractorAmount = null,Object? totalProfit = null,}) {
  return _then(_self.copyWith(
contractorName: null == contractorName ? _self.contractorName : contractorName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<EconomyItem>,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,totalContractorAmount: null == totalContractorAmount ? _self.totalContractorAmount : totalContractorAmount // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ContractorEconomy].
extension ContractorEconomyPatterns on ContractorEconomy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractorEconomy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractorEconomy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractorEconomy value)  $default,){
final _that = this;
switch (_that) {
case _ContractorEconomy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractorEconomy value)?  $default,){
final _that = this;
switch (_that) {
case _ContractorEconomy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contractorName,  List<EconomyItem> items,  double totalRevenue,  double totalContractorAmount,  double totalProfit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractorEconomy() when $default != null:
return $default(_that.contractorName,_that.items,_that.totalRevenue,_that.totalContractorAmount,_that.totalProfit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contractorName,  List<EconomyItem> items,  double totalRevenue,  double totalContractorAmount,  double totalProfit)  $default,) {final _that = this;
switch (_that) {
case _ContractorEconomy():
return $default(_that.contractorName,_that.items,_that.totalRevenue,_that.totalContractorAmount,_that.totalProfit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contractorName,  List<EconomyItem> items,  double totalRevenue,  double totalContractorAmount,  double totalProfit)?  $default,) {final _that = this;
switch (_that) {
case _ContractorEconomy() when $default != null:
return $default(_that.contractorName,_that.items,_that.totalRevenue,_that.totalContractorAmount,_that.totalProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractorEconomy implements ContractorEconomy {
  const _ContractorEconomy({required this.contractorName, required final  List<EconomyItem> items, required this.totalRevenue, required this.totalContractorAmount, required this.totalProfit}): _items = items;
  factory _ContractorEconomy.fromJson(Map<String, dynamic> json) => _$ContractorEconomyFromJson(json);

/// Наименование подрядчика.
@override final  String contractorName;
/// Список записей по датам.
 final  List<EconomyItem> _items;
/// Список записей по датам.
@override List<EconomyItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Итоговая сумма выручки по подрядчику.
@override final  double totalRevenue;
/// Итоговая сумма выплат подрядчику.
@override final  double totalContractorAmount;
/// Итоговая прибыль.
@override final  double totalProfit;

/// Create a copy of ContractorEconomy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractorEconomyCopyWith<_ContractorEconomy> get copyWith => __$ContractorEconomyCopyWithImpl<_ContractorEconomy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractorEconomyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractorEconomy&&(identical(other.contractorName, contractorName) || other.contractorName == contractorName)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalContractorAmount, totalContractorAmount) || other.totalContractorAmount == totalContractorAmount)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contractorName,const DeepCollectionEquality().hash(_items),totalRevenue,totalContractorAmount,totalProfit);

@override
String toString() {
  return 'ContractorEconomy(contractorName: $contractorName, items: $items, totalRevenue: $totalRevenue, totalContractorAmount: $totalContractorAmount, totalProfit: $totalProfit)';
}


}

/// @nodoc
abstract mixin class _$ContractorEconomyCopyWith<$Res> implements $ContractorEconomyCopyWith<$Res> {
  factory _$ContractorEconomyCopyWith(_ContractorEconomy value, $Res Function(_ContractorEconomy) _then) = __$ContractorEconomyCopyWithImpl;
@override @useResult
$Res call({
 String contractorName, List<EconomyItem> items, double totalRevenue, double totalContractorAmount, double totalProfit
});




}
/// @nodoc
class __$ContractorEconomyCopyWithImpl<$Res>
    implements _$ContractorEconomyCopyWith<$Res> {
  __$ContractorEconomyCopyWithImpl(this._self, this._then);

  final _ContractorEconomy _self;
  final $Res Function(_ContractorEconomy) _then;

/// Create a copy of ContractorEconomy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contractorName = null,Object? items = null,Object? totalRevenue = null,Object? totalContractorAmount = null,Object? totalProfit = null,}) {
  return _then(_ContractorEconomy(
contractorName: null == contractorName ? _self.contractorName : contractorName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<EconomyItem>,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,totalContractorAmount: null == totalContractorAmount ? _self.totalContractorAmount : totalContractorAmount // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
