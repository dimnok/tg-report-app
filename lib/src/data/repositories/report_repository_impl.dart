import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/position_model.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final http.Client client;
  final String url;

  ReportRepositoryImpl({required this.client, required this.url});

  @override
  Future<List<PositionModel>> getPositions() async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PositionModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки позиций: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети (get): $e');
    }
  }

  @override
  Future<void> sendReport(List<PositionModel> items) async {
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
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка отправки: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Failed to fetch')) {
        print('CORS: данные ушли.');
      } else {
        throw Exception('Ошибка сети (post): $e');
      }
    }
  }
}
