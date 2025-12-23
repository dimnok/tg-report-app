// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? 'Без имени',
  status: json['status'] as String? ?? 'blocked',
  contractor: json['contractor'] as String? ?? 'Без подрядчика',
  role: json['role'] as String? ?? 'user',
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'contractor': instance.contractor,
      'role': instance.role,
    };
