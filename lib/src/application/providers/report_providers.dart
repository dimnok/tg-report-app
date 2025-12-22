import 'dart:js_interop';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/models/position_model.dart';

// Безопасный доступ к JS объектам Telegram
@JS('window.Telegram.WebApp')
external JSObject? get _telegramWebApp;

@JS('Object.keys')
external JSArray _jsKeys(JSObject obj);

@JS('eval')
external JSAny? _jsEval(String code);

/// Провайдер ID пользователя Telegram
final userIdProvider = Provider<String>((ref) {
  try {
    // Пытаемся безопасно достать ID через eval, чтобы не было TypeError
    final id = _jsEval('window.Telegram?.WebApp?.initDataUnsafe?.user?.id')?.toString();
    if (id != null && id != 'undefined') return id;
  } catch (e) {
    // В случае любой ошибки JS - игнорируем
  }
  
  // Если мы в браузере или данных нет - возвращаем тестовый ID
  return '12345'; 
});

/// Провайдер репозитория
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  const gasUrl = 'https://script.google.com/macros/s/AKfycbz5pHFkbHZMKIl7eIoDv1OoMZnzQsbBVWRQerG6lrUy3-Go0WnDa2NkjKIqVnbTvzM9/exec'; 
  return ReportRepositoryImpl(client: http.Client(), url: gasUrl);
});

/// Провайдер данных (проверка доступа + список позиций)
final initialDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  final userId = ref.watch(userIdProvider);
  return repository.getData(userId);
});

/// Notifier для строки поиска
class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateSearch(String query) => state = query;
}

final searchProvider = NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

/// Провайдер отфильтрованных позиций
final filteredPositionsProvider = Provider<List<PositionModel>>((ref) {
  final dataAsync = ref.watch(initialDataProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();

  return dataAsync.maybeWhen(
    data: (data) {
      if (data['status'] != 'authorized') return [];
      final List positionsJson = data['positions'];
      final positions = positionsJson.map((json) => PositionModel.fromJson(json)).toList();
      
      if (searchQuery.isEmpty) return positions;
      return positions.where((p) => p.name.toLowerCase().contains(searchQuery)).toList();
    },
    orElse: () => [],
  );
});

/// Notifier для управления состоянием текущего отчета
class ReportNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void updateQuantity(String id, int delta) {
    final current = state[id] ?? 0;
    final newValue = current + delta;
    state = {...state, id: newValue >= 0 ? newValue : 0};
  }

  void setQuantity(String id, int quantity) {
    state = {...state, id: quantity >= 0 ? quantity : 0};
  }

  void reset() => state = {};
}

final reportNotifierProvider = NotifierProvider<ReportNotifier, Map<String, int>>(ReportNotifier.new);
