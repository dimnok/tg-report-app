import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../domain/models/initial_data.dart';
import '../../domain/models/position_model.dart';
import '../../domain/models/production_item.dart';
import '../../domain/models/work_object.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/economy_model.dart';
import '../../domain/repositories/report_repository.dart';

/// Реализация [ReportRepository] для работы с Google Apps Script (GAS) через HTTP.
class ReportRepositoryImpl implements ReportRepository {
  /// HTTP-клиент для запросов.
  final http.Client client;

  /// Базовый URL скрипта GAS.
  final String url;

  ReportRepositoryImpl({required this.client, required this.url});

  @override
  Future<InitialData> getData(String userId, {String? objectId}) async {
    try {
      var query = '$url?userId=$userId';
      if (objectId != null) {
        query += '&objectId=$objectId';
      }
      final response = await client.get(Uri.parse(query));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final String status = data['status'] ?? 'unauthorized';
        final String userName = data['userName'] ?? 'Гость';
        final String role = data['role'] ?? 'user';

        if (status == 'authorized') {
          final List positionsJson = data['positions'] ?? [];
          final positions =
              positionsJson.map((json) => PositionModel.fromJson(json)).toList();

          final List objectsJson = data['objects'] ?? [];
          final objects =
              objectsJson.map((json) => WorkObject.fromJson(json)).toList();

          return InitialData.authorized(
            positions: positions,
            objects: objects,
            userName: userName,
            role: role,
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
  Future<void> sendReport({
    required List<PositionModel> items,
    required String userId,
    required String objectId,
    required String objectName,
  }) async {
    try {
      final itemsJson = items
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'qty': item.quantity,
                'unit': item.unit,
                'system': item.system,
              })
          .toList();

      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'action': 'sendReport',
          'items': itemsJson,
          'userId': userId,
          'objectId': objectId,
          'objectName': objectName,
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

  @override
  Future<void> sendExcelToTelegram(
    List<int> bytes,
    String fileName,
    String userId,
  ) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'action': 'sendExcel',
          'fileBytes': base64Encode(bytes),
          'fileName': fileName,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка отправки файла: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети при отправке файла: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers(String adminId) async {
    try {
      final response = await client.get(
        Uri.parse('$url?userId=$adminId&action=getUsers'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List usersJson = data['users'] ?? [];
          return usersJson.map((json) => UserModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Ошибка получения пользователей');
        }
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<void> updateUser({
    required String adminId,
    required String targetUserId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'action': 'updateUser',
          'userId': adminId,
          'targetUserId': targetUserId,
          'data': data,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка обновления пользователя: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<void> deleteUser({
    required String adminId,
    required String targetUserId,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'action': 'deleteUser',
          'userId': adminId,
          'targetUserId': targetUserId,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка удаления пользователя: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<void> addUser({
    required String adminId,
    required UserModel user,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        body: jsonEncode({
          'action': 'addUser',
          'userId': adminId,
          'data': user.toJson(),
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Ошибка добавления пользователя: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  @override
  Future<List<ContractorEconomy>> getEconomyData(String adminId) async {
    try {
      final response = await client.get(
        Uri.parse('$url?userId=$adminId&action=getEconomy'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List economyJson = data['economy'] ?? [];
          return economyJson
              .map((json) => ContractorEconomy.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Ошибка получения данных экономики');
        }
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }
}
