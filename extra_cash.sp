#include <sdktools_functions>
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

// Offset 
// Баланс игрока
int m_iAccount = -1;

// ConVar 
// Значение денег в первом раунде
int g_iStart_Money;

// Значение денег после первого раунда
int g_iAfter_Round_Money;

public Plugin myinfo = 
{
	name = "Extra Cash", 
	version = "1.4.2", 
	description = "Выдача денег с 2 раунде", 
	author = "Peoples Army, babka68", 
	url = "https://vk.com/zakazserver68", 
};

public void OnPluginStart()
{
	m_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	if (m_iAccount < 1)
	{
		SetFailState("Couldnt find the m_iAccount offset!");
	}
	
	ConVar cvar;
	cvar = FindConVar("mp_startmoney"); // Найдем нашу переменную
	if (cvar == null) // Проверим существует ли она вообще
	{
		SetFailState("Can't find ConVar 'mp_startmoney'!");
	}
	
	cvar = CreateConVar("extra_cash_start_amount", "800", "Выдаваемая сумма всем игрокам в 1 раунде?", 0, true, 800.0, true, 16000.0);
	g_iStart_Money = cvar.IntValue;
	cvar.AddChangeHook(CVarChanged_Start_Money);
	
	cvar = CreateConVar("extra_cash_amount", "16000", "Сумма денег, которую нужно установить игроку после 1 рунда", _, true, 800.0, true, 16000.0);
	g_iAfter_Round_Money = cvar.IntValue;
	cvar.AddChangeHook(CVarChanged_After_Round_Money);
	
	AutoExecConfig(true, "extra_cash");
	
	HookEvent("player_spawn", Event_Spawn);
}

public void CVarChanged_Start_Money(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_iStart_Money = cvar.IntValue;
}

public void CVarChanged_After_Round_Money(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_iAfter_Round_Money = cvar.IntValue;
}

public void Event_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	static int entity;
	
	entity = GetClientOfUserId(event.GetInt("userid"));
	
	if (entity != 0)
	{
		int team = GetClientTeam(entity);
		
		if (!IsFakeClient(entity) && team > CS_TEAM_SPECTATOR)
		{
			// Получить деньги игрока в целочисленную переменную cur_cash
			int cur_cash = GetEntData(entity, m_iAccount, 4);
			
			if (cur_cash)
			{
				int team_score_t = GetTeamScore(CS_TEAM_T);
				int team_score_ct = GetTeamScore(CS_TEAM_CT);
				
				SetEntData(entity, m_iAccount, (!team_score_t && !team_score_ct) ? g_iStart_Money : g_iAfter_Round_Money, _, true);
			}
		}
	}
} 
