// --- НАСТРОЙКИ ---
const BOT_TOKEN = '8207223276:AAEXz-mxonTDWeDWzZbBfCEfxzP8sxVd7X8';
const CHAT_ID = '-5031509821';
const CHAT_ID_GROUP2 = '-1003781880260';
const APP_DIRECT_LINK = 'https://t.me/gteng_bot/Othet';
// -----------------

const SS = SpreadsheetApp.getActiveSpreadsheet();

/**
 * Универсальное получение данных листа и карты заголовков
 */
function getHeaders(sheetName) {
  const sheet = SS.getSheetByName(sheetName);
  if (!sheet) return null;
  const data = sheet.getDataRange().getValues();
  if (data.length === 0) return null;

  const headers = data[0];
  const map = {};
  headers.forEach((h, i) => {
    if (h) map[h.toString().trim().toLowerCase()] = i;
  });
  return { map, headers, sheet, data };
}

/**
 * Получает ID Telegram-группы для пользователя из листа Users.
 * Если у пользователя задан group_chat_id — отправляем туда; иначе — в CHAT_ID по умолчанию.
 * @param {string} userId - Telegram ID пользователя
 * @returns {string|null} - ID группы (например "-1001234567890") или null
 */
function getUserGroupChatId(userId) {
  const h = getHeaders("Users");
  if (!h) return null;

  const groupKey = h.map["group_chat_id"] ?? h.map["groupchatid"];
  if (groupKey === undefined) return null;

  const idIdx = h.map["id"];
  if (idIdx === undefined) return null;

  const userRow = h.data.find(row => row[idIdx] && row[idIdx].toString() === String(userId));
  if (!userRow) return null;

  const val = userRow[groupKey];
  if (val === null || val === undefined || val === "") return null;

  return String(val).trim();
}

/**
 * Возвращает chat_id для отправки: пользовательская группа или дефолтная.
 * @param {string} userId
 * @returns {string}
 */
function getTargetChatId(userId) {
  const userChatId = getUserGroupChatId(userId);
  return userChatId || CHAT_ID;
}

/**
 * Проверка доступа пользователя
 */
function checkUserAccess(userId) {
  if (!userId) return { isActive: false, userName: "Гость" };
  const h = getHeaders("Users");
  if (!h) return { isActive: false, userName: "Гость" };

  const idIdx = h.map["id"];
  const userRow = h.data.find(row => row[idIdx] && row[idIdx].toString() === userId.toString());

  if (userRow) {
    const status = userRow[h.map["status"]];
    const isActive = status === true || status === "Active" || status === "Checked" || status === "authorized" || status === "TRUE";
    return {
      isActive: isActive,
      userName: userRow[h.map["name"]] || "Пользователь",
      contractor: userRow[h.map["contractor"]] || "Без подрядчика",
      role: (userRow[h.map["role"]] || "user").toString().toLowerCase()
    };
  }
  return { isActive: false, userName: "Гость", role: "user" };
}

/**
 * Обработка GET запросов
 */
