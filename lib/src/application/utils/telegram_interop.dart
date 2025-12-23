import 'dart:js_interop';

/// Типизированный интерфейс для взаимодействия с Telegram WebApp SDK.
@JS('window.Telegram.WebApp')
external TelegramWebAppExtension get telegramWebApp;

/// Расширение для основного объекта WebApp.
extension type TelegramWebAppExtension(JSObject _) implements JSObject {
  /// Данные инициализации, передаваемые Telegram.
  external TelegramInitData get initDataUnsafe;
  /// Сообщает Telegram, что приложение готово к отображению.
  external void ready();
  /// Разворачивает приложение на всю высоту экрана.
  external void expand();
  /// Закрывает Mini App.
  external void close();
}

/// Структура данных инициализации Telegram.
extension type TelegramInitData(JSObject _) implements JSObject {
  /// Информация о текущем пользователе.
  external TelegramUser? get user;
}

/// Данные пользователя Telegram.
extension type TelegramUser(JSObject _) implements JSObject {
  @JS('id')
  external JSNumber get _id;
  
  /// Возвращает ID пользователя в виде строки.
  String get id => _id.toDartInt.toString();
  
  @JS('first_name')
  external String? get firstName;
  
  @JS('last_name')
  external String? get lastName;
  
  external String? get username;
}

