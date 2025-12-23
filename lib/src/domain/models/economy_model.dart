import 'package:freezed_annotation/freezed_annotation.dart';

part 'economy_model.freezed.dart';
part 'economy_model.g.dart';

/// Модель записи в экономическом отчете.
@freezed
abstract class EconomyItem with _$EconomyItem {
  const factory EconomyItem({
    /// Дата записи.
    required String date,
    /// Общая сумма (выручка).
    required double totalAmount,
    /// Сумма подрядчика (себестоимость).
    required double contractorAmount,
    /// Прибыль (выручка - себестоимость).
    required double profit,
  }) = _EconomyItem;

  factory EconomyItem.fromJson(Map<String, dynamic> json) => _$EconomyItemFromJson(json);
}

/// Модель экономики подрядчика.
@freezed
abstract class ContractorEconomy with _$ContractorEconomy {
  const factory ContractorEconomy({
    /// Наименование подрядчика.
    required String contractorName,
    /// Список записей по датам.
    required List<EconomyItem> items,
    /// Итоговая сумма выручки по подрядчику.
    required double totalRevenue,
    /// Итоговая сумма выплат подрядчику.
    required double totalContractorAmount,
    /// Итоговая прибыль.
    required double totalProfit,
  }) = _ContractorEconomy;

  factory ContractorEconomy.fromJson(Map<String, dynamic> json) => _$ContractorEconomyFromJson(json);
}

