import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import '../../domain/models/production_item.dart';

/// Утилита для экспорта данных в формат Excel (.xlsx).
class ExcelExporter {
  /// Формирует и инициирует отправку/сохранение Excel-файла.
  /// 
  /// Использует гибридный подход: сначала пытается вызвать Web Share API,
  /// а при неудаче или отсутствии поддержки — создает временную Blob-ссылку.
  static Future<void> exportProduction(List<ProductionItem> items) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Выработка'];
      
      excel.delete('Sheet1');

      sheet.appendRow([
        TextCellValue('ID'),
        TextCellValue('Наименование'),
        TextCellValue('Ед. изм.'),
        TextCellValue('Итого'),
      ]);

      for (final item in items) {
        sheet.appendRow([
          TextCellValue(item.id),
          TextCellValue(item.name),
          TextCellValue(item.unit),
          DoubleCellValue(item.total),
        ]);
      }

      final fileBytes = excel.save();
      if (fileBytes == null) return;

      final fileName = 'Vyrobotka_${DateTime.now().day}_${DateTime.now().month}.xlsx';
      final uint8list = Uint8List.fromList(fileBytes);

      // Пытаемся использовать Share API (лучший опыт для мобильных)
      try {
        final xFile = XFile.fromData(
          uint8list,
          name: fileName,
          mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );

        final result = await Share.shareXFiles([xFile], text: 'Отчет по выработке');
        
        // Если результат ShareResult.unavailable, значит Share API не поддерживается
        if (result.status == ShareResultStatus.unavailable) {
          _triggerDownloadFallback(uint8list, fileName);
        }
      } catch (e) {
        debugPrint('Share API error: $e');
        // Если Share API упал, пробуем классический метод скачивания
        _triggerDownloadFallback(uint8list, fileName);
      }
    } catch (e) {
      debugPrint('Export error: $e');
    }
  }

  /// Резервный метод скачивания через Blob и временную ссылку.
  static void _triggerDownloadFallback(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    
    // Очистка ссылки после небольшого ожидания
    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }
}

