#include <sourcemod>
#include <sdktools>
 
#define PLUGIN_VERSION "2.0.0"
 
public Plugin myinfo =
{
    name = "FunCommands+",
    author = "The1Speck",
    description = "For SuperAdmins on Tango's servers. Requires Custom3 perm",
    version = PLUGIN_VERSION,
    url = "https://github.com/The1Speck/FunCommandsPlus"
}

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_color", cmd_Color, ADMFLAG_CUSTOM3, "Changes a player's color");
	RegAdminCmd("sm_rgbcolor", cmd_RgbColor, ADMFLAG_CUSTOM3, "Changes a player's color using rgb values");
	RegAdminCmd("sm_splitcolor", cmd_SplitColor, ADMFLAG_CUSTOM3, "Splits target into 2 colors (yellow, green)");
	RegAdminCmd("sm_randcolor", cmd_RandomColor, ADMFLAG_CUSTOM3, "Sets targets to random colors");
	RegAdminCmd("sm_tp", cmd_Tp, ADMFLAG_CUSTOM3, "Teleports one player to another. Put 1 argument for self-tp");
	RegAdminCmd("sm_tpaim", cmd_TpAim, ADMFLAG_CUSTOM3, "Teleports player to your aim. Put no argument for self-tp");
	RegAdminCmd("sm_tphere", cmd_TpHere, ADMFLAG_CUSTOM3, "Teleports a player to you");
	RegAdminCmd("sm_heal", cmd_Heal, ADMFLAG_CUSTOM3, "Heals a player to full health");
	RegAdminCmd("sm_sethealth", cmd_SetHealth, ADMFLAG_CUSTOM5, "Sets a player's health");
}

public Action cmd_Color(int client, int args)
{
	char arg1[MAX_TARGET_LENGTH], arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	if(args == 2 && GetCmdArg(2, arg2, sizeof(arg2)))
	{
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		char color[10] = "na";
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		if(StrEqual(arg2, "red", false))
		{
			color = "red";
			for(new i = 0; i < target_count; i++)
			{
				SetEntityRenderColor(target_list[i], 255, 0, 0, 255);
				LogAction(client, target_list[i], "%L changed the color of %L to %s.", client, target_list[i], color);
			}
		} else if(StrEqual(arg2, "green", false))
		{
			color = "green";
			for(new i = 0; i < target_count; i++)
			{
				SetEntityRenderColor(target_list[i], 0, 255, 0, 255);
				LogAction(client, target_list[i], "%L changed the color of %L to %s.", client, target_list[i], color);
			}
		} else if(StrEqual(arg2, "blue", false))
		{
			color = "blue";
			for(new i = 0; i < target_count; i++)
			{
				SetEntityRenderColor(target_list[i], 0, 0, 255, 255);
				LogAction(client, target_list[i], "%L changed the color of %L to %s.", client, target_list[i], color);
			}
		} else if(StrEqual(arg2, "yellow", false))
		{
			color = "yellow";
			for(new i = 0; i < target_count; i++)
			{
				SetEntityRenderColor(target_list[i], 255, 255, 0, 255);
				LogAction(client, target_list[i], "%L changed the color of %L to %s.", client, target_list[i], color);
			}
		} else if(StrEqual(arg2, "none", false))
		{
			color = "none";
			for(new i = 0; i < target_count; i++)
			{
				SetEntityRenderColor(target_list[i], 255, 255, 255, 255);
				LogAction(client, target_list[i], "%L changed the color of %L to %s.", client, target_list[i], color);
			}
		} else {
			ReplyToCommand(client, "[SM] Usage: sm_color <#userid|name> <red|green|blue|yellow|none>");
		}
		
		if (tn_is_ml && !StrEqual(color, "na")){
			ShowActivity2(client, "[SM] ", "Changed the color of %t to %s.", target_name, color);
		} else if (!StrEqual(color, "na")){
			ShowActivity2(client, "[SM] ", "Changed the color of %s to %s.", target_name, color);
		}
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_color <#userid|name> <red|green|blue|yellow|none>");
	}
	return Plugin_Handled;
}
public Action cmd_RgbColor(int client, int args)
{
	char arg1[MAX_NAME_LENGTH], arg2[32], arg3[32],arg4[32];
		
	if(args == 4 && GetCmdArg(1, arg1, sizeof(arg1)) && GetCmdArg(2, arg2, sizeof(arg2)) && GetCmdArg(3, arg3, sizeof(arg3)) && GetCmdArg(4, arg4, sizeof(arg4)))
	{
		int r = StringToInt(arg2);
		int g = StringToInt(arg3);
		int b = StringToInt(arg4);
		
		if(r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255 )
		{
			ReplyToCommand(client, "[SM] Usage: sm_rgbcolor <#userid|name> <0-255> <0-255> <0-255>");
			return Plugin_Handled;
		}		
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		
		for (new i = 0; i < target_count; i++)
		{
			SetEntityRenderColor(target_list[i], r, g, b, 255);
			LogAction(client, target_list[i], "%L changed the color of %L to RGB values %i %i %i.", client, target_list[i], r, g, b);
		}
		
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Changed the color of %t to %d %d %d.", target_name, r, g, b);
		} else {
			ShowActivity2(client, "[SM] ", "Changed the color of %s to %d %d %d.", target_name, r, g, b);
		}
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_rgbcolor <#userid|name> <0-255> <0-255> <0-255>");
	}
	return Plugin_Handled;
}
public Action cmd_SplitColor(int client, int args)
{
	char arg1[MAX_NAME_LENGTH];
		
	if(args == 1 && GetCmdArg(1, arg1, sizeof(arg1)))
	{
		
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		
		int splitPoint = target_count / 2;
		for (new i = 0; i < target_count; i++)
		{
			if(i <= splitPoint)
			{
				SetEntityRenderColor(target_list[i], 0, 255, 0, 255);
			}
			else
			{
				SetEntityRenderColor(target_list[i], 255, 255, 0, 255);
			}
			LogAction(client, target_list[i], "%L changed the color of %L a split color.", client, target_list[i]);
		}
		
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Changed the color of %t to a split color.", target_name);
		} else {
			ShowActivity2(client, "[SM] ", "Changed the color of %s to a split color.", target_name);
		}
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_splitcolor <@t|@ct|@all|@alive>");
	}
	return Plugin_Handled;
}
public Action cmd_RandomColor(int client, int args)
{
	char arg1[MAX_NAME_LENGTH];
		
	if(args == 1 && GetCmdArg(1, arg1, sizeof(arg1)))
	{
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		
		for (new i = 0; i < target_count; i++)
		{
			int randColor = GetRandomInt(1, 6);
			
			if(randColor == 1)
				SetEntityRenderColor(target_list[i], 255, 0, 0, 255);
			else if(randColor == 2)
				SetEntityRenderColor(target_list[i], 0, 255, 0, 255);
			else if(randColor == 3)
				SetEntityRenderColor(target_list[i], 0, 0, 255, 255);
			else if(randColor == 4)
				SetEntityRenderColor(target_list[i], 255, 255, 0, 255);
			else if(randColor == 5)
				SetEntityRenderColor(target_list[i], 255, 102, 0, 255);
			else if(randColor == 6)
				SetEntityRenderColor(target_list[i], 255, 0, 255, 255);
			
			LogAction(client, target_list[i], "%L changed the color of %L a random color.", client, target_list[i]);
		}
		
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Changed the color of %t to a random color.", target_name);
		} else {
			ShowActivity2(client, "[SM] ", "Changed the color of %s to a random color.", target_name);
		}
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_randcolor <@t|@ct|@all|@alive>");
	}
	return Plugin_Handled;
}

