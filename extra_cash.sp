#pragma semicolon 1

#include <sourcemod>
#include <morecolors>

#pragma newdecls required

int 
g_iAccount = -1;
Handle 
Switch, 
Cash, 
Info;

public Plugin myinfo = 
{
	name = "Extra Cash", 
	author = "Peoples Army,babka68", 
	description = "Деньги при спавне игрока.", 
	version = "1.1", 
	url = "tmb-css.ru"
};


public void OnPluginStart()
{
	LoadTranslations("extra_cash.phrases");
	g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	Switch = CreateConVar("extra_cash_on", "1", "1 - Плагин включен, 0 - Плагин выключен.", _, true, -1.0);
	Cash = CreateConVar("extra_cash_amount", "16000", "Устанавливает количество денег, выданных при спавне.", _, true, -1.0);
	Info = CreateConVar("extra_cash_chat_info", "1", "1 - Отображать информацию о выданных средствах, 0 - Не отображат.", _, true, -1.0);
	AutoExecConfig(true, "extra_cash");
	HookEvent("player_spawn", Event_Spawn_Player);
}

public void Event_Spawn_Player(Handle event, const char[] name, bool dontBroadcast)
{
	int clientID = GetEventInt(event, "userid");
	int client = GetClientOfUserId(clientID);
	if (GetConVarInt(Switch))
	{
		SetMoney(client, GetConVarInt(Cash));
		if (GetConVarBool(Info))
		CPrintToChatAll("{lime}[Extra Cash] {fullred}%N {white} получил {yellow}%d$", client, GetConVarInt(Cash));
	}
}

public void SetMoney(int client, int args)
{
	if (g_iAccount != -1)
	{
		SetEntData(client, g_iAccount, args);
	}
}
