#include <sourcemod>
#include <morecolors>

#pragma semicolon 1

g_iAccount = -1;
Handle Switch, Cash, Info;

public Plugin myinfo =
{
	name = "Extra Cash",
	author = "Peoples Army,babka68",
	description = "Деньги при спавне игрока.",
	version = "1.1",
	url = "www.sourcemod.net,www.tmb-css.ru"
};


public void OnPluginStart()
{
	LoadTranslations("extra_cash.phrases");
	g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	Switch = CreateConVar("extra_cash_on", "1", "1 - Плагин включен, 0 - Плагин выключен.", FCVAR_NOTIFY);
	Cash = CreateConVar("extra_cash_amount", "16000", "Устанавливает количество денег, выданных при спавне.", FCVAR_NOTIFY);
	Info = CreateConVar("extra_cash_chat_info", "1", "1 - Отображать информацию о выданных средствах, 0 - Не отображат.", FCVAR_NOTIFY);
	AutoExecConfig(true, "extra_cash");
	HookEvent("player_spawn", Event_Spawn_Player);
}

public Event_Spawn_Player(Handle event, const char[] name, bool dontBroadcast)
{
	int clientID = GetEventInt(event, "userid");
	int client = GetClientOfUserId(clientID);
	if (GetConVarInt(Switch))
	{
		SetMoney(client, GetConVarInt(Cash));
		if (GetConVarBool(Info))CPrintToChatAll("{lime}[Extra Cash] {fullred}%N {white} получил {yellow}%d$", client, GetConVarInt(Cash));
	}
}

public SetMoney(client, amount)
{
	if (g_iAccount != -1)
	{
		SetEntData(client, g_iAccount, amount);
	}
}
