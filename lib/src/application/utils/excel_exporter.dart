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
    String? contractor,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Выработка'];
    
    excel.delete('Sheet1');

    // Заголовки таблицы
    sheet.appendRow([
      TextCellValue('ID позиции'),
      TextCellValue('Наименование объекта'),
      TextCellValue('Наименование подсистемы'),
      TextCellValue('Наименование позиции'),
      TextCellValue('Единица измерения'),
      TextCellValue('Количество'),
    ]);

    // Данные
    for (final item in items) {
      sheet.appendRow([
        TextCellValue(item.id),
        TextCellValue(item.objectName),
        TextCellValue(item.systemName),
        TextCellValue(item.name),
        TextCellValue(item.unit),
        DoubleCellValue(item.total),
      ]);
    }

    final fileBytes = excel.save();
    if (fileBytes != null) {
      final prefix = contractor != null ? 'Vyrobotka_$contractor' : 'Vyrobotka_Moya';
      final fileName = '${prefix}_${DateTime.now().day}_${DateTime.now().month}.xlsx';
      
      // Отправляем файл через репозиторий в Telegram
      await repository.sendExcelToTelegram(fileBytes, fileName, userId);
    }
  }
}
