#pragma semicolon 1
#include <sdktools>
#pragma newdecls required

int g_iAccount = -1, iMoney, iMoneyDef = 800;

public Plugin myinfo = 
{
	name = "Extra Cash", 
	version = "1.4", 
	description = "Выдача денег во 2 раунде", 
	author = "Peoples Army, babka68", 
	url = "tmb-css.ru", 
};

public void OnPluginStart()
{
	g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	
	ConVar cvar;
	cvar = CreateConVar("extra_cash_amount", "16000", "Устанавливает количество денег, выданных во 2 раунде", _, true, 800.0, true, 16000.0);
	iMoney = cvar.IntValue;
	cvar.AddChangeHook(CVarChanged_Money);
	
	HookEvent("player_spawn", Event_Spawn);
}

public void CVarChanged_Money(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	iMoney = cvar.IntValue;
}

public void Event_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (GetTeamScore(2) == 0 && GetTeamScore(3) == 0) // Если CT=0 : T=0 
	{
		SetEntData(client, g_iAccount, iMoneyDef); // 800
	}
	
	else // Иначе
	{
		SetEntData(client, g_iAccount, iMoney); // 16000
	}
}
