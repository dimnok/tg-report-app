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

    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: TextField(
        onChanged: (value) =>
            ref.read(searchProvider.notifier).updateSearch(value),
        decoration: InputDecoration(
          hintText: 'Поиск позиций...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.grey[400] : primary.withValues(alpha: 0.7),
            size: 22,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[900] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

