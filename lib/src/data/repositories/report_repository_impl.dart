import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/position_model.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final http.Client client;
  final String url;

  ReportRepositoryImpl({required this.client, required this.url});

  @override
  Future<Map<String, dynamic>> getData(String userId) async {
    try {
      final response = await client.get(Uri.parse('$url?userId=$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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
