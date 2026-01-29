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
import 'admin_screen.dart';

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
        child: SingleChildScrollView(
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
                      authorized: (positions, objects, name, role) => name,
                      unauthorized: (_, name) => name,
                    );
                    return _GreetingCard(userName: name);
                  },
                  loading: () => const _GreetingLoading(),
                  error: (_, _) => const _GreetingCard(userName: 'Гость'),
                ),
                const SizedBox(height: 24),
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
                // Админ-панель
                dataAsync.maybeWhen(
                  data: (data) => data.maybeWhen(
                    authorized: (positions, objects, name, role) {
                      if (role == 'admin') {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _MenuButton(
                            title: 'АДМИН-ПАНЕЛЬ',
                            icon: Icons.admin_panel_settings_rounded,
                            isPrimary: true,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminScreen(),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
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
  final bool isPrimary;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
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
          color: isPrimary
              ? (isDark ? Colors.blueGrey[800] : const Color(0xFFE8F5E9))
              : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F8E9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary
                ? (isDark ? Colors.blueGrey[600]! : const Color(0xFFC8E6C9))
                : (isDark ? Colors.grey[800]! : const Color(0xFFDCEDC8)),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isPrimary
                  ? (isDark ? Colors.blue[200] : Colors.blue[700])
                  : (isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isPrimary
                    ? (isDark ? Colors.blue[100] : Colors.blue[900])
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isPrimary
                  ? (isDark ? Colors.blue[200] : Colors.blue[700])
                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String userName;
  const _GreetingCard({required this.userName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final initials = userName.split(' ')
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isDark ? Colors.white : Colors.black,
            child: Text(
              initials,
              style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Добрый день,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingLoading extends StatelessWidget {
  const _GreetingLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 108,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
