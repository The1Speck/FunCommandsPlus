#include <sourcemod>
#include <sdktools>
 
#define PLUGIN_VERSION "1.4.0"
 
 new g_CollisionOffset;
 
public Plugin:myinfo =
{
    name = "FunCommands+",
    author = "The1Speck",
    description = "For SuperAdmins on Tango's servers. Requires Custom3 perm",
    version = PLUGIN_VERSION,
    url = "http://www.tangoworldwide.net"
}

public OnPluginStart()
{
	g_CollisionOffset = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_color", cmd_Color, ADMFLAG_CUSTOM3, "Changes a player's color");
	RegAdminCmd("sm_rgbcolor", cmd_RgbColor, ADMFLAG_CUSTOM3, "Changes a player's color using rgb values");
	RegAdminCmd("sm_splitcolor", cmd_SplitColor, ADMFLAG_CUSTOM3, "Splits target into 2 colors (yellow, green)");
	RegAdminCmd("sm_randcolor", cmd_RandomColor, ADMFLAG_CUSTOM3, "Sets targets to random colors");
	RegAdminCmd("sm_tp", cmd_Tp, ADMFLAG_CUSTOM3, "Teleports one player to another. Put 1 argument for self-tp");
	RegAdminCmd("sm_tpaim", cmd_TpAim, ADMFLAG_CUSTOM3, "Teleports player to your aim. Put no argument for self-tp");
	RegAdminCmd("sm_tphere", cmd_TpHere, ADMFLAG_CUSTOM3, "Teleports a player to you");
}

