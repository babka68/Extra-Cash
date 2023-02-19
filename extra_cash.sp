#include <sdktools_functions>
#include <cstrike>

/*=============================================================================================================
// EN: Notifies the compiler that there should be a character at the end of each expression ;
// RU: Сообщает компилятору о том, что в конце каждого выражения должен стоять символ ;
// =============================================================================================================*/

#pragma semicolon 1
/*=============================================================================================================
// EN: Notifies the compiler that the plugin syntax is exceptionally new
// RU: Сообщает компилятору о том, что синтаксис плагина исключительно новый
// =============================================================================================================*/

#pragma newdecls required

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
	
	/*=============================================================================================================
	// EN: Specifies that this configuration file should be executed after the plugin is loaded. along the cfg/sourcemod path.
	// RU: Указывает, что данный конфигурационный файл должен быть выполнен после загрузки плагина. по пути cfg/sourcemod.
	// =============================================================================================================*/
	AutoExecConfig(true, "extra_cash");
	
	/*=============================================================================================================
	// EN: Note: Player spawned in game
	// RU: Примечание: Игрок, созданный в игре
	// =============================================================================================================*/
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

/*=============================================================================================================
// EN: Note: Player spawned in game
// RU: Примечание: Игрок, созданный в игре
// =============================================================================================================*/

public void Event_Spawn(Event event, const char[] name, bool dontBroadcast)
{
	/*=============================================================================================================
	// EN: Create a local static integer variable and call it entity.
	// RU: Создаем локальную статическую целочисленную переменну и назовем её entity.
	// =============================================================================================================*/
	static int entity;
	
	/*=============================================================================================================
	// EN: GetClientOfUserId - Translates an userid index to the real player index.
	// RU: GetClientOfUserId - Преобразует индекс идентификатора пользователя в индекс реального игрока.
	// =============================================================================================================*/
	entity = GetClientOfUserId(event.GetInt("userid"));
	
	/*=============================================================================================================
	// EN: if (entity) > 0 - Check if there is a player on the server (that is, exclude the case when the index is 0)
	// EN: IsClientInGame(entity) - Check if there is a specific player on the server under the index in the range from 1 to MaxClients.
	// EN: IsFakeClient - Returns if a certain player is a fake client(Bot)
	// RU: if (entity) > 0 - Проверяем есть ли игрок на сервере (то есть исключаете случай, когда индекс равен 0)
	// RU: IsClientInGame(entity) - Проверяем, есть ли на сервере конкретный игрок под индексом в интервале от 1 до MaxClients.
	// RU: IsFakeClient - Возвращает, если определенный игрок является поддельным клиентом(Бот)
	// =============================================================================================================*/
	if ((entity) > 0 && IsClientInGame(entity) && !IsFakeClient(entity))
	{
		/*=============================================================================================================
		// EN: GetClientTeam - Extracts the index of the client's team into an integer local variable entity_team
		// RU: GetClientTeam - Извлекает индекс команды клиента в целочисленную локальную переменную entity_team
		//=============================================================================================================*/
		int entity_team = GetClientTeam(entity);
		
		/*=============================================================================================================
		// EN: entity_team > CS_TEAM_SPECTATOR - If the player's team is larger than the observer, then the player is in any of the ct or t teams
		// RU: entity_team > CS_TEAM_SPECTATOR - Если команда игрока больше наблюдателя, значит игрок находится в какой ли бо изщ команд кт или т
		//=============================================================================================================*/
		if (entity_team > CS_TEAM_SPECTATOR)
		{
			// Получить деньги игрока в целочисленную переменную cur_cash
			int cur_cash = GetEntData(entity, m_iAccount, 4);
			
			if (cur_cash)
			{
				/*=============================================================================================================
				// EN: GetTeamScore - returns the result of a command based on the index of the command. CS_TEAM_T(2) - terrorists, CS_TEAM_CT - counter-terrorists (3)
				// RU: GetTeamScore - возвращает результат команды на основе индекса команды. CS_TEAM_T(2) - террористы , CS_TEAM_CT - контер террористы (3)
				//=============================================================================================================*/
				int team_score_t = GetTeamScore(CS_TEAM_T);
				int team_score_ct = GetTeamScore(CS_TEAM_CT);
				
				SetEntData(entity, m_iAccount, (!team_score_t && !team_score_ct) ? g_iStart_Money : g_iAfter_Round_Money, _, true);
			}
		}
	}
}
