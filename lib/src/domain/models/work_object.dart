import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_object.freezed.dart';
part 'work_object.g.dart';

/// Модель строительного объекта.
@freezed
abstract class WorkObject with _$WorkObject {
  const factory WorkObject({
    /// Уникальный идентификатор объекта.
    required String id,
    /// Название объекта.
    required String name,
  }) = _WorkObject;

  factory WorkObject.fromJson(Map<String, dynamic> json) => _$WorkObjectFromJson(json);
}

