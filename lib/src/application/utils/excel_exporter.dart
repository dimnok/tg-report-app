import 'package:excel/excel.dart';
import '../../domain/models/production_item.dart';
import '../../domain/repositories/report_repository.dart';

/// Утилита для формирования данных в формат Excel (.xlsx).
class ExcelExporter {
  /// Формирует байты Excel-файла и инициирует его отправку через Telegram.
  static Future<void> exportProduction({
    required List<ProductionItem> items,
    required String userId,
    required ReportRepository repository,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Выработка'];
    
    excel.delete('Sheet1');

    // Заголовки таблицы
    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('Наименование'),
      TextCellValue('Ед. изм.'),
      TextCellValue('Итого'),
    ]);

    // Данные
    for (final item in items) {
      sheet.appendRow([
        TextCellValue(item.id),
        TextCellValue(item.name),
        TextCellValue(item.unit),
        DoubleCellValue(item.total),
      ]);
    }

    final fileBytes = excel.save();
    if (fileBytes != null) {
      final fileName = 'Vyrobotka_${DateTime.now().day}_${DateTime.now().month}.xlsx';
      
      // Отправляем файл через репозиторий в Telegram
      await repository.sendExcelToTelegram(fileBytes, fileName, userId);
    }
  }
}
