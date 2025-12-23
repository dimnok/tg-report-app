// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'economy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EconomyItem _$EconomyItemFromJson(Map<String, dynamic> json) => _EconomyItem(
  date: json['date'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  contractorAmount: (json['contractorAmount'] as num).toDouble(),
  profit: (json['profit'] as num).toDouble(),
);

Map<String, dynamic> _$EconomyItemToJson(_EconomyItem instance) =>
    <String, dynamic>{
      'date': instance.date,
      'totalAmount': instance.totalAmount,
      'contractorAmount': instance.contractorAmount,
      'profit': instance.profit,
    };

_ContractorEconomy _$ContractorEconomyFromJson(Map<String, dynamic> json) =>
    _ContractorEconomy(
      contractorName: json['contractorName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => EconomyItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalContractorAmount: (json['totalContractorAmount'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
    );

Map<String, dynamic> _$ContractorEconomyToJson(_ContractorEconomy instance) =>
    <String, dynamic>{
      'contractorName': instance.contractorName,
      'items': instance.items,
      'totalRevenue': instance.totalRevenue,
      'totalContractorAmount': instance.totalContractorAmount,
      'totalProfit': instance.totalProfit,
    };
