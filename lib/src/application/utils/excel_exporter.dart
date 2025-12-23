import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../../domain/models/production_item.dart';

/// Утилита для экспорта данных в формат Excel (.xlsx).
class ExcelExporter {
  /// Формирует и инициирует отправку/сохранение Excel-файла через Web Share API.
  static Future<void> exportProduction(List<ProductionItem> items) async {
    final excel = Excel.createExcel();
    final sheet = excel['Выработка'];
    
    // Удаляем стандартный лист
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

    // Сохранение и экспорт
    final fileBytes = excel.save();
    if (fileBytes != null) {
      final fileName = 'Vyrobotka_${DateTime.now().day}_${DateTime.now().month}.xlsx';
      
      // Создаем XFile из байтов
      final xFile = XFile.fromData(
        Uint8List.fromList(fileBytes),
        name: fileName,
        mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      // Вызываем системное диалоговое окно "Поделиться"
      await Share.shareXFiles([xFile], text: 'Отчет по выработке');
    }
  }
}