public Action cmd_Tp(int client, int args)
{	
	float pos[3];
	if (args == 0){
		ReplyToCommand(client, "[SM] This command requires a target.");
	}else if(args == 1)
	{
		char arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		int target = FindTarget(client, arg0, false, false);
		GetClientAbsOrigin(target, pos);
		TeleportEntity(client, pos, NULL_VECTOR, NULL_VECTOR);
		
		ShowActivity2(client, "[SM] ", "Teleported %N to %N.", client, target);
		LogAction(client, target, "%L Teleported %N to %N.", client, client, target);
		return Plugin_Handled;
	} else if(args == 2)
	{
		char arg0[MAX_NAME_LENGTH];
		char arg1[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		GetCmdArg(2, arg1, sizeof(arg1));
		char target_name1[MAX_TARGET_LENGTH];
		char target_name2[MAX_TARGET_LENGTH];
		int target_list1[MAXPLAYERS], target_count1;
		int target_list2[MAXPLAYERS], target_count2;
		bool tn_is_ml;
		
		//DESTINATION
		if ((target_count1 = ProcessTargetString(arg1, client, target_list1, MAXPLAYERS, COMMAND_FILTER_NO_MULTI, target_name1, sizeof(target_name1), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count1);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count1; i++)
		{
			GetClientAbsOrigin(target_list1[i], pos);
		}
		
		//TRANSPORTEE
		if ((target_count2 = ProcessTargetString(arg0, client, target_list2, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name2, sizeof(target_name2), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count2);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count2; i++)
		{
			TeleportEntity(target_list2[i], pos, NULL_VECTOR, NULL_VECTOR);
			LogAction(client, target_list2[i], "%L teleported %L to %L", client, target_list1[i], target_list2[i]);
		}
 
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Teleported %t to %t.", target_name2, target_name1);
		} else {
			ShowActivity2(client, "[SM] ", "Teleported %s to %s.", target_name2, target_name1);
		}
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tp <#userid|name> [#userid|name]");
	}
	return Plugin_Handled;
}

public Action cmd_TpHere(int client, int args)
{
	if(args == 1)
	{
		float pos[3];
		char target_name1[MAX_TARGET_LENGTH];
		int target_list1[MAXPLAYERS], target_count1;
		bool tn_is_ml;
		char arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		GetClientAbsOrigin(client, pos);
		
		if ((target_count1 = ProcessTargetString(arg0, client, target_list1, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name1, sizeof(target_name1), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count1);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count1; i++)
		{
			TeleportEntity(target_list1[i], pos, NULL_VECTOR, NULL_VECTOR);
			LogAction(client, target_list1[i], "Teleported %L to %L's cursor.", target_list1[i], client);
		}
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Teleported %t to %N.", target_name1, client);
		} else {
			ShowActivity2(client, "[SM] ", "Teleported %s to %N.", target_name1, client);
		}
		
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tphere <#userid|name>");
	}
	return Plugin_Handled;
}

public Action cmd_TpAim(int client, int args)
{	
	float pos[3];
	float clientEyePos[3];
	float clientEyeAngle[3];
	GetClientEyePosition(client, clientEyePos);
	GetClientEyeAngles(client, clientEyeAngle);
	TR_TraceRayFilter(clientEyePos, clientEyeAngle, MASK_SOLID, RayType_Infinite, TraceRayDontHitSelf, client);
	if(TR_DidHit(INVALID_HANDLE))
	{
		TR_GetEndPosition(pos);
	}
	pos[2]+= 10;
	
	if(args == 0)
	{
		TeleportEntity(client, pos, NULL_VECTOR, NULL_VECTOR);
		ShowActivity2(client, "[SM] ", "Teleported %N to %N's cursor.", client, client);
		LogAction(client, -1, "Teleported %L to %L's cursor.", client, client);
		return Plugin_Handled;
	} else if(args == 1)
	{
		char target_name1[MAX_TARGET_LENGTH];
		int target_list1[MAXPLAYERS], target_count1;
		bool tn_is_ml;
		char arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		
		if ((target_count1 = ProcessTargetString(arg0, client, target_list1, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name1, sizeof(target_name1), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count1);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count1; i++)
		{
			TeleportEntity(target_list1[i], pos, NULL_VECTOR, NULL_VECTOR);
			LogAction(client, target_list1[i], "Teleported %L to %L's cursor.", target_list1[i], client);
		}
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "Teleported %t to %N's cursor.", target_name1, client);
		} else {
			ShowActivity2(client, "[SM] ", "Teleported %s to %N's cursor.", target_name1, client);
		}
		return Plugin_Handled;
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tpaim [#userid|name]");
		return Plugin_Handled;
	}
}

public Action cmd_Heal(int client, int args)
{
	if(args == 0)
	{
		SetEntityHealth(client, 100);
		ShowActivity2(client, "[SM] ", "Healed %N.", client, client);
		LogAction(client, -1, "Healed %N.", client);
	} else if(args == 1)
	{
		char arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		if ((target_count = ProcessTargetString(arg0, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count; i++)
		{
			if(GetClientHealth(target_list[i]) < 100)
				SetEntityHealth(target_list[i], 100);
			LogAction(client, target_list[i], "%L healed %L", client, target_list[i]);
		}
		if (tn_is_ml)
			ShowActivity2(client, "[SM] ", "Healed %t.", target_name);
		else
			ShowActivity2(client, "[SM] ", "Healed %s.", target_name);
		return Plugin_Handled;
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_heal [#userid|name]");
	}
	return Plugin_Handled;
}

public Action cmd_SetHealth(int client, int args)
{
	if(args == 2)
	{
		char arg0[MAX_NAME_LENGTH];
		char arg1[32];
		int amount;
		GetCmdArg(1, arg0, sizeof(arg0));
		GetCmdArg(2, arg1, sizeof(arg1));
		char target_name[MAX_TARGET_LENGTH];
		amount = StringToInt(arg1);
		if(amount > 9999 || amount < 1)
		{
			ReplyToCommand(client, "[SM] Acceptable health range is 1-9999!");
			return Plugin_Handled;
		}
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		if ((target_count = ProcessTargetString(arg0, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		for (int i = 0; i < target_count; i++)
		{
			SetEntityHealth(target_list[i], amount);
			LogAction(client, target_list[i], "%L set %L's health to %d.", client, target_list[i], amount);
		}
		if (tn_is_ml)
			ShowActivity2(client, "[SM] ", "Set %t's health.", target_name);
		else
			ShowActivity2(client, "[SM] ", "Set %s's health.", target_name);
		return Plugin_Handled;
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_sethealth <#userid|name> <health>");
		return Plugin_Handled;
	}
	
}

public bool TraceRayDontHitSelf(int entity, int mask, int data)
{
	if(entity == data) // Check if the TraceRay hit the itself.
	{
		return false; // Don't let the entity be hit
	}
	return true; // It didn't hit itself
}
