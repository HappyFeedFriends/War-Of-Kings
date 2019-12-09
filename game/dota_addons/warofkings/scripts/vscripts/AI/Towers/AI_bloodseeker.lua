function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "bloodseeker_bloodrite_custom" )
    ability2 = thisEntity:FindAbilityByName( "bloodseeker_bloodrage_custom" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()

	if ability1:IsFullyCastable() and ability1:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0 then
			thisEntity:CastAbilityOnPosition(units[1]:GetAbsOrigin(),ability1, -1)
			return ability1:GetCastPoint() + 0.3
		end
	end

	if ability2:IsFullyCastable() and ability2:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			1000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		for k,v in pairs(units) do
			if not v:HasModifier('modifier_bloodseeker_bloodrage_custom') and not v:IsRealHero() then 
				thisEntity:CastAbilityOnTarget(v,ability2, -1)
				return ability2:GetCastPoint() + 0.3
			end
		end
	end
	return 0.1
end