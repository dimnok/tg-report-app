import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_model.freezed.dart';
part 'position_model.g.dart';

/// Модель позиции (товара или материала) в отчете.
@freezed
abstract class PositionModel with _$PositionModel {
  const factory PositionModel({
    /// Уникальный идентификатор позиции.
    required String id,
    /// Наименование позиции.
    required String name,
    /// Единица измерения (шт, кг, и т.д.).
    required String unit,
    /// Система, к которой относится позиция.
    @Default('') String system,
    /// Количество (используется при формировании отчета).
    @Default(0) int quantity,
  }) = _PositionModel;

  /// Фабрика для создания модели из JSON-ответа.
  factory PositionModel.fromJson(Map<String, dynamic> json) => _$PositionModelFromJson(json);
}
