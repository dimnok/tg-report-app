import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/models/position_model.dart';

/// Провайдер репозитория для работы с Google Sheets (через GAS)
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  const gasUrl = 'https://script.google.com/macros/s/AKfycbz5pHFkbHZMKIl7eIoDv1OoMZnzQsbBVWRQerG6lrUy3-Go0WnDa2NkjKIqVnbTvzM9/exec'; 
  return ReportRepositoryImpl(client: http.Client(), url: gasUrl);
});

/// Провайдер для получения списка позиций
final positionsProvider = FutureProvider<List<PositionModel>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.getPositions();
});

/// Notifier для управления состоянием текущего отчета (ID позиции -> Количество)
class ReportNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void updateQuantity(String id, int delta) {
    final current = state[id] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      state = {...state, id: newValue};
    } else {
      state = {...state, id: 0};
    }
  }

  void setQuantity(String id, int quantity) {
    if (quantity >= 0) {
      state = {...state, id: quantity};
    } else {
      state = {...state, id: 0};
    }
  }

  void reset() => state = {};
}

final reportNotifierProvider = NotifierProvider<ReportNotifier, Map<String, int>>(ReportNotifier.new);