function doGet(e) {
  const userId = e?.parameter?.userId;
  const action = e?.parameter?.action;
  const selectedObjectId = e?.parameter?.objectId;
  const access = checkUserAccess(userId);

  if (!userId || !access.isActive) {
    return createJsonResponse({ status: "unauthorized", userName: access.userName });
  }

  // --- АДМИН: Список пользователей ---
  if (action === "getUsers" && access.role === "admin") {
    const h = getHeaders("Users");
    if (!h) return createJsonResponse({ status: "success", users: [] });

    const users = h.data.slice(1).map(row => {
      let obj = {};
      Object.keys(h.map).forEach(key => {
        let val = row[h.map[key]];
        if (val === null || val === undefined) {
          val = "";
        } else if (typeof val === 'boolean') {
          val = val ? "authorized" : "blocked";
        } else {
          val = val.toString();
        }
        obj[key] = val;
      });
      return obj;
    });
    return createJsonResponse({ status: "success", users: users });
  }

  // --- АДМИН: Данные экономики ---
  if (action === "getEconomy" && access.role === "admin") {
    return getEconomyData();
  }

  const hPos = getHeaders("Positions");

  // --- ВЫРАБОТКА (БРИГАДНЫЙ МЕТОД) ---
  if (action === "getProduction") {
    const hUsers = getHeaders("Users");
    const teamUserIds = hUsers.data.slice(1)
      .filter(row => row[hUsers.map["contractor"]] === access.contractor)
      .map(row => row[hUsers.map["id"]].toString());

    const hDataV2 = getHeaders("Data_v2");
    const stats = {};

    hDataV2.data.slice(1).forEach(row => {
      const rowUserId = row[hDataV2.map["user_id"]];
      if (teamUserIds.includes(rowUserId ? rowUserId.toString() : "")) {
        const pId = row[hDataV2.map["position_id"]];
        const qty = parseFloat(row[hDataV2.map["qty"]] || 0);
        stats[pId] = (stats[pId] || 0) + qty;
      }
    });

    const nameMap = {};
    const pIdIdx = hPos.map["id"];
    const pNameIdx = hPos.map["наименование"] ?? hPos.map["name"];
    const pUnitIdx = hPos.map["unit"] ?? hPos.map["ед. изм."];

    hPos.data.slice(1).forEach(row => {
      const id = row[pIdIdx];
      if (id) nameMap[id] = { n: row[pNameIdx], u: row[pUnitIdx] };
    });

    const production = Object.keys(stats).map(pId => ({
      id: pId,
      name: nameMap[pId]?.n || "Неизвестно",
      unit: nameMap[pId]?.u || "",
      total: stats[pId]
    })).filter(p => p.total > 0);

    return createJsonResponse({ status: "success", data: production });
  }

  // --- ПОЛУЧЕНИЕ ОБЪЕКТОВ ---
  const hAssign = getHeaders("UserAssignments");
  const hObj = getHeaders("Objects");

  const assignedObjectIds = hAssign.data.slice(1)
    .filter(row => row[hAssign.map["user_id"]] && row[hAssign.map["user_id"]].toString() === userId.toString())
    .map(row => row[hAssign.map["object_id"]].toString());

  const userObjects = hObj.data.slice(1)
    .filter(row => {
      const id = row[hObj.map["id"]];
      const activeIdx = hObj.map["is_active"] ?? hObj.map["active"] ?? hObj.map["активен"];
      const activeVal = activeIdx !== undefined ? row[activeIdx] : true;
      const isActive = activeVal === true || activeVal === "TRUE" || activeVal === "active";
      return assignedObjectIds.includes(id ? id.toString() : "") && isActive;
    })
    .map(row => ({
      id: String(row[hObj.map["id"]]),
      name: String(row[hObj.map["name"]])
    }));

  // --- ПОЛУЧЕНИЕ ПОЗИЦИЙ ---
  let positions = [];
  if (selectedObjectId) {
    const pIdIdx = hPos.map["id"];
    const pObjIdIdx = hPos.map["object_id"];
    const pNameIdx = hPos.map["наименование"] ?? hPos.map["name"];
    const pUnitIdx = hPos.map["unit"] ?? hPos.map["ед. изм."];
    const pSystemIdx = hPos.map["система"] ?? hPos.map["system"];

    positions = hPos.data.slice(1)
      .filter(row => row[pIdIdx] && row[pObjIdIdx].toString() === selectedObjectId.toString())
      .map(row => ({
        id: String(row[pIdIdx]),
        name: String(row[pNameIdx]),
        unit: String(row[pUnitIdx]),
        system: pSystemIdx !== undefined ? String(row[pSystemIdx]) : ""
      }));
  }

  return createJsonResponse({
    status: "authorized",
    userName: access.userName,
    role: access.role,
    contractor: access.contractor,
    objects: userObjects,
    positions: positions
  });
}

/**
 * Логика сбора данных для экрана Экономика
 */
