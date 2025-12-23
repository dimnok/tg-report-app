import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../application/providers/report_providers.dart';
import '../../application/providers/theme_provider.dart';
import '../../domain/models/initial_data.dart';
import 'report_screen.dart';
import 'production_screen.dart';
import 'placeholder_screen.dart';

/// Главный стартовый экран приложения.
///
/// Отображает текущую дату, приветствие и кнопки навигации по разделам.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Инициализация локализации для корректного отображения даты на русском
    initializeDateFormatting('ru_RU', null);
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(initialDataProvider);
    final themeMode = ref.watch(themeProvider);

    // Форматирование текущей даты
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM', 'ru_RU').format(now);

    return Scaffold(
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
        title: const Text('ГЛАВНАЯ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: () => ref.invalidate(initialDataProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              dataAsync.when(
                data: (data) {
                  final name = data.when(
                    authorized: (_, name) => name,
                    unauthorized: (_, name) => name,
                  );
                  return Text(
                    'ДОБРЫЙ ДЕНЬ,\n${name.toUpperCase()}!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  );
                },
                loading: () => const Text(
                  'ЗАГРУЗКА...',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                error: (_, __) => const Text(
                  'ДОБРЫЙ ДЕНЬ!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 48),
              _MenuButton(
                title: 'ОТЧЁТ',
                icon: Icons.assignment_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                title: 'ВЫРАБОТКА',
                icon: Icons.trending_up_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductionScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                title: 'ТАБЕЛЬ',
                icon: Icons.calendar_today_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceholderScreen(title: 'Табель'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: isDark ? Colors.white : Colors.black),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
