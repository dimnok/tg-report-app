import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/telegram_interop.dart';
import '../../core/config/supabase_config.dart';
import '../../data/datasources/supabase_positions_datasource.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/dual_source_report_repository.dart';
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
/// При включённом [SupabaseConfig] позиции читаются из Supabase (тест), остальное — из GAS.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  const gasUrl =
      'https://script.google.com/macros/s/AKfycbz5pHFkbHZMKIl7eIoDv1OoMZnzQsbBVWRQerG6lrUy3-Go0WnDa2NkjKIqVnbTvzM9/exec';
  final gas = ReportRepositoryImpl(client: http.Client(), url: gasUrl);

  if (!SupabaseConfig.isEnabled) {
    return gas;
  }
  try {
    final supabasePositions = SupabasePositionsDataSource(Supabase.instance.client);
    return DualSourceReportRepository(
      gas: gas,
      supabasePositions: supabasePositions,
    );
  } catch (_) {
    return gas;
  }
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

/// Управляет текущей выбранной системой.
class SelectedSystemNotifier extends Notifier<String?> {
  @override
  String? build() {
    // Сбрасываем систему при смене объекта
    ref.watch(selectedObjectProvider);
    return null;
  }
  void select(String? system) => state = system;
}

/// Предоставляет текущую выбранную систему.
final selectedSystemProvider =
    NotifierProvider<SelectedSystemNotifier, String?>(
      SelectedSystemNotifier.new,
    );

/// Предоставляет список уникальных систем для выбранного объекта.
final availableSystemsProvider = Provider<List<String>>((ref) {
  final dataAsync = ref.watch(initialDataProvider);
  return dataAsync.maybeWhen(
    data: (data) => data.maybeWhen(
      authorized: (positions, objects, name, role) {
        final systems = positions
            .map((p) => p.system)
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList();
        systems.sort();
        return systems;
      },
      orElse: () => [],
    ),
    orElse: () => [],
  );
});

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
  final selectedSystem = ref.watch(selectedSystemProvider);

  return dataAsync.maybeWhen(
    data: (data) => data.maybeWhen(
      authorized: (positions, objects, name, role) {
        var result = positions;
        
        // Фильтр по системе
        if (selectedSystem != null) {
          result = result.where((p) => p.system == selectedSystem).toList();
        }
        
        // Фильтр по поиску
        if (searchQuery.isNotEmpty) {
          result = result
              .where((p) => p.name.toLowerCase().contains(searchQuery))
              .toList();
        }
        
        return result;
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
