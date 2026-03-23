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

/// Цвета акцента в стиле WhatsApp.
const Color _whatsappTeal = Color(0xFF075E54);
const Color _whatsappGreen = Color(0xFF00A884);

/// Цвета карточек по разделам.
List<Color> _cardGradient(String id, bool isDark) {
  return switch (id) {
    'report' => isDark
        ? [const Color(0xFF00897B), const Color(0xFF00695C)]
        : [const Color(0xFF075E54), const Color(0xFF004D40)],
    'production' => isDark
        ? [const Color(0xFF1976D2), const Color(0xFF0D47A1)]
        : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
    'timesheet' => isDark
        ? [const Color(0xFFFB8C00), const Color(0xFFE65100)]
        : [const Color(0xFFFF9800), const Color(0xFFE65100)],
    'admin' => isDark
        ? [const Color(0xFF7B1FA2), const Color(0xFF4A148C)]
        : [const Color(0xFF6A1B9A), const Color(0xFF4A148C)],
    _ => isDark
        ? [_whatsappGreen, const Color(0xFF00897B)]
        : [_whatsappTeal, const Color(0xFF004D40)],
  };
}

/// Главный экран в стиле дашборда.
///
/// Отображает приветствие, горизонтальные табы, featured-карточку
/// и список разделов. Вся логика навигации сохраняется.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTabIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru_RU', null);
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(initialDataProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM', 'ru_RU').format(now);
    final userName = dataAsync.when(
      data: (data) => data.when(
        authorized: (_, __, name, ___) => name,
        unauthorized: (_, name) => name,
      ),
      loading: () => '...',
      error: (_, __) => 'Гость',
    );
    final isAdmin = dataAsync.maybeWhen(
      data: (data) => data.maybeWhen(
        authorized: (_, __, ___, role) => role == 'admin',
        orElse: () => false,
      ),
      orElse: () => false,
    );

    final tabs = [
      _HomeTab(id: 'report', label: 'Отчёт', icon: Icons.assignment_rounded),
      _HomeTab(id: 'production', label: 'Выработка', icon: Icons.trending_up_rounded),
      _HomeTab(id: 'timesheet', label: 'Табель', icon: Icons.calendar_today_rounded),
      if (isAdmin) _HomeTab(id: 'admin', label: 'Управление', icon: Icons.admin_panel_settings_rounded),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            size: 22,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => ref.read(themeProvider.notifier).toggle(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              size: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => ref.invalidate(initialDataProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dataAsync.isLoading || dataAsync.isReloading)
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? _whatsappGreen : _whatsappTeal,
                ),
              ),
            // Приветствие
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Привет, $userName',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isDark ? _whatsappGreen : _whatsappTeal).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isDark ? _whatsappGreen : _whatsappTeal).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: isDark ? _whatsappGreen : _whatsappTeal,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Горизонтальные табы
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        tabs.length,
                        (index) => _TabChip(
                          label: tabs[index].label,
                          isSelected: _selectedTabIndex == index,
                          onTap: () {
                            setState(() => _selectedTabIndex = index);
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Карточки со свайпом
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _selectedTabIndex = index),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final tab = tabs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        final page = _pageController.page ?? index.toDouble();
                        final diff = (page - index).abs();
                        final scale = (1.0 - diff * 0.12).clamp(0.88, 1.0);
                        return Transform.scale(
                          scale: scale,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) => _FeaturedCard(
                          tab: tab,
                          isDark: isDark,
                          minHeight: constraints.maxHeight,
                          onTap: () => _navigateTo(context, tab.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Подвал с информацией о разработчике и собственнике
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Собственность ООО ГТ ИНЖИНИРИНГ',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Разработчик Тельнов Д.',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String tabId) {
    switch (tabId) {
      case 'report':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen()));
        break;
      case 'production':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductionScreen()));
        break;
      case 'timesheet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Табель')),
        );
        break;
      case 'admin':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
        break;
    }
  }
}

class _HomeTab {
  final String id;
  final String label;
  final IconData icon;
  const _HomeTab({required this.id, required this.label, required this.icon});
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.grey[700] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected 
                ? (isDark ? Colors.white : Colors.black) 
                : (isDark ? Colors.grey[400] : Colors.black87),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final _HomeTab tab;
  final bool isDark;
  final double? minHeight;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.tab,
    required this.isDark,
    this.minHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (String title, String subtitle, List<String> bullets) = switch (tab.id) {
      'report' => (
          'Сформировать отчёт',
          '⚠️ ВАЖНЫЕ ПРАВИЛА ПРИ ПОДАЧЕ:',
          [
            '❗️ Внимательно проверяйте наименование работ',
            '❗️ Обращайте внимание на единицы измерения',
            '❗️ Будьте предельно точны при подаче объёмов',
          ],
        ),
      'production' => (
          'Просмотреть выработку',
          'Итоги по всем объектам',
          ['Статистика по объектам', 'Динамика выработки', 'Сравнение периодов'],
        ),
      'timesheet' => (
          'Табель',
          'Учёт рабочего времени',
          ['Учёт часов и смен', 'Выходные и праздники', 'Архив табелей'],
        ),
      'admin' => (
          'Управление',
          'Пользователи и настройки',
          ['Управление пользователями', 'Роли и доступы', 'Настройки приложения'],
        ),
      _ => (tab.label, '', <String>[]),
    };
    final gradientColors = _cardGradient(tab.id, isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Container(
          width: double.infinity,
          constraints: minHeight != null ? BoxConstraints(minHeight: minHeight!) : null,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(tab.icon, size: 32, color: Colors.white),
              ),
              if (minHeight != null) const Spacer(),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
              if (bullets.isNotEmpty) ...[
                const SizedBox(height: 20),
                ...bullets.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            b,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

