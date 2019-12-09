function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "shadow_shaman_ether_shock" )
    ability2 = thisEntity:FindAbilityByName( "shadow_shaman_hex_custom" )
    ability3 = thisEntity:FindAbilityByName( "shadow_shaman_shackles" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	if ability1:IsFullyCastable() and ability1:GetAutoCastState() then
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
			thisEntity:CastAbilityOnTarget(units[1], ability1, -1)
			return ability1:GetCastPoint() + 0.3
		end
	end
	if ability3:IsFullyCastable() and ability3:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			ability3:GetCastRange(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0 and ability3:IsFullyCastable() then
			thisEntity:CastAbilityOnTarget(units[1], ability3, -1)
			return ability3:GetChannelTime() + 0.3
		end
	end
	if ability2:IsFullyCastable() and ability2:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			ability2:GetKeyValue("AbilityCastRange"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0  then
			thisEntity:CastAbilityOnTarget(units[1], ability2, -1)
			return ability2:GetCastPoint() + 0.3
		end
	end
	return 0.1
end