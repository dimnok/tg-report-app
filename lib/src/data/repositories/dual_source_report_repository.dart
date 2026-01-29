import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/initial_data.dart';
import '../../domain/models/position_model.dart';
import '../../domain/models/production_item.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/economy_model.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/supabase_positions_datasource.dart';

/// Репозиторий с двойным источником для позиций: Supabase (тест) с откатом на GAS.
///
/// Все операции идут через [gas]. Для [getData] при авторизованном пользователе
/// сначала пробуем взять позиции из Supabase; при успехе и непустом списке
/// подменяем позиции в ответе. Иначе остаётся ответ от GAS — старая база не страдает.
class DualSourceReportRepository implements ReportRepository {
  DualSourceReportRepository({
    required ReportRepository gas,
    SupabasePositionsDataSource? supabasePositions,
  })  : _gas = gas,
        _supabasePositions = supabasePositions;

  final ReportRepository _gas;
  final SupabasePositionsDataSource? _supabasePositions;

  @override
  Future<InitialData> getData(String userId, {String? objectId}) async {
    final data = await _gas.getData(userId, objectId: objectId);

    if (data is! AuthorizedData || _supabasePositions == null) {
      return data;
    }

    final fromSupabase =
        await _supabasePositions.getPositions(objectId: objectId);
    if (fromSupabase == null || fromSupabase.isEmpty) {
      return data;
    }

    return data.copyWith(positions: fromSupabase);
  }

  @override
  Future<List<ProductionItem>> getProductionData(String userId) =>
      _gas.getProductionData(userId);

  @override
  Future<void> sendReport({
    required List<PositionModel> items,
    required String userId,
    required String objectId,
    required String objectName,
  }) =>
      _gas.sendReport(
        items: items,
        userId: userId,
        objectId: objectId,
        objectName: objectName,
      );

  @override
  Future<void> sendExcelToTelegram(
    List<int> bytes,
    String fileName,
    String userId,
  ) =>
      _gas.sendExcelToTelegram(bytes, fileName, userId);

  @override
  Future<List<UserModel>> getUsers(String adminId) => _gas.getUsers(adminId);

  @override
  Future<void> updateUser({
    required String adminId,
    required String targetUserId,
    required Map<String, dynamic> data,
  }) =>
      _gas.updateUser(
        adminId: adminId,
        targetUserId: targetUserId,
        data: data,
      );

  @override
  Future<void> deleteUser({
    required String adminId,
    required String targetUserId,
  }) =>
      _gas.deleteUser(adminId: adminId, targetUserId: targetUserId);

  @override
  Future<void> addUser({
    required String adminId,
    required UserModel user,
  }) =>
      _gas.addUser(adminId: adminId, user: user);

  @override
  Future<List<ContractorEconomy>> getEconomyData(String adminId) async {
    // ... существующий код ...
    return _gas.getEconomyData(adminId);
  }

  @override
  Future<void> sendTestReport({
    required String content,
    required String userId,
  }) async {
    if (_supabasePositions == null) {
      throw Exception('Supabase не настроен. Запусти с параметрами --dart-define');
    }
    await Supabase.instance.client.from('test_reports').insert({
      'content': content,
      'author_id': userId,
    });
  }
}
