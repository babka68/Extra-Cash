#pragma semicolon 1
#include <sourcemod>
#include <morecolors>

#pragma newdecls required

int
	g_iAccount = -1,
	iMoney,
	iRound;
bool
	bEnable,
	bMsg,
	bLock[MAXPLAYERS+1] = {true, ...},
	lock;

int cwAutoSwapTeamType;

public Plugin myinfo = 
{
	name = "Extra Cash",
	version = "1.3",
	description = "Деньги при спавне игрока.",
	author = "Peoples Army, babka68",
	url = "tmb-css.ru"
}

public void OnPluginStart()
{
	if((g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount")) < 1)
		SetFailState("Can't find 'm_iAccount' offset!");

	LoadTranslations("extra_cash.phrases");

	ConVar cvar;
	cvar = CreateConVar("extra_cash_on", "1", "1 - Плагин включен, 0 - Плагин выключен.", _, true, _, true, 1.0);
	bEnable = cvar.BoolValue;
	cvar.AddChangeHook(CVarChanged_Enable);

	cvar = CreateConVar("extra_cash_amount", "16000", "Устанавливает количество денег, выданных при спавне.", _, true, 800.0, true, 16000.0);
	iMoney = cvar.IntValue;
	cvar.AddChangeHook(CVarChanged_Money);

	cvar = CreateConVar("extra_cash_chat_info", "1", "1 - отображать информацию о выданных средствах, 0 - не отображать.", _, true, 0.0, true, 1.0);
	bMsg = cvar.BoolValue;
	cvar.AddChangeHook(CVarChanged_Msg);

	if((cvar = FindConVar("sm_autoswapteam_type")))
	{
		cwAutoSwapTeamType = cvar.IntValue;
		cvar.AddChangeHook(CVarChanged_AutoSwapTeamType);	
	}

	HookEvent("player_team", Event_Team);
	HookEvent("player_spawn", Event_Spawn);
	HookEvent("round_end", Event_End, EventHookMode_PostNoCopy);

	AutoExecConfig(true, "extra_cash");
}

public void CVarChanged_AutoSwapTeamType(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	cwAutoSwapTeamType = cvar.IntValue;
}

public void CVarChanged_Enable(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	bEnable = cvar.BoolValue;
}

public void CVarChanged_Money(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	iMoney = cvar.IntValue;
}

public void CVarChanged_Msg(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	bMsg = cvar.BoolValue;
}

public void OnMapStart()
{
	iRound = 0;
	lock = false;
	for(int i = 1; i <= MaxClients; i++) bLock[i] = true;
}

public void OnClientConnected(int client)
{
	bLock[client] = true;
}

public void Event_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!client || GetClientTeam(client) < 2)
		return;

	if(bLock[client])
	{
		bLock[client] = false;
		return;
	}

	if(!bEnable || iRound < 1)
		return;

	SetEntData(client, g_iAccount, iMoney);
	if(bMsg) CPrintToChatAll("{lime}[Extra Cash] {fullred}%N {white} получил {yellow}%d$", client, iMoney);
}

public void Event_Team(Event event, const char[] name, bool dontBroadcast)
{
	if(event.GetBool("disconnect"))
		return;

	static int client;
	if((client = GetClientOfUserId(event.GetInt("userid"))) && event.GetInt("team") != event.GetInt("oldteam"))
		bLock[client] = true;
}

public void Event_End(Event event, const char[] name, bool silent)
{
	iRound++;
	if(lock) return;

	if(cwAutoSwapTeamType == 1)
	{
		int timelimit = GetMapTimeLimit(timelimit), timeleft = GetMapTimeLeft(timeleft);
		if(0 < timelimit && 0 < timeleft && timeleft/60 <= timelimit/2)
		{
			lock = true;
			iRound = 1;
		}
	}
}
