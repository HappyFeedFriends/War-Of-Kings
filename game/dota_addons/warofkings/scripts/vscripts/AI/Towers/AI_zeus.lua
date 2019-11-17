function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "zuus_arc_lightning" )
    ability2 = thisEntity:FindAbilityByName( "zuus_thundergods_wrath_custom" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		-1,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	local isCreepFind = false
	for k,v in pairs(units) do
		if v.playerRound and thisEntity.GetBuilding and thisEntity:GetBuilding().hOwner and v.playerRound == thisEntity:GetBuilding().hOwner:GetPlayerID() then 
			isCreepFind = true
			break
		end
	end
	if isCreepFind and ability2:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ability2, -1)
		return ability2:GetCastPoint() + 0.3
	end
	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		ability1:GetCastRange(),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability1:IsFullyCastable() then
		thisEntity:CastAbilityOnTarget(units[1],ability1, -1)
		return ability1:GetCastPoint() + 0.2
	end
	return 0.1
end