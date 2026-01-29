/// Конфигурация подключения к Self-hosted Supabase для тестового чтения данных.
///
/// Если [url] или [anonKey] пустые, чтение позиций из Supabase отключено —
/// приложение использует только GAS (старая база).
///
/// Задать при запуске:
/// ```bash
/// flutter run -d chrome --dart-define=SUPABASE_URL=http://147.45.99.66:8100 --dart-define=SUPABASE_ANON_KEY=твой_anon_key
/// ```
class SupabaseConfig {
  SupabaseConfig._();

  /// URL API Supabase (Kong). Пример: `http://147.45.99.66:8100`.
  static const String url =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  /// Anon-ключ проекта. Берётся из .env на сервере (SUPABASE_ANON_KEY).
  static const String anonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  /// Включено ли тестовое чтение позиций из Supabase.
  static bool get isEnabled => url.isNotEmpty && anonKey.isNotEmpty;
}
