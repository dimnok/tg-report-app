import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../domain/models/position_model.dart';
import '../../domain/models/initial_data.dart';

/// Кнопка отправки отчета.
///
/// Собирает данные о выбранных позициях из текущего состояния [report]
/// и выполняет запрос на отправку через репозиторий.
class SubmitButton extends ConsumerStatefulWidget {
  // ...
  final Map<String, int> report;
  final String userId;

  const SubmitButton({super.key, required this.report, required this.userId});

  @override
  ConsumerState<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<SubmitButton> {
  bool _isSending = false;

  Future<void> _submitReport() async {
    final dataAsync = ref.read(initialDataProvider);
    final selectedObject = ref.read(selectedObjectProvider);

    if (selectedObject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите объект')),
      );
      return;
    }

    // Используем типизированную проверку через InitialData
    final selectedItems = dataAsync.maybeWhen(
      data: (data) => data.maybeWhen(
        authorized: (positions, objects, name, role) {
          final items = <PositionModel>[];
          widget.report.forEach((id, qty) {
            if (qty > 0) {
              final pos = positions.firstWhere((p) => p.id == id);
              items.add(pos.copyWith(quantity: qty));
            }
          });
          return items;
        },
        orElse: () => <PositionModel>[],
      ),
      orElse: () => <PositionModel>[],
    );

    if (selectedItems.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(reportRepositoryProvider).sendReport(
            items: selectedItems,
            userId: widget.userId,
            objectId: selectedObject.id,
            objectName: selectedObject.name,
          );
      ref.read(reportNotifierProvider.notifier).reset();
      if (mounted) _showSuccessSheet();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            content: Text(
              'Ошибка: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showSuccessSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 24),
            Text(
              'ОТПРАВЛЕНО',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Отчет успешно записан в таблицу и отправлен в группу.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОТЛИЧНО'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = widget.report.values.any((qty) => qty > 0);
    return ElevatedButton(
      onPressed: (hasItems && !_isSending) ? _submitReport : null,
      child: _isSending
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('ОТПРАВИТЬ'),
    );
  }
}
