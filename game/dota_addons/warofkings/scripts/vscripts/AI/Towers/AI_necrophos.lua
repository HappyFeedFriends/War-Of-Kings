function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "necrolyte_death_pulse_custom" )
    ability2 = thisEntity:FindAbilityByName( "necrolyte_reapers_scythe_custom" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability1:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ability1, -1)
		return ability1:GetCastPoint() + 0.3
	end

	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability2:IsFullyCastable() then
		thisEntity:CastAbilityOnTarget(units[1],ability2, -1)
		return ability2:GetCastPoint() + 0.3
	end
	return 0.1
end