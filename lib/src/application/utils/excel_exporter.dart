import 'dart:convert';
import 'dart:html' as html;
import 'package:excel/excel.dart';
import '../../domain/models/production_item.dart';

/// Утилита для экспорта данных в формат Excel (.xlsx).
class ExcelExporter {
  /// Формирует и запускает скачивание Excel-файла с данными выработки.
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

    // Сохранение и скачивание (специфично для Web/Telegram)
    final fileBytes = excel.save();
    if (fileBytes != null) {
      final content = base64Encode(fileBytes);
      html.AnchorElement(
          href: 'data:application/octet-stream;charset=utf-16le;base64,$content')
        ..setAttribute('download', 'Vyrobotka_${DateTime.now().day}_${DateTime.now().month}.xlsx')
        ..click();
    }
  }
}

