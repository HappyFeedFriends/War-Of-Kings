function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "obsidian_destroyer_equilibrium" )
    ability2 = thisEntity:FindAbilityByName( "obsidian_destroyer_sanity_eclipse_custom" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		ability2:GetKeyValue("AbilityCastRange"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability2:IsFullyCastable() then
		thisEntity:CastAbilityOnPosition(units[1]:GetAbsOrigin(), ability2, -1)
		return ability2:GetCastPoint() + 0.3
	end

	if thisEntity:GetMaxMana() > thisEntity:GetMana() and ability1:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ability1, -1)
		return ability1:GetCastPoint() + 0.3
	end
	return 0.1
end