import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../domain/models/economy_model.dart';
import 'package:intl/intl.dart';

/// Экран "Экономика" для администратора.
/// Отображает финансовые показатели в разрезе подрядчиков и дат.
class EconomyScreen extends ConsumerWidget {
  const EconomyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final economyAsync = ref.watch(economyDataProvider);
    final currencyFormat = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Экономика'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(economyDataProvider),
          ),
        ],
      ),
      body: economyAsync.when(
        data: (data) => _EconomyList(data: data, currencyFormat: currencyFormat),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ошибка загрузки данных: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class _EconomyList extends StatelessWidget {
  final List<ContractorEconomy> data;
  final NumberFormat currencyFormat;

  const _EconomyList({
    required this.data,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Нет данных для отображения'));
    }

    // Расчет общих итогов по всем подрядчикам
    final grandTotalRevenue = data.fold<double>(0, (sum, item) => sum + item.totalRevenue);
    final grandTotalContractor = data.fold<double>(0, (sum, item) => sum + item.totalContractorAmount);
    final grandTotalProfit = data.fold<double>(0, (sum, item) => sum + item.totalProfit);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final contractor = data[index];
              return _ContractorCard(
                contractor: contractor,
                currencyFormat: currencyFormat,
              );
            },
          ),
        ),
        _GrandTotalPanel(
          revenue: grandTotalRevenue,
          contractor: grandTotalContractor,
          profit: grandTotalProfit,
          currencyFormat: currencyFormat,
        ),
      ],
    );
  }
}

class _ContractorCard extends StatelessWidget {
  final ContractorEconomy contractor;
  final NumberFormat currencyFormat;

  const _ContractorCard({
    required this.contractor,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contractor.contractorName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Divider(),
            ...contractor.items.map((item) => _EconomyItemRow(item: item, currencyFormat: currencyFormat)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Итого по подрядчику:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  currencyFormat.format(contractor.totalProfit),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: contractor.totalProfit >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EconomyItemRow extends StatelessWidget {
  final EconomyItem item;
  final NumberFormat currencyFormat;

  const _EconomyItemRow({
    required this.item,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.date,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ValueColumn(label: 'Сумма', value: currencyFormat.format(item.totalAmount)),
              _ValueColumn(label: 'Подрядчик', value: currencyFormat.format(item.contractorAmount)),
              _ValueColumn(
                label: 'Прибыль',
                value: currencyFormat.format(item.profit),
                valueColor: item.profit >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ValueColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ValueColumn({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _GrandTotalPanel extends StatelessWidget {
  final double revenue;
  final double contractor;
  final double profit;
  final NumberFormat currencyFormat;

  const _GrandTotalPanel({
    required this.revenue,
    required this.contractor,
    required this.profit,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ИТОГО ПО ВСЕМ ОБЪЕКТАМ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TotalItem(label: 'Выручка', value: currencyFormat.format(revenue)),
                _TotalItem(label: 'Расходы', value: currencyFormat.format(contractor)),
                _TotalItem(
                  label: 'Прибыль',
                  value: currencyFormat.format(profit),
                  color: profit >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _TotalItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

