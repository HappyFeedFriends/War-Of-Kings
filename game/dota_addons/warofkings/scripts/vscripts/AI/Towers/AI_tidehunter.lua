function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "tidehunter_anchor_smash" )
    ability2 = thisEntity:FindAbilityByName( "tidehunter_ravage" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	if ability1:IsFullyCastable() and ability1:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			ability1:GetSpecialValueFor('radius'),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0 then
			thisEntity:CastAbilityNoTarget(ability1, -1)
			return ability1:GetCastPoint() + 0.3
		end
	end
	if ability2:IsFullyCastable() and ability2:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			ability2:GetSpecialValueFor('radius'),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0  then
			thisEntity:CastAbilityNoTarget(ability2, -1)
			return ability2:GetCastPoint() + 0.3
		end
	end
	return 0.1
end