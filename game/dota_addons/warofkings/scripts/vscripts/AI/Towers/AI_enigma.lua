function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "enigma_malefice" )
    -- ability2 = thisEntity:FindAbilityByName( "enigma_midnight_pulse" )
    ability3 = thisEntity:FindAbilityByName( "enigma_black_hole" )
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
		if #units > 0 then
			thisEntity:CastAbilityOnTarget(units[1],ability1, -1)
			return ability1:GetCastPoint() + 0.2
		end
	end
	-- local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
	-- 	thisEntity:GetOrigin(),
	-- 	nil,
	-- 	ability2:GetCastRange(),
	-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,
	-- 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	-- 	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	-- 	FIND_CLOSEST,
	-- 	false)
	-- if #units > 0 and ability2:IsFullyCastable() then
	-- 	thisEntity:CastAbilityOnPosition(units[1]:GetAbsOrigin(),ability2, -1)
	-- 	return ability2:GetCastPoint() + 0.2
	-- end
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
		if #units > 0 then
			thisEntity:CastAbilityOnPosition(units[1]:GetAbsOrigin(),ability3, -1)
			return ability3:GetChannelTime() + 0.2
		end
	end
	return 0.1
end