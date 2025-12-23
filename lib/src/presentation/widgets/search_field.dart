import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';

/// Поле текстового поиска для фильтрации списка позиций.
class SearchField extends ConsumerWidget {
// ...
  const SearchField({super.key});

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

