function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "pugna_nether_blast" )
    ability2 = thisEntity:FindAbilityByName( "pugna_life_drain_custom" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
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
		thisEntity:CastAbilityOnPosition(units[1]:GetAbsOrigin(), ability1, -1)
		return ability1:GetCastPoint() + 0.3
	end

	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		ability2:GetSpecialValueFor('cast_range_tooltip'),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability2:IsFullyCastable() then
		thisEntity:CastAbilityOnTarget(units[1],ability2, -1)
		return ability2:GetChannelTime() + 0.3
	end
	return 0.1
end