import 'package:freezed_annotation/freezed_annotation.dart';
import 'position_model.dart';

part 'initial_data.freezed.dart';

/// Состояние инициализации данных при входе в приложение.
/// 
/// Используется для разграничения прав доступа и передачи списка доступных позиций.
@freezed
sealed class InitialData with _$InitialData {
  /// Состояние для авторизованного пользователя.
  /// [positions] — список доступных для отчета позиций.
  /// [userName] — имя пользователя для отображения в интерфейсе.
  const factory InitialData.authorized({
    required List<PositionModel> positions,
    required String userName,
  }) = AuthorizedData;

  /// Состояние для пользователя без прав доступа.
  /// [userId] — Telegram ID пользователя.
  /// [userName] — имя пользователя для обращения.
  const factory InitialData.unauthorized({
    required String userId,
    required String userName,
  }) = UnauthorizedData;
}

