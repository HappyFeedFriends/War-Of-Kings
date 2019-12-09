function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity  then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "big_thunder_lizard_frenzy" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	if ability1:IsFullyCastable() and ability1:GetAutoCastState() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			1200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		local unitsF = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			1200,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		if #units > 0 and #unitsF > 0 then
			thisEntity:CastAbilityOnTarget(unitsF[1],ability1, -1)
			return ability1:GetCastPoint() + 0.3
		end
	end
	return 0.1
end