function getEconomyData() {
  const hData = getHeaders("Data_v2");
  const hUsers = getHeaders("Users");

  if (!hData) return createJsonResponse({ status: "success", economy: [] });

  const userToContractor = {};
  hUsers.data.slice(1).forEach(row => {
    userToContractor[row[hUsers.map["id"]].toString()] = row[hUsers.map["contractor"]] || "Без подрядчика";
  });

  const economyMap = {};

  hData.data.slice(1).forEach(row => {
    const uId = row[hData.map["user_id"]].toString();
    const contractor = userToContractor[uId] || "Неизвестен";
    const rawDate = new Date(row[hData.map["date"]]);
    const date = Utilities.formatDate(rawDate, "GMT+3", "dd.MM.yyyy");

    const totalAmount = parseFloat(row[hData.map["total_client_cost"]] || 0);
    const contractorAmount = parseFloat(row[hData.map["total_user_cost"]] || 0);
    const profit = parseFloat(row[hData.map["margin"]] || 0);

    if (!economyMap[contractor]) economyMap[contractor] = {};
    if (!economyMap[contractor][date]) {
      economyMap[contractor][date] = { date, totalAmount: 0, contractorAmount: 0, profit: 0 };
    }

    economyMap[contractor][date].totalAmount += totalAmount;
    economyMap[contractor][date].contractorAmount += contractorAmount;
    economyMap[contractor][date].profit += profit;
  });

  const result = Object.keys(economyMap).map(cName => {
    const items = Object.values(economyMap[cName]).sort((a, b) => {
      const parseDate = (s) => new Date(s.split('.').reverse().join('-'));
      return parseDate(b.date) - parseDate(a.date);
    });
    return {
      contractorName: cName,
      items: items,
      totalRevenue: items.reduce((sum, i) => sum + i.totalAmount, 0),
      totalContractorAmount: items.reduce((sum, i) => sum + i.contractorAmount, 0),
      totalProfit: items.reduce((sum, i) => sum + i.profit, 0)
    };
  });

  return createJsonResponse({ status: "success", economy: result });
}

/**
 * Обработка POST запросов
 */
