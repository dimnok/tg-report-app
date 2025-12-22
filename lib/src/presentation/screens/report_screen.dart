import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../domain/models/position_model.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionsAsync = ref.watch(positionsProvider);
    final report = ref.watch(reportNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ОТЧЕТ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => ref.invalidate(positionsProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: positionsAsync.when(
        data: (positions) => _PositionsList(positions: positions),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Ошибка: $error',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
        ),
        child: _SubmitButton(report: report),
      ),
    );
  }
}

class _PositionsList extends ConsumerWidget {
  final List<PositionModel> positions;
  const _PositionsList({required this.positions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportNotifierProvider);

    return ListView.separated(
      physics: const ClampingScrollPhysics(), // Заменяем Bouncing на Clamping
      padding: const EdgeInsets.all(20),
      itemCount: positions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = positions[index];
        final quantity = report[item.id] ?? 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: quantity > 0 ? Colors.black : Colors.grey[200]!,
              width: quantity > 0 ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: quantity > 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.unit,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                _QuantityPicker(id: item.id, quantity: quantity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuantityPicker extends ConsumerStatefulWidget {
  final String id;
  final int quantity;
  const _QuantityPicker({required this.id, required this.quantity});

  @override
  ConsumerState<_QuantityPicker> createState() => _QuantityPickerState();
}

class _QuantityPickerState extends ConsumerState<_QuantityPicker> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(_QuantityPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onManualInput(String value) {
    final newQty = int.tryParse(value) ?? 0;
    ref.read(reportNotifierProvider.notifier).setQuantity(widget.id, newQty);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 0
                ? () => ref
                      .read(reportNotifierProvider.notifier)
                      .updateQuantity(widget.id, -1)
                : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 48),
            child: IntrinsicWidth(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: _onManualInput,
                onTap: () => setState(() => _isEditing = true),
                onSubmitted: (_) => setState(() => _isEditing = false),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                  setState(() => _isEditing = false);
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.quantity > 0 ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
          ),
          _CircleButton(
            icon: Icons.add,
            onPressed: () => ref
                .read(reportNotifierProvider.notifier)
                .updateQuantity(widget.id, 1),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerStatefulWidget {
  final Map<String, int> report;
  const _SubmitButton({required this.report});

  @override
  ConsumerState<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<_SubmitButton> {
  bool _isSending = false;

  Future<void> _submitReport() async {
    final positionsAsync = ref.read(positionsProvider);
    if (positionsAsync is! AsyncData<List<PositionModel>>) return;

    final selectedItems = <PositionModel>[];
    widget.report.forEach((id, qty) {
      if (qty > 0) {
        final pos = positionsAsync.value.firstWhere((p) => p.id == id);
        selectedItems.add(pos.copyWith(quantity: qty));
      }
    });

    if (selectedItems.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(reportRepositoryProvider).sendReport(selectedItems);
      ref.read(reportNotifierProvider.notifier).reset();
      if (mounted) {
        _showSuccessSheet();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Ошибка: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.black,
            ),
            const SizedBox(height: 24),
            const Text(
              'ОТПРАВЛЕНО',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
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
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('ОТПРАВИТЬ'),
    );
  }
}