public Action:cmd_Color(client, args)
{
	new String:arg1[MAX_TARGET_LENGTH], String:arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	if(args == 2 && GetCmdArg(2, arg2, sizeof(arg2)))
	{
		new String:target_name[MAX_TARGET_LENGTH];
		new target_list[MAXPLAYERS], target_count;
		new bool:tn_is_ml;
		new String:color[10] = "na";
		
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
public Action:cmd_RgbColor(client, args)
{
	new String:arg1[MAX_NAME_LENGTH], String:arg2[32], String:arg3[32], String:arg4[32];
		
	if(args == 4 && GetCmdArg(1, arg1, sizeof(arg1)) && GetCmdArg(2, arg2, sizeof(arg2)) && GetCmdArg(3, arg3, sizeof(arg3)) && GetCmdArg(4, arg4, sizeof(arg4)))
	{
		new r = StringToInt(arg2);
		new g = StringToInt(arg3);
		new b = StringToInt(arg4);
		
		if(r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255 )
		{
			ReplyToCommand(client, "[SM] Usage: sm_rgbcolor <#userid|name> <0-255> <0-255> <0-255>");
			return Plugin_Handled;
		}		
		new String:target_name[MAX_TARGET_LENGTH];
		new target_list[MAXPLAYERS], target_count;
		new bool:tn_is_ml;
		
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

public Action:cmd_SplitColor(client, args)
{
	new String:arg1[MAX_NAME_LENGTH];
		
	if(args == 1 && GetCmdArg(1, arg1, sizeof(arg1)))
	{
		
		new String:target_name[MAX_TARGET_LENGTH];
		new target_list[MAXPLAYERS], target_count;
		new bool:tn_is_ml;
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		
		new splitPoint = target_count / 2;
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

public Action:cmd_RandomColor(client, args)
{
	new String:arg1[MAX_NAME_LENGTH];
		
	if(args == 1 && GetCmdArg(1, arg1, sizeof(arg1)))
	{
		new String:target_name[MAX_TARGET_LENGTH];
		new target_list[MAXPLAYERS], target_count;
		new bool:tn_is_ml;
		
		if ((target_count = ProcessTargetString(arg1, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}
		
		for (new i = 0; i < target_count; i++)
		{
			new randColor = GetRandomInt(1, 6);
			
			if(randColor == 1)
			{
				SetEntityRenderColor(target_list[i], 255, 0, 0, 255);
			}
			else if(randColor == 2)
			{
				SetEntityRenderColor(target_list[i], 0, 255, 0, 255);
			}
			else if(randColor == 3)
			{
				SetEntityRenderColor(target_list[i], 0, 0, 255, 255);
			}
			else if(randColor == 4)
			{
				SetEntityRenderColor(target_list[i], 255, 255, 0, 255);
			}
			else if(randColor == 5)
			{
				SetEntityRenderColor(target_list[i], 255, 102, 0, 255);
			}
			else if(randColor == 6)
			{
				SetEntityRenderColor(target_list[i], 255, 0, 255, 255);
			}
			
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

public Action:cmd_Tp(client, args)
{
	if (args == 0){
		ReplyToCommand(client, "[SM] This command requires a target.");
	}else if(args == 1)
	{
		new String:arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		performTp(client, client, FindTarget(client, arg0));
	} else if(args == 2)
	{
		new String:arg0[MAX_NAME_LENGTH];
		new String:arg1[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		GetCmdArg(2, arg1, sizeof(arg1));
		performTp(client, FindTarget(client, arg0), FindTarget(client, arg1));
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tp <#userid|name> [#userid|name]");
		
	}
	return Plugin_Handled;
}

public Action:cmd_TpHere(client, args)
{
	if(args == 1)
	{
		new String:arg0[MAX_NAME_LENGTH];
		GetCmdArg(1, arg0, sizeof(arg0));
		performTp(client, FindTarget(client, arg0), client);
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tphere <#userid|name>");
	}
	return Plugin_Handled;
}

public performTp(admin, client0, client1)
{
	new Float:pos[3];
	new coll0 = GetEntData(client0, g_CollisionOffset, 4); //get original collision
	new coll1 = GetEntData(client1, g_CollisionOffset, 4);
	GetClientAbsOrigin(client1, pos);
	TeleportEntity(client0, pos, NULL_VECTOR, NULL_VECTOR);
	SetEntData(client0, g_CollisionOffset, 17, 4, true);
	SetEntData(client1, g_CollisionOffset, 17, 4, true);
	pos[2] += 10;
	TeleportEntity(client0, pos, NULL_VECTOR, NULL_VECTOR);
	new Handle:tmrDataPack;
	CreateDataTimer(0.5, becomeSolid, tmrDataPack);
	WritePackCell(tmrDataPack, admin);
	WritePackCell(tmrDataPack, client0);
	WritePackCell(tmrDataPack, client1);
	WritePackCell(tmrDataPack, coll0);
	WritePackCell(tmrDataPack, coll1);
}

public Action:becomeSolid(Handle:timer, Handle:tmrDataPack)
{
	ResetPack(tmrDataPack);
	new admin = ReadPackCell(tmrDataPack);
	new client0 = ReadPackCell(tmrDataPack);
	new client1 = ReadPackCell(tmrDataPack);
	new coll0 = ReadPackCell(tmrDataPack)
	new coll1 = ReadPackCell(tmrDataPack)
	SetEntData(client0, g_CollisionOffset, coll0, 4, true); //set back to original collision
	SetEntData(client1, g_CollisionOffset, coll1, 4, true);
	ShowActivity2(admin, "[SM] ", "Teleported %N to %N.", client0, client1);
	LogAction(admin, client0, "%L Teleported %N to %N.", client0, client1);
	return Plugin_Handled;
}

public bool:TraceRayDontHitSelf(entity, mask, any:data)
{
	if(entity == data) // Check if the TraceRay hit the itself.
	{
		return false; // Don't let the entity be hit
	}
	return true; // It didn't hit itself
}

public Action:cmd_TpAim(client, args)
{	
	new Float:pos[3];
	new Float:clientEyePos[3];
	new Float:clientEyeAngle[3];
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
		LogAction(client, -1, "Teleported %N to %N's cursor.", client, client);
	} else if(args == 1)
	{
		new String:buf[MAX_NAME_LENGTH];
		GetCmdArg(1, buf, sizeof(buf));
		new iTarget = FindTarget(client, buf);
		TeleportEntity(iTarget, pos, NULL_VECTOR, NULL_VECTOR);
		ShowActivity2(client, "[SM] ", "Teleported %N to %N's cursor.", iTarget, client);
		LogAction(client, iTarget, "Teleported %N to %N's cursor.", iTarget, client);
	} else {
		ReplyToCommand(client, "[SM] Usage: sm_tpaim [#userid|name]");
	}
}
