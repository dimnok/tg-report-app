# Маршрутизация отчётов в разные Telegram-группы по пользователю

Данный документ описывает, как настроить GAS (Google Apps Script), чтобы отчёты разных пользователей отправлялись в разные Telegram-группы.

---

## 1. Изменения в Google Sheets

### Лист `Users`

Добавьте новую колонку **`group_chat_id`** (например, после `Role`):

| Колонка   | Описание |
| :-------- | :------- |
| `group_chat_id` | ID Telegram-группы для отчётов этого пользователя. Например: `-1001234567890`. Если пусто — используется группа по умолчанию. |

---

## 2. Как получить ID группы Telegram

1. Добавьте бота в нужную группу.
2. Напишите в группе любое сообщение.
3. Откройте в браузере: `https://api.telegram.org/bot<ВАШ_BOT_TOKEN>/getUpdates`
4. В ответе JSON найдите `"chat":{"id": -1001234567890}` — это ID группы (обычно отрицательное число).
5. Заполните его в таблице Users или в админке приложения.

---

## 3. Изменения в GAS

### 3.1. Функция получения `group_chat_id` по `userId`

Добавьте в скрипт функцию:

```javascript
/**
 * Получает ID Telegram-группы для пользователя из листа Users.
 * @param {string} userId - Telegram ID пользователя
 * @returns {string|null} - ID группы (например "-1001234567890") или null, если не задан
 */
function getUserGroupChatId(userId) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Users');
  if (!sheet) return null;

  const headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const colIndex = headers.findIndex(function(h) {
    return String(h).toLowerCase().replace(/\s/g, '') === 'groupchatid' ||
           String(h).toLowerCase().replace(/\s/g, '') === 'group_chat_id';
  });
  if (colIndex === -1) return null;

  const idCol = headers.findIndex(function(h) {
    return String(h).toLowerCase().trim() === 'id';
  });
  if (idCol === -1) return null;

  const data = sheet.getDataRange().getValues();
  for (let i = 1; i < data.length; i++) {
    if (String(data[i][idCol]) === String(userId)) {
      const val = data[i][colIndex];
      if (val !== null && val !== '' && val !== undefined) {
        return String(val).trim();
      }
      return null;
    }
  }
  return null;
}
```

### 3.2. Логика отправки в Telegram (sendReport)

Найдите в своём скрипте место, где вызывается отправка сообщения в Telegram при `action === 'sendReport'`. Обычно это что-то вроде:

```javascript
// Типичный вызов Telegram API
var telegramUrl = 'https://api.telegram.org/bot' + BOT_TOKEN + '/sendMessage';
var payload = {
  chat_id: CHAT_ID,  // <-- раньше одна группа для всех
  text: messageText,
  parse_mode: 'HTML'
};
UrlFetchApp.fetch(telegramUrl, {
  method: 'post',
  contentType: 'application/json',
  payload: JSON.stringify(payload)
});
```

Замените на:

```javascript
var userId = postData.userId;  // userId из тела POST-запроса
var targetChatId = getUserGroupChatId(userId);

// Если у пользователя нет своей группы — используем группу по умолчанию
if (!targetChatId) {
  targetChatId = DEFAULT_GROUP_CHAT_ID;  // ваша текущая константа с ID группы
}

var telegramUrl = 'https://api.telegram.org/bot' + BOT_TOKEN + '/sendMessage';
var payload = {
  chat_id: targetChatId,
  text: messageText,
  parse_mode: 'HTML'
};
UrlFetchApp.fetch(telegramUrl, {
  method: 'post',
  contentType: 'application/json',
  payload: JSON.stringify(payload)
});
```

### 3.3. Аналогично для sendExcel

Если `sendExcel` тоже отправляет файл в группу, примените ту же логику: замените жёстко заданный `chat_id` на `getUserGroupChatId(userId)` с fallback на группу по умолчанию.

---

## 4. Обработка addUser и updateUser в GAS

Убедитесь, что при `addUser` и `updateUser` GAS сохраняет колонку `group_chat_id` из входящих данных.

Пример для `addUser` (если вы добавляете строку вручную):

```javascript
// postData.data содержит: { id, name, contractor, status, role, group_chat_id }
var newRow = [
  postData.data.id,
  postData.data.name || '',
  postData.data.status || 'blocked',
  postData.data.contractor || '',
  postData.data.role || 'user',
  postData.data.group_chat_id || postData.data.groupChatId || ''  // поддерживаем оба варианта ключа
];
sheet.appendRow(newRow);
```

Для `updateUser` — обновляйте ячейку в колонке `group_chat_id` для соответствующего пользователя.

---

## 5. Обработка getUsers в GAS

При формировании ответа `getUsers` добавьте в каждый объект пользователя поле `group_chat_id` (из колонки листа Users), чтобы Flutter-приложение его отображало и могло редактировать.

---

## 6. Резюме

| Шаг | Действие |
| :-- | :------- |
| 1 | Добавить колонку `group_chat_id` в лист Users |
| 2 | Добавить функцию `getUserGroupChatId(userId)` в GAS |
| 3 | В sendReport: заменить фиксированный `chat_id` на `getUserGroupChatId(userId)` с fallback |
| 4 | В sendExcel: то же самое |
| 5 | В addUser/updateUser: сохранять `group_chat_id` |
| 6 | В getUsers: возвращать `group_chat_id` |

После этого каждый пользователь будет получать отчёты в свою группу, если она указана; иначе — в группу по умолчанию.
