import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String id,
    @Default('Без имени') String name,
    @Default('blocked') String status,
    @Default('Без подрядчика') String contractor,
    @Default('user') String role,
    /// ID Telegram-группы для отчётов пользователя (например -1001234567890).
    /// Если пусто — используется группа по умолчанию (fallback).
    @JsonKey(name: 'group_chat_id') @Default('') String groupChatId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
