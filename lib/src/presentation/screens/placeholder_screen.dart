import 'package:flutter/material.dart';

/// Экран-заглушка для разделов, находящихся в стадии разработки.
class PlaceholderScreen extends StatelessWidget {
  /// Заголовок раздела.
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 24),
            const Text(
              'РАЗДЕЛ В РАЗРАБОТКЕ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Скоро здесь появится новый функционал.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('НАЗАД'),
            ),
          ],
        ),
      ),
    );
  }
}