function doPost(e) {
  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(30000);
    const payload = JSON.parse(e.postData.contents);
    const access = checkUserAccess(payload.userId);

    if (!access.isActive) return createJsonResponse({ status: "error", message: "Forbidden" });

    // --- АДМИН: CRUD ---
    if (access.role === "admin") {
      const hUsers = getHeaders("Users");
      if (payload.action === "addUser") {
        const newRow = new Array(hUsers.headers.length).fill("");
        hUsers.headers.forEach((hName, i) => {
          const key = hName.toString().trim().toLowerCase();
          const keyUnderscore = key.replace(/\s+/g, "_");
          const val = payload.data[key] ?? payload.data[keyUnderscore];
          if (val !== undefined) newRow[i] = val;
        });
        hUsers.sheet.appendRow(newRow);
        return createJsonResponse({ status: "ok" });
      }
      if (payload.action === "updateUser") {
        const targetId = payload.targetUserId.toString();
        const idIdx = hUsers.map["id"];
        for (let i = 1; i < hUsers.data.length; i++) {
          if (hUsers.data[i][idIdx].toString() === targetId) {
            const rowIdx = i + 1;
            if (payload.data.name !== undefined) hUsers.sheet.getRange(rowIdx, hUsers.map["name"] + 1).setValue(payload.data.name);
            if (payload.data.status !== undefined) hUsers.sheet.getRange(rowIdx, hUsers.map["status"] + 1).setValue(payload.data.status);
            if (payload.data.contractor !== undefined) hUsers.sheet.getRange(rowIdx, hUsers.map["contractor"] + 1).setValue(payload.data.contractor);
            if (payload.data.role !== undefined) hUsers.sheet.getRange(rowIdx, hUsers.map["role"] + 1).setValue(payload.data.role);
            const groupChatIdx = hUsers.map["group_chat_id"] ?? hUsers.map["groupchatid"];
            if (groupChatIdx !== undefined && payload.data.group_chat_id !== undefined) {
              hUsers.sheet.getRange(rowIdx, groupChatIdx + 1).setValue(payload.data.group_chat_id);
            }
            return createJsonResponse({ status: "ok" });
          }
        }
      }
      if (payload.action === "deleteUser") {
        const targetId = payload.targetUserId.toString();
        const idIdx = hUsers.map["id"];
        for (let i = 1; i < hUsers.data.length; i++) {
          if (hUsers.data[i][idIdx].toString() === targetId) {
            hUsers.sheet.deleteRow(i + 1);
            return createJsonResponse({ status: "ok" });
          }
        }
      }
    }

    // --- ОТЧЕТЫ И EXCEL ---
    if (payload.action === "sendExcel") {
      const targetChatId = getTargetChatId(payload.userId);
      const blob = Utilities.newBlob(Utilities.base64Decode(payload.fileBytes), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', payload.fileName || "report.xlsx");
      sendDocumentToTelegram(targetChatId, blob, "📊 *ОТЧЕТ ПО ВЫРАБОТКЕ*\n👤: *" + access.userName + "*");
      return createJsonResponse({ status: "ok" });
    }

    // ЗАПИСЬ В DATA_V2
    const hPos = getHeaders("Positions");
    const hDataV2 = getHeaders("Data_v2");

    const contractorKey = access.contractor.toLowerCase();
    const contractorPriceIdx = hPos.map[contractorKey];
    const clientPriceIdx = hPos.map["client_price"];

    if (contractorPriceIdx === undefined) throw new Error("Колонка цен для '" + access.contractor + "' не найдена");

    const dateStr = new Date();
    const formattedDate = Utilities.formatDate(dateStr, "GMT+3", "dd.MM.yyyy");

    const newRows = [];
    let tgMessage = "📊 *ОТЧЕТ ЗА " + formattedDate + "*\n👤: *" + access.userName + "*\n🏗: *" + (payload.objectName || "Объект") + "*\n--------------------------\n";

    const groupedBySystem = {};

    payload.items.forEach(item => {
      if (item.qty > 0) {
        const pIdIdx = hPos.map["id"];
        const posRow = hPos.data.find(r => r[pIdIdx].toString() === item.id.toString());
        if (posRow) {
          const rate = parseFloat(posRow[contractorPriceIdx] || 0);
          const clientPrice = parseFloat(posRow[clientPriceIdx] || 0);
          const system = item.system || "Без системы";

          newRows.push([
            dateStr, payload.userId, payload.objectId, system, item.id, item.qty,
            rate, clientPrice, item.qty * rate, item.qty * clientPrice,
            (item.qty * clientPrice) - (item.qty * rate)
          ]);

          if (!groupedBySystem[system]) groupedBySystem[system] = [];
          groupedBySystem[system].push("• " + item.name + ": *" + item.qty + " " + item.unit + "*");
        }
      }
    });

    Object.keys(groupedBySystem).forEach(sys => {
      tgMessage += "\n📂 *" + sys.toUpperCase() + "*\n";
      tgMessage += groupedBySystem[sys].join("\n") + "\n";
    });

    if (newRows.length > 0) {
      hDataV2.sheet.getRange(hDataV2.sheet.getLastRow() + 1, 1, newRows.length, 11).setValues(newRows);
      const targetChatId = getTargetChatId(payload.userId);
      sendToTelegram(tgMessage, targetChatId);
    }
    return createJsonResponse({ status: "ok" });

  } catch (err) {
    return createJsonResponse({ status: "error", message: err.toString() });
  } finally {
    lock.releaseLock();
  }
}

function createJsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data)).setMimeType(ContentService.MimeType.JSON);
}

function sendToTelegram(text, chatId) {
  const targetChat = chatId || CHAT_ID;
  UrlFetchApp.fetch("https://api.telegram.org/bot" + BOT_TOKEN + "/sendMessage", {
    method: "post",
    contentType: "application/json",
    payload: JSON.stringify({ chat_id: targetChat, text: text, parse_mode: "Markdown" })
  });
}

function sendDocumentToTelegram(chatId, blob, caption) {
  UrlFetchApp.fetch("https://api.telegram.org/bot" + BOT_TOKEN + "/sendDocument", {
    method: "post",
    payload: { chat_id: chatId, document: blob, caption: caption, parse_mode: "Markdown" }
  });
}

/**
 * Отправка в Telegram с проверкой миграции группы в супергруппу.
 * Возвращает { ok: true } или { ok: false, message: "текст ошибки" }.
 */
