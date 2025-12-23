import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../domain/models/initial_data.dart';
import '../widgets/access_denied_screen.dart';
import '../widgets/search_field.dart';
import '../widgets/positions_list.dart';
import '../widgets/submit_button.dart';

/// Главный экран приложения для формирования и отправки отчетов.
///
/// Отвечает за:
/// * Переключение темы (светлая/темная).
/// * Первичную загрузку данных и проверку доступа.
/// * Отображение списка позиций или экрана отказа в доступе.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  // ...
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(initialDataProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('ОТЧЕТ'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              size: 20,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => ref.invalidate(initialDataProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dataAsync.when(
        data: (data) => data.when(
          authorized: (_, _) => const _MainContent(),
          unauthorized: (userId, userName) =>
              AccessDeniedScreen(userId: userId, userName: userName),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: isDark ? Colors.white : Colors.black,
            strokeWidth: 2,
          ),
        ),
        error: (error, stack) => _ErrorView(error: error),
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
        const SearchField(),
        Expanded(
          child: filteredPositions.isEmpty
              ? const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : PositionsList(positions: filteredPositions),
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
          child: SubmitButton(
            report: report,
            userId: ref.watch(userIdProvider),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final Object error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
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
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 45)),
              child: const Text('ПОВТОРИТЬ'),
            ),
          ],
        ),
      ),
    );
  }
}
