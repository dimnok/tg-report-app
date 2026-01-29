import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../domain/models/initial_data.dart';
import '../../domain/models/work_object.dart';
import '../widgets/access_denied_screen.dart';
import '../widgets/search_field.dart';
import '../widgets/positions_list.dart';
import '../widgets/submit_button.dart';

/// Главный экран приложения для формирования и отправки отчетов.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(initialDataProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedObject = ref.watch(selectedObjectProvider);
    final selectedSystem = ref.watch(selectedSystemProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          selectedSystem?.toUpperCase() ??
              (selectedObject?.name.toUpperCase() ?? 'ОТЧЕТ'),
        ),
        actions: [
          if (selectedObject != null)
            IconButton(
              icon: Icon(
                selectedSystem != null
                    ? Icons.account_tree_rounded
                    : Icons.edit_location_alt_rounded,
                size: 20,
              ),
              onPressed: () {
                if (selectedSystem != null) {
                  ref.read(selectedSystemProvider.notifier).select(null);
                } else {
                  ref.read(selectedObjectProvider.notifier).select(null);
                }
              },
            ),
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
          authorized: (positions, objects, userName, role) {
            if (selectedObject == null) {
              return _ObjectSelection(objects: objects);
            }
            if (selectedSystem == null) {
              return const _SystemSelection();
            }
            return const _MainContent();
          },
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

class _SystemSelection extends ConsumerWidget {
  const _SystemSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systems = ref.watch(availableSystemsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final report = ref.watch(reportNotifierProvider);
    final dataAsync = ref.watch(initialDataProvider);

    // Подсчет количества выбранных позиций в каждой системе
    Map<String, int> systemCounts = {};
    dataAsync.maybeWhen(
      data: (data) => data.maybeWhen(
        authorized: (positions, objects, name, role) {
          for (var system in systems) {
            int count = 0;
            for (var pos in positions) {
              if (pos.system == system && (report[pos.id] ?? 0) > 0) {
                count++;
              }
            }
            systemCounts[system] = count;
          }
        },
        orElse: () {},
      ),
      orElse: () {},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Text(
            'ВЫБЕРИТЕ СИСТЕМУ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: systems.isEmpty
              ? const Center(child: Text('Нет доступных систем'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: systems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final system = systems[index];
                    final count = systemCounts[system] ?? 0;

                    return InkWell(
                      onTap: () => ref
                          .read(selectedSystemProvider.notifier)
                          .select(system),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: count > 0
                              ? (isDark ? Colors.white : Colors.black)
                              : Colors.transparent,
                          width: count > 0 ? 1.5 : 0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                          children: [
                            Icon(
                              Icons.account_tree_rounded,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                system.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: count > 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            if (count > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white : Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: isDark ? Colors.black : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (report.values.any((qty) => qty > 0))
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[900]! : Colors.grey[100]!,
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

class _ObjectSelection extends ConsumerWidget {
  final List<WorkObject> objects;
  const _ObjectSelection({required this.objects});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Text(
            'ВЫБЕРИТЕ ОБЪЕКТ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: objects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final object = objects[index];
              return InkWell(
                onTap: () =>
                    ref.read(selectedObjectProvider.notifier).select(object),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          object.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