function sendToTelegramWithMigrateCheck(text, chatId) {
  const targetChat = chatId || CHAT_ID;
  const url = "https://api.telegram.org/bot" + BOT_TOKEN + "/sendMessage";
  const options = {
    method: "post",
    contentType: "application/json",
    payload: JSON.stringify({ chat_id: targetChat, text: text, parse_mode: "Markdown" }),
    muteHttpExceptions: true
  };
  const response = UrlFetchApp.fetch(url, options);
  const result = JSON.parse(response.getContentText());
  if (result.ok) return { ok: true };
  if (result.error_code === 400 && result.description && result.description.indexOf("upgraded to a supergroup") !== -1) {
    const newId = result.parameters && result.parameters.migrate_to_chat_id;
    return { ok: false, message: "Группа обновлена в супергруппу.\n\nНовый ID: " + newId + "\n\nОбнови CHAT_ID_GROUP2 в Code.gs (строка 4)." };
  }
  return { ok: false, message: "Ошибка Telegram: " + (result.description || result) };
}

// --- ТЕСТЫ ОТПРАВКИ (меню при открытии таблицы) ---

/**
 * Создаёт меню «ТЕСТ БОТА» при открытии таблицы.
 * ВАЖНО: Удали функцию onOpen() из отдельного тестового файла, иначе меню будет дублироваться.
 */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu("🚀 ТЕСТ БОТА")
    .addItem("Отправить тестовый отчет", "testTelegramReport")
    .addSeparator()
    .addItem("📤 Группа 1 (по умолчанию)", "testSendToGroup1")
    .addItem("📤 Группа 2", "testSendToGroup2")
    .addItem("📤 В обе группы", "testSendToBothGroups")
    .addToUi();
}

/**
 * Тестовый отчёт (как из приложения) — отправка в CHAT_ID по умолчанию.
 */
function testTelegramReport() {
  const dateStr = new Date().toLocaleDateString("ru-RU");
  const testMessage =
    "🧪 *ТЕСТОВЫЙ ОТЧЕТ*\n" +
    "📅 Дата: " + dateStr + "\n" +
    "--------------------------\n" +
    "• Арматура 10мм: *150 кг*\n" +
    "• Бетон B25: *12 м3*\n" +
    "• Кирпич: *500 шт*\n" +
    "--------------------------\n" +
    "✅ Связь с таблицей установлена!";
  try {
    sendToTelegram(testMessage, CHAT_ID);
    SpreadsheetApp.getUi().alert("✅ Успешно! Проверь группу в Telegram.");
  } catch (e) {
    SpreadsheetApp.getUi().alert("❌ Ошибка: " + e.toString());
  }
}

/** Тест: отправка в группу 1 (CHAT_ID). */
function testSendToGroup1() {
  const msg = "🧪 *ТЕСТ* — группа 1\n" + Utilities.formatDate(new Date(), "GMT+3", "dd.MM.yyyy HH:mm");
  try {
    sendToTelegram(msg, CHAT_ID);
    SpreadsheetApp.getUi().alert("Отправлено в группу 1: " + CHAT_ID);
  } catch (e) {
    SpreadsheetApp.getUi().alert("Ошибка: " + e.toString());
  }
}

/** Тест: отправка в группу 2 (CHAT_ID_GROUP2). */
function testSendToGroup2() {
  const msg = "🧪 *ТЕСТ* — группа 2\n" + Utilities.formatDate(new Date(), "GMT+3", "dd.MM.yyyy HH:mm");
  const result = sendToTelegramWithMigrateCheck(msg, CHAT_ID_GROUP2);
  if (result.ok) {
    SpreadsheetApp.getUi().alert("Отправлено в группу 2: " + CHAT_ID_GROUP2);
  } else {
    SpreadsheetApp.getUi().alert(result.message);
  }
}

/** Тест: отправка в обе группы. */
function testSendToBothGroups() {
  const msg = "🧪 *ТЕСТ* — обе группы\n" + Utilities.formatDate(new Date(), "GMT+3", "dd.MM.yyyy HH:mm");
  const results = [];
  try {
    sendToTelegram(msg, CHAT_ID);
    results.push("Группа 1: OK");
  } catch (e) {
    results.push("Группа 1: " + e.toString());
  }
  const r2 = sendToTelegramWithMigrateCheck(msg, CHAT_ID_GROUP2);
  results.push(r2.ok ? "Группа 2: OK" : "Группа 2: " + r2.message);
  SpreadsheetApp.getUi().alert(results.join("\n"));
}
