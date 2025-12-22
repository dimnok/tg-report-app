import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../domain/models/position_model.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(initialDataProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            size: 20,
          ),
          onPressed: () => ref.read(themeProvider.notifier).toggle(),
        ),
        title: const Text('ОТЧЕТ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => ref.invalidate(initialDataProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dataAsync.when(
        data: (data) {
          if (data['status'] == 'unauthorized') {
            return _AccessDeniedScreen(userId: ref.watch(userIdProvider));
          }
          return const _MainContent();
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: isDark ? Colors.white : Colors.black,
            strokeWidth: 2,
          ),
        ),
        error: (error, stack) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Произошла ошибка',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(initialDataProvider),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 45),
                  ),
                  child: const Text('ПОВТОРИТЬ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessDeniedScreen extends StatelessWidget {
  final String userId;
  const _AccessDeniedScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_person_outlined,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 32),
            const Text(
              'ДОСТУП ОГРАНИЧЕН',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ваш аккаунт не активирован. Обратитесь к администратору для получения доступа.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ID: ', style: TextStyle(color: Colors.grey)),
                  Text(
                    userId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: userId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ID скопирован')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends ConsumerWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPositions = ref.watch(filteredPositionsProvider);
    final report = ref.watch(reportNotifierProvider);

    return Column(
      children: [
        const _SearchField(),
        Expanded(
          child: filteredPositions.isEmpty
              ? const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : _PositionsList(positions: filteredPositions),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]!
                    : Colors.grey[100]!,
              ),
            ),
          ),
          child: _SubmitButton(
            report: report,
            userId: ref.watch(userIdProvider),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: TextField(
        onChanged: (value) =>
            ref.read(searchProvider.notifier).updateSearch(value),
        decoration: InputDecoration(
          hintText: 'Поиск позиций...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: quantity > 0
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
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
        color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
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

class _SubmitButton extends ConsumerStatefulWidget {
  final Map<String, int> report;
  final String userId;
  const _SubmitButton({required this.report, required this.userId});

  @override
  ConsumerState<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<_SubmitButton> {
  bool _isSending = false;

  Future<void> _submitReport() async {
    final dataAsync = ref.read(initialDataProvider);
    if (dataAsync is! AsyncData<Map<String, dynamic>>) return;

    final positionsJson = dataAsync.value['positions'] as List;
    final selectedItems = <PositionModel>[];

    widget.report.forEach((id, qty) {
      if (qty > 0) {
        final posJson = positionsJson.firstWhere((p) => p['id'] == id);
        selectedItems.add(
          PositionModel.fromJson(posJson).copyWith(quantity: qty),
        );
      }
    });

    if (selectedItems.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref
          .read(reportRepositoryProvider)
          .sendReport(selectedItems, widget.userId);
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
