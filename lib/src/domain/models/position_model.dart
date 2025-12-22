import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_model.freezed.dart';
part 'position_model.g.dart';

@freezed
abstract class PositionModel with _$PositionModel {
  const factory PositionModel({
    required String id,
    required String name,
    required String unit,
    @Default(0) int quantity,
  }) = _PositionModel;

  factory PositionModel.fromJson(Map<String, dynamic> json) => _$PositionModelFromJson(json);
}
