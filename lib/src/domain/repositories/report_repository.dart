import '../models/initial_data.dart';
import '../models/position_model.dart';
import '../models/production_item.dart';
import '../models/user_model.dart';
import '../models/economy_model.dart';

/// Интерфейс для работы с данными отчетов и авторизацией.
abstract class ReportRepository {
  /// Получает начальные данные для пользователя по его [userId].
  /// Если указан [objectId], возвращает позиции только для этого объекта.
  /// Возвращает [InitialData] (авторизован/не авторизован).
  Future<InitialData> getData(String userId, {String? objectId});

  /// Получает суммарную выработку по всем позициям.
  Future<List<ProductionItem>> getProductionData(String userId);

  /// Отправляет список выбранных позиций [items] от имени пользователя [userId]
  /// для конкретного объекта [objectId] с именем [objectName].
  Future<void> sendReport({
    required List<PositionModel> items,
    required String userId,
    required String objectId,
    required String objectName,
  });

  /// Отправляет сформированный Excel-файл [bytes] пользователю [userId] через Telegram.
  Future<void> sendExcelToTelegram(
    List<int> bytes,
    String fileName,
    String userId,
  );

  /// АДМИН: Получает список всех пользователей.
  Future<List<UserModel>> getUsers(String adminId);

  /// АДМИН: Обновляет данные пользователя.
  Future<void> updateUser({
    required String adminId,
    required String targetUserId,
    required Map<String, dynamic> data,
  });

  /// АДМИН: Удаляет пользователя.
  Future<void> deleteUser({
    required String adminId,
    required String targetUserId,
  });

  /// АДМИН: Добавляет нового пользователя.
  Future<void> addUser({
    required String adminId,
    required UserModel user,
  });

  /// АДМИН: Получает данные для раздела экономики.
  Future<List<ContractorEconomy>> getEconomyData(String adminId);

  /// ТЕСТ: Отправляет тестовый отчет напрямую в Supabase.
  Future<void> sendTestReport({
    required String content,
    required String userId,
  });
}
