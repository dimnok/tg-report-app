import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../utils/telegram_interop.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/models/position_model.dart';
import '../../domain/models/initial_data.dart';
import '../../domain/models/production_item.dart';
import '../../domain/models/work_object.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/economy_model.dart';

/// Предоставляет Telegram ID текущего пользователя.
/// В случае отсутствия данных WebApp (например, в браузере), возвращает тестовое значение.
final userIdProvider = Provider<String>((ref) {
  try {
    final user = telegramWebApp.initDataUnsafe.user;
    if (user != null) {
      return user.id.toString();
    }
  } catch (e) {
    // В случае ошибки (например, запуск не в TG) - возвращаем тестовый ID
  }

  return '12345';
});

/// Предоставляет экземпляр репозитория для работы с отчетами.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  const gasUrl =
      'https://script.google.com/macros/s/AKfycbz5pHFkbHZMKIl7eIoDv1OoMZnzQsbBVWRQerG6lrUy3-Go0WnDa2NkjKIqVnbTvzM9/exec';
  return ReportRepositoryImpl(client: http.Client(), url: gasUrl);
});

/// Предоставляет данные инициализации (права доступа и список позиций).
final initialDataProvider = FutureProvider<InitialData>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  final userId = ref.watch(userIdProvider);
  final selectedObject = ref.watch(selectedObjectProvider);

  return repository.getData(userId, objectId: selectedObject?.id);
});

/// Провайдер списка пользователей для админа.
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  final adminId = ref.watch(userIdProvider);
  return repository.getUsers(adminId);
});

/// Провайдер данных экономики для админа.
final economyDataProvider = FutureProvider<List<ContractorEconomy>>((
  ref,
) async {
  final repository = ref.watch(reportRepositoryProvider);
  final adminId = ref.watch(userIdProvider);
  return repository.getEconomyData(adminId);
});

/// Управляет текущим выбранным объектом.
class SelectedObjectNotifier extends Notifier<WorkObject?> {
  @override
  WorkObject? build() => null;
  void select(WorkObject? object) => state = object;
}

/// Предоставляет текущий выбранный объект.
final selectedObjectProvider =
    NotifierProvider<SelectedObjectNotifier, WorkObject?>(
      SelectedObjectNotifier.new,
    );

/// Предоставляет данные итоговой выработки.
final productionDataProvider = FutureProvider<List<ProductionItem>>((
  ref,
) async {
  final repository = ref.watch(reportRepositoryProvider);
  final userId = ref.watch(userIdProvider);
  return repository.getProductionData(userId);
});

/// Управляет состоянием строки поиска.
class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateSearch(String query) => state = query;
}

/// Предоставляет текущий поисковый запрос.
final searchProvider = NotifierProvider<SearchNotifier, String>(
  SearchNotifier.new,
);

/// Предоставляет отфильтрованный список позиций на основе поискового запроса.
final filteredPositionsProvider = Provider<List<PositionModel>>((ref) {
  final dataAsync = ref.watch(initialDataProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();

  return dataAsync.maybeWhen(
    data: (data) => data.maybeWhen(
      authorized: (positions, objects, name, role) {
        if (searchQuery.isEmpty) return positions;
        return positions
            .where((p) => p.name.toLowerCase().contains(searchQuery))
            .toList();
      },
      orElse: () => [],
    ),
    orElse: () => [],
  );
});

/// Управляет текущим набором выбранных позиций и их количеством в отчете.
class ReportNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  /// Изменяет количество позиции на [delta].
  void updateQuantity(String id, int delta) {
    final current = state[id] ?? 0;
    final newValue = current + delta;
    state = {...state, id: newValue >= 0 ? newValue : 0};
  }

  /// Устанавливает точное [quantity] для позиции [id].
  void setQuantity(String id, int quantity) {
    state = {...state, id: quantity >= 0 ? quantity : 0};
  }

  /// Сбрасывает текущий отчет.
  void reset() => state = {};
}

/// Предоставляет состояние текущего формируемого отчета.
final reportNotifierProvider =
    NotifierProvider<ReportNotifier, Map<String, int>>(ReportNotifier.new);
