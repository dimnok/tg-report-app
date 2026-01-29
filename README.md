# tg_mini_app

Flutter приложение для работы с отчётами через Telegram Mini App.

## Быстрый старт

### Обычный запуск (только GAS)

```bash
flutter run -d chrome
```

### Тестовый запуск с Supabase (позиции из новой БД)

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=http://147.45.99.66:8100 \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pbmlhcHAiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTcwNjQ3NjAwMCwiZXhwIjoyMDIyMDkyMDAwfQ.unique_anon_part_miniapp
```

(ANON_KEY из `/root/MiniApp/self-hosting/.env` на сервере.)

## Архитектура

Приложение использует **Clean Architecture** с разделением на слои:
- **Domain** — бизнес-логика и модели
- **Data** — репозитории и источники данных (GAS, Supabase)
- **Application** — провайдеры Riverpod
- **Presentation** — UI экраны и виджеты

## Тестирование новой базы данных

Для безопасного тестирования Supabase без отключения GAS реализована схема **«двойного источника»**:
- Позиции читаются из Supabase (если доступно), остальное — из GAS
- При ошибке Supabase автоматически используется GAS
- Запись данных всегда идёт через GAS (старая база не меняется)

Подробности: [`docs/SERVER_MAP.md`](docs/SERVER_MAP.md#6-тестовое-чтение-позиций-из-supabase-без-отключения-gas)

## Документация

- [`docs/SERVER_MAP.md`](docs/SERVER_MAP.md) — настройка сервера и подключения
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — архитектура приложения
- [`docs/BUSINESS_LOGIC.md`](docs/BUSINESS_LOGIC.md) — бизнес-логика
