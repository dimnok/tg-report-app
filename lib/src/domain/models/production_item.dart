import 'package:freezed_annotation/freezed_annotation.dart';

part 'production_item.freezed.dart';
part 'production_item.g.dart';

/// Модель итоговой выработки по конкретной позиции.
@freezed
abstract class ProductionItem with _$ProductionItem {
  const factory ProductionItem({
    /// ID позиции.
    required String id,
    /// Наименование позиции.
    required String name,
    /// Единица измерения.
    required String unit,
    /// Суммарное количество за все время.
    required double total,
  }) = _ProductionItem;

  factory ProductionItem.fromJson(Map<String, dynamic> json) => _$ProductionItemFromJson(json);
}

