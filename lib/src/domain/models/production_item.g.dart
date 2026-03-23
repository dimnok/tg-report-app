// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductionItem _$ProductionItemFromJson(Map<String, dynamic> json) =>
    _ProductionItem(
      id: json['id'] as String,
      objectName: json['objectName'] as String? ?? '',
      systemName: json['systemName'] as String? ?? '',
      name: json['name'] as String,
      unit: json['unit'] as String,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductionItemToJson(_ProductionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objectName': instance.objectName,
      'systemName': instance.systemName,
      'name': instance.name,
      'unit': instance.unit,
      'total': instance.total,
    };
