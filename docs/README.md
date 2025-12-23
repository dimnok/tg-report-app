# Документация проекта TG Mini App (Отчеты)

Данный проект представляет собой Telegram Mini App, разработанный на Flutter, для системы учета выработки и формирования отчетов.

## Оглавление
1. [Архитектура проекта](./ARCHITECTURE.md) — структура папок, используемые паттерны и библиотеки.
2. [Бизнес-логика](./BUSINESS_LOGIC.md) — описание основных процессов: авторизация, отчетность, просмотр выработки.
3. [API и Данные](./API_AND_DATA.md) — взаимодействие с backend (Google Apps Script), модели данных и структура таблиц.
4. [Backend (GAS)](./BACKEND_GAS.md) — логика серверных скриптов и интеграция с Telegram.

## Технологический стек
- **Framework:** Flutter (Web/Telegram Mini App)
- **State Management:** Riverpod (Generator)
- **Architecture:** Clean Architecture
- **Data Modeling:** Freezed, JSON Serializable
- **Backend:** Google Apps Script (GAS) + Google Sheets
- **Design:** Strict Black & White (Material 3)

