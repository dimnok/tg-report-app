// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    _PositionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      system: json['system'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PositionModelToJson(_PositionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'system': instance.system,
      'quantity': instance.quantity,
    };
