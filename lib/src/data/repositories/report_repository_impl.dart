import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../domain/models/initial_data.dart';
import '../../domain/models/position_model.dart';
import '../../domain/models/production_item.dart';
import '../../domain/repositories/report_repository.dart';

/// Реализация [ReportRepository] для работы с Google Apps Script (GAS) через HTTP.
class ReportRepositoryImpl implements ReportRepository {
  /// HTTP-клиент для запросов.
  final http.Client client;
  /// Базовый URL скрипта GAS.
  final String url;

  ReportRepositoryImpl({required this.client, required this.url});

  @override
  Future<InitialData> getData(String userId) async {
    try {
      final response = await client.get(Uri.parse('$url?userId=$userId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        final String status = data['status'] ?? 'unauthorized';
        final String userName = data['userName'] ?? 'Гость';

        if (status == 'authorized') {
          final List positionsJson = data['positions'] ?? [];
          final positions = positionsJson
              .map((json) => PositionModel.fromJson(json))
              .toList();
          
          return InitialData.authorized(
            positions: positions,
            userName: userName,
          );
        } else {
          return InitialData.unauthorized(
            userId: userId,
            userName: userName,
          );
        }
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<List<ProductionItem>> getProductionData(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('$url?userId=$userId&action=getProduction'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List productionJson = data['data'] ?? [];
          return productionJson
              .map((json) => ProductionItem.fromJson(json))
              .toList();
        } else {
          final message = data['message'] ?? 'Ошибка получения выработки';
          debugPrint('GAS Error: $message');
          throw Exception(message);
        }
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<void> sendReport(List<PositionModel> items, String userId) async {
    try {
      final itemsJson = items.map((item) => {
        'id': item.id,
        'name': item.name,
        'qty': item.quantity,
        'unit': item.unit,
      }).toList();

      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'items': itemsJson,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка отправки: ${response.statusCode}');
      }
    } catch (e) {
      if (!e.toString().contains('Failed to fetch')) {
        throw Exception('Ошибка сети: $e');
      }
    }
  }
}
