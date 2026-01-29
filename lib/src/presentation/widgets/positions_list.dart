import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../domain/models/position_model.dart';

/// Список доступных позиций для формирования отчета.
/// 
/// Отрисовывает карточки позиций с возможностью изменения их количества.
class PositionsList extends ConsumerWidget {
// ...
  final List<PositionModel> positions;
  const PositionsList({super.key, required this.positions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: positions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = positions[index];
        final quantity = report[item.id] ?? 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: quantity > 0
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.transparent,
              width: quantity > 0 ? 1.5 : 0,
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
    if (value.isEmpty) {
      ref.read(reportNotifierProvider.notifier).setQuantity(widget.id, 0);
      return;
    }
    final newQty = int.tryParse(value);
    if (newQty != null) {
      ref.read(reportNotifierProvider.notifier).setQuantity(widget.id, newQty);
      if (value.startsWith('0') && value.length > 1) {
        _controller.text = newQty.toString();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
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
                onTap: () {
                  setState(() => _isEditing = true);
                  _controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controller.text.length,
                  );
                },
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
                  color: widget.quantity > 0
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.grey[500],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: onPressed != null
                ? (isDark ? Colors.white : Colors.black)
                : Colors.grey[isDark ? 800 : 300],
          ),
        ),
      ),
    );
  }
}

