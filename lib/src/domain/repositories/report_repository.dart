import '../models/initial_data.dart';
import '../models/position_model.dart';
import '../models/production_item.dart';

/// Интерфейс для работы с данными отчетов и авторизацией.
abstract class ReportRepository {
  /// Получает начальные данные для пользователя по его [userId].
  /// Возвращает [InitialData] (авторизован/не авторизован).
  Future<InitialData> getData(String userId);

  /// Получает суммарную выработку по всем позициям.
  Future<List<ProductionItem>> getProductionData(String userId);

  /// Отправляет список выбранных позиций [items] от имени пользователя [userId].
  Future<void> sendReport(List<PositionModel> items, String userId);

  /// Отправляет сформированный Excel-файл [bytes] пользователю [userId] через Telegram.
  Future<void> sendExcelToTelegram(
    List<int> bytes,
    String fileName,
    String userId,
  );
}
