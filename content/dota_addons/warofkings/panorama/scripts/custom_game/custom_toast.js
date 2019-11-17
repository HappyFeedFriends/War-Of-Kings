function IsDev(id){
	return Game.GetPlayerInfo(id).player_steamid == 76561198271575954;
}
/*
	thank you ark120202 for the well-written code. Link to his mod below:
	https://steamcommunity.com/sharedfiles/filedetails/?id=699441891
	{Modification Code author: HappyFeedFriends}
*/
function CreateHeroElements(id) {
	var playerColor = GetHEXPlayerColor(id);
	return "<img class='CombatEventHeroIcon'/> <font color='" + playerColor + "'>"  + Players.GetPlayerName(id) + '</font>';
}

function RuneElement(RuneType)
{
	return "<img src='" + TransformTextureToPath(RuneType, 'Rune') + "' class='CombatEventHeroIcon'/>";
}

function CreateCustomToast(data) {
	var row = $.CreatePanel('Panel', $('#CustomToastManager'), '');
	row.BLoadLayoutSnippet('ToastPanel');
	row.AddClass('ToastPanel');
	var rowText = '';

	if (data.type === 'kill') {
		var byNeutrals = data.killerPlayer == null;
		var isSelfKill = data.victimPlayer === data.killerPlayer; 
		var isAllyKill = !byNeutrals && data.victimPlayer != null && Players.GetTeam(data.victimPlayer) === Players.GetTeam(data.killerPlayer); // Если не нейтрал и умерающий есть и команда умершего равна команде убийцы то true,иначе false
		var isVictim = data.victimPlayer === Game.GetLocalPlayerID();
		var isKiller = data.killerPlayer === Game.GetLocalPlayerID();
		var teamVictim = byNeutrals || Players.GetTeam(data.victimPlayer) === Players.GetTeam(Game.GetLocalPlayerID());	 // Если нейтрал или команда умершего из моей команды,то равно true, иначе false
		var teamKiller = !byNeutrals && Players.GetTeam(data.killerPlayer) === Players.GetTeam(Game.GetLocalPlayerID()); // Не нейтрал,то если убийца из моей команды,то равно true,иначе false
		row.SetHasClass('AllyEvent', teamKiller);
		row.SetHasClass('EnemyEvent', byNeutrals || !teamKiller);
		row.SetHasClass('LocalPlayerInvolved', isVictim || isKiller);
		row.SetHasClass('LocalPlayerKiller', isKiller);
		row.SetHasClass('LocalPlayerVictim', isVictim);
		Game.EmitSound(isKiller && 'notification.self.kill' || 
		isVictim && 'notification.self.death' ||
		teamKiller && 'notification.teammate.kill' ||
		teamVictim && 'notification.teammate.death');
		if (isSelfKill) {
			Game.EmitSound('notification.self.kill');
			rowText = $.Localize('custom_toast_PlayerDeniedSelf');
		} else if (isAllyKill) {
			rowText = $.Localize('#custom_toast_PlayerDenied');
		} else {
		rowText = (byNeutrals && $.Localize('#npc_dota_neutral_creep') || '{killer_name}') +  '{killed_icon} {victim_name}' + (data.gold && ' {gold}' || "");
		}
	} else if (data.type === 'generic') {
		if (data.teamPlayer != null || data.teamColor != null) {
			var team = data.teamPlayer == null ? data.teamColor : Players.GetTeam(data.teamPlayer);
			var teamVictim = team === Players.GetTeam(Game.GetLocalPlayerID());
			if (data.teamInverted === 1)
				teamVictim = !teamVictim;
			row.SetHasClass('AllyEvent', teamVictim);
			row.SetHasClass('EnemyEvent', !teamVictim);
		} else
			row.AddClass('AllyEvent');
		rowText = $.Localize(data.text);
	} 
	if (rowText.match('{player_avatar}')){
		rowText = rowText.replace('{player_avatar}', '');
		row.FindChildTraverse('PlayerAvatarToast').AddClass('Visible')
		row.FindChildTraverse('PlayerAvatarToast').steamid = Game.GetPlayerInfo(data.player).player_steamid
	}
	rowText = rowText.replace('{denied_icon}', "<img class='DeniedIcon'/>").replace('{killed_icon}', "<img class='CombatEventKillIcon'/>").replace('{time_dota}', "<font color='lime'>" + secondsToMS(Game.GetDOTATime(false, false), true) + '</font>').replace('{courier_icon}', "<img class='CombatEventCourierIcon'/>");
	if (data.player != null)
		rowText = rowText.replace('{player_name}', CreateHeroElements(data.player));
	if (data.victimPlayer != null)
		rowText = rowText.replace('{victim_name}', CreateHeroElements(data.victimPlayer));
	if (data.killerPlayer != null) {
		rowText = rowText.replace('{killer_name}', CreateHeroElements(data.killerPlayer));
	}

	if (data.victimUnitName)  
		rowText = rowText.replace('{victim_name}', "<font color='#B22222'>" + $.Localize(data.victimUnitName) + '</font>');
	if (data.team != null) {
		var enemy_team = data.team == DOTATeam_t.DOTA_TEAM_BADGUYS && DOTATeam_t.DOTA_TEAM_GOODGUYS || DOTATeam_t.DOTA_TEAM_BADGUYS 
		rowText = rowText.replace('{courier_team}',"<font color='" + GameUI.CustomUIConfig().team_colors[data.team] + "'>" + $.Localize("custom_toast_courier") + '</font>');
		rowText = rowText.replace('{team_name}', "<font color='" + GameUI.CustomUIConfig().team_colors[data.team] + "'>" + GameUI.CustomUIConfig().team_names[data.team] + '</font>');
		rowText = rowText.replace('{team_lose}', "<font color='" + GameUI.CustomUIConfig().team_colors[enemy_team] + "'>" + GameUI.CustomUIConfig().team_names[enemy_team] + '</font>');
	}
	if (data.gold != null)
		rowText = rowText.replace('{gold}', "<font color='gold'>" + FormatGold(data.gold) + "</font> <img class='CombatEventGoldIcon' />");
	if (data.runeType != null) 
		rowText = rowText.replace('{rune_name}', "<font color='#" + RUNES_TOOLTIP[data.runeType].color + "'>" + RuneElement(data.runeType.toString()) + RUNES_TOOLTIP[data.runeType].localize + '</font>');
	if (data.variables){
		for (var k in data.variables) {
			if (k == '{damage}')
				rowText = rowText.replace(k, FormatGold(data.variables[k].toFixed(0)));
			rowText = rowText.replace(k, $.Localize(data.variables[k]));
		}
	}
	if (rowText.indexOf('<img') === -1)
		row.AddClass('SimpleText');
	row.FindChildTraverse('ToastLabel').text = rowText;
	$.Schedule(10, function() {
		row.AddClass('Collapsed');
	});
	row.DeleteAsync(10.3);
};
(function() {
	GameEvents.Subscribe('create_custom_toast', CreateCustomToast);
})();