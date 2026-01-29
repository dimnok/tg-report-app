import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Экран, отображаемый пользователям без прав доступа.
///
/// Выводит информацию о пользователе и его Telegram ID для возможности активации.
class AccessDeniedScreen extends StatelessWidget {
  // ...
  final String userId;
  final String userName;

  const AccessDeniedScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Добрый день,',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32),
                  const Text(
                    'ДОСТУП ОГРАНИЧЕН',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ваш аккаунт не активирован. Обратитесь к администратору для получения доступа.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.4, fontSize: 13),
                  ),
                ],
              ),
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
