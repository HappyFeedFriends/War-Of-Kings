if not kills then
	kills = ({})
end
ModuleRequire(...,"data")

function kills:CreateCustomToast(data,type,killerPlayer,victimPlayer,gold,player,victimUnitName,team,runeType,variables)
	CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", data or {
		type = type,
		killerPlayer = killerPlayer,
		victimPlayer = victimPlayer,
		gold = gold,
		player = player,
		victimUnitName = victimUnitName,
		team = team,
		runeType = runeType,
		variables = variables, -- table
	})
end