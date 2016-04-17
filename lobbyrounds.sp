#pragma semicolon 1
#include <sourcemod>
//#include <updater>
//#include <socket>


#define PLUGIN_VERSION "1.0"

//#define MAX_URL_LENGTH 256
//#define UPDATE_URL "http://miggthulu.com"

public Plugin:myinfo =
{
	name 		= "LobbyRounds",
	author 		= "Miggy",
	description = "Changes Round Win limit when playing lobbies",
	version		= PLUGIN_VERSION,
	url 		= "miggthulu.com"
};


//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------


new Handle:g_hCPLobby;
new bool:g_bCPLobby;

new Handle:g_hKOTHLobby;
new bool:g_bKOTHLobby;


//------------------------------------------------------------------------------
// Startup
//------------------------------------------------------------------------------


public OnPluginStart()
{		
	g_hCPLobby = CreateConVar("sm_CPRounds", "0", "Enable CPLobby Rounds?(As if you'd want if off)\n0 = Disabled\n1 = Enabled", FCVAR_NONE, true, 0.0, true, 1.0);
	g_bCPLobby = GetConVarBool(g_hCPLobby);
	HookConVarChange(g_hCPLobby, OnConVarChange);
	
	
	g_hKOTHLobby = CreateConVar("sm_KOTHRounds", "0", "Enable KOTHLobby Rounds?(As if you'd want if off)\n0 = Disabled\n1 = Enabled", FCVAR_NONE, true, 0.0, true, 1.0);
	g_bKOTHLobby = GetConVarBool(g_hKOTHLobby);
	HookConVarChange(g_hKOTHLobby, OnConVarChange);
	
	
	RegAdminCmd("sm_CPLobby", CPCmd, ADMFLAG_GENERIC, "Turns on CPLobby Rounds");
	RegAdminCmd("sm_cplobby", CPCmd, ADMFLAG_GENERIC, "Turns on CPLobby Rounds");  //Convenience Command
	
	RegAdminCmd("sm_KOTHLobby", KOTHCmd, ADMFLAG_GENERIC, "Turns on KOTHLobby ROunds");	
	RegAdminCmd("sm_kothlobby", KOTHCmd, ADMFLAG_GENERIC, "Turns on KOTHLobby ROunds");	 //Convenience Command
}


//------------------------------------------------------------------------------
// On CVAR Change
//------------------------------------------------------------------------------


public OnConVarChange(Handle:convar, const String:oldValue[], const String:newValue[])
{
	//Detects if CPLobby is Enabled
	if(convar == g_hCPLobby)
	{
		SetConVarBool(g_hCPLobby, bool:StringToInt(newValue), true, false);
		g_bCPLobby = GetConVarBool(g_hCPLobby);
	}
		
	if(!g_bCPLobby)
	{
		PrintToChatAll("[SM] CPLobby: Disabled");
		ServerCommand("mp_winlimit 4");
	}
	else
	{
        PrintToChatAll("[SM] CPLobby: Enabled");
		ServerCommand("mp_winlimit 5");
	}

	
	//Detects if KOTHLobby is Enabled
	if(convar == g_hKOTHLobby)
	{
		SetConVarBool(g_hKOTHLobby, bool:StringToInt(newValue), true, false);
		g_bKOTHLobby = GetConVarBool(g_hKOTHLobby);
	}
		
	if(!g_bKOTHLobby)
	{
		PrintToChatAll("[SM] KothLobby: Disabled");
		ServerCommand("mp_winlimit 3");
	}
	else
	{
        PrintToChatAll("[SM] KothLobby: Enabled");
		ServerCommand("mp_winlimit 4");
	}
	
		
}

//------------------------------------------------------------------------------
// On !CPLobby Command
//------------------------------------------------------------------------------


public Action:CPCmd(client, args)
{
	
	if(args > 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_CPLobby [0/1]");
		return Plugin_Handled;
	}
	
	if(args == 0)
	{
		SetConVarBool(g_hCPLobby, !GetConVarBool(g_hCPLobby), true, false);
		g_bCPLobby = !g_bCPLobby;
		return Plugin_Handled;
	}
	
	new String:arg1[16];
	GetCmdArg(1, arg1, 16);
	new arg = StringToInt(arg1);
	
	if(arg > 1 || arg < 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_CPLobby [0/1]");
		return Plugin_Handled;
	}
	
	if(arg == 1)
	{
		if(GetConVarBool(g_hCPLobby))
		{
			ReplyToCommand(client, "[SM] CPLobby is already Enabled.");
			return Plugin_Handled;
		}
		
		SetConVarBool(g_hCPLobby, bool:arg, true, false);
	}
	
	else if(arg == 0)
	{
		if(!GetConVarBool(g_hCPLobby))
		{
			ReplyToCommand(client, "[SM] CPLobby is already disabled.");
			return Plugin_Handled;
		}
		
		SetConVarBool(g_hCPLobby, bool:arg, true, false);
	}
	
	return Plugin_Handled;
}


//------------------------------------------------------------------------------
// On !KothLobby Command
//------------------------------------------------------------------------------


public Action:KOTHCmd(client, args)
{
	
	if(args > 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_KOTHLobby [0/1]");
		return Plugin_Handled;
	}
	
	if(args == 0)
	{
		SetConVarBool(g_hKOTHLobby, !GetConVarBool(g_hKOTHLobby), true, false);
		g_bKOTHLobby = !g_bKOTHLobby;
		return Plugin_Handled;
	}
	
	new String:arg1[16];
	GetCmdArg(1, arg1, 16);
	new arg = StringToInt(arg1);
	
	if(arg > 1 || arg < 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_KOTHLobby [0/1]");
		return Plugin_Handled;
	}
	
	if(arg == 1)
	{
		if(GetConVarBool(g_hKOTHLobby))
		{
			ReplyToCommand(client, "[SM] KOTHLobby is already Enabled.");
			return Plugin_Handled;
		}
		
		SetConVarBool(g_hKOTHLobby, bool:arg, true, false);
	}
	
	else if(arg == 0)
	{
		if(!GetConVarBool(g_hKOTHLobby))
		{
			ReplyToCommand(client, "[SM] KOTHLobby is already disabled.");
			return Plugin_Handled;
		}
		
		SetConVarBool(g_hKOTHLobby, bool:arg, true, false);
	}
	
	return Plugin_Handled;
}
