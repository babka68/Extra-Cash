# Extra-Cash
Поддерживаемые игры:	CS: Source (OrangeBox)
Описание: Выдает игрокам деньги при спавне.
Настроить конфиг по пути /cfg/sourcemod/extra_cash.cfg создается при первом старте плагина,перевел на русский язык.
Оригинал: https://forums.alliedmods.net/showthread.php?p=513942

Требования:	
sourcemod
morecolors

Переменные:
// Устанавливает количество денег, выданных при спавне.
// -
// Default: "16000"
extra_cash_amount "16000"

// 1 - Отображать информацию о выданных средствах, 0 - Не отображат.
// -
// Default: "1"
extra_cash_chat_info "1"

// 1 - Плагин включен, 0 - Плагин выключен.
// -
// Default: "1"
extra_cash_on "1"

Установка:
1) Поместить Extra Cash.smx по пути \addons\sourcemod\plugins
2) (Не обязательно) Поместить Extra Cash.sp по пути \addons\sourcemod\scripting
3) Поместить extra_cash.phrases по пути \addons\sourcemod\translations
4) Перезапустить сервер
5) Настроить конфиг по пути /cfg/sourcemod/extra_cash.cfg создается при первом старте плагина.
6) Сменить карту,если были внесены изменения и наслаждаться работой плагина.
