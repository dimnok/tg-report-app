import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/position_model.dart';

/// Источник данных: чтение списка позиций из таблицы Supabase `positions`.
///
/// Используется только для теста новой базы без отключения GAS.
/// При любой ошибке или пустом результате вызывающий код должен использовать GAS.
class SupabasePositionsDataSource {
  SupabasePositionsDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'positions';

  /// Возвращает список позиций из Supabase.
  /// [objectId] — при указании фильтр по колонке `object_id`.
  /// Возвращает `null` при ошибке или недоступности таблицы.
  Future<List<PositionModel>?> getPositions({String? objectId}) async {
    try {
      var query = _client.from(_table).select('id, name, unit, system');
      if (objectId != null && objectId.isNotEmpty) {
        query = query.eq('object_id', objectId);
      }
      final response = await query.order('sort_order', ascending: true);

      final rawList = response as List<dynamic>;
      if (rawList.isEmpty) {
        return null;
      }

      final list = <PositionModel>[];
      for (final row in rawList) {
        final map = row is Map<String, dynamic> ? row : Map<String, dynamic>.from(row as Map);
        final id = map['id']?.toString();
        final name = map['name']?.toString() ?? '';
        final unit = map['unit']?.toString() ?? '';
        final system = map['system']?.toString() ?? '';
        if (id == null || id.isEmpty) continue;
        list.add(PositionModel(
          id: id,
          name: name,
          unit: unit,
          system: system,
          quantity: 0,
        ));
      }
      return list.isEmpty ? null : list;
    } catch (_) {
      return null;
    }
  }
}
