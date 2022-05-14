#include <sdktools_functions>

#pragma newdecls required
#pragma semicolon 1

// Offset
int g_iAccount = -1;

// ConVar 
int iAfter_Round_Money;

// Значение денег в первом раунде
int g_iStartMoney = 800;


public Plugin myinfo = 
{
	name = "Extra Cash", 
	version = "1.4.1", 
	description = "Выдача денег с 2 раунде", 
	author = "Peoples Army, babka68", 
	url = "https://vk.com/zakazserver68", 
};

public void OnPluginStart()
{
	g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	
	ConVar cvar;
	cvar = CreateConVar("extra_cash_amount", "16000", "Сумма денег, которую нужно дать каждому игроку в каждой команде после 1 рунда", _, true, 800.0, true, 16000.0);
	iAfter_Round_Money = cvar.IntValue;
	cvar.AddChangeHook(CVarChanged_Money);
	
	HookEvent("player_spawn", Event_Spawn);
}

public void CVarChanged_Money(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	iAfter_Round_Money = cvar.IntValue;
}

public void Event_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	// Если CT=0 : T=0 
	if (GetTeamScore(2) == 0 && GetTeamScore(3) == 0)
	{
		// g_iStartMoney = 800
		SetEntData(client, g_iAccount, g_iStartMoney);
	}
	
	// Иначе
	else
	{
		// iAfter_Round_Money = 16000
		SetEntData(client, g_iAccount, iAfter_Round_Money);
	}
} 
