function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "sniper_take_aim" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	if not thisEntity:GetOwner() then return -1 end
	--local hasModifier1 = thisEntity:HasModifier('modifier_sniper_base_attack')
	local hasModifier2 = thisEntity:HasModifier('modifier_sniper_range_attack_bonus')
	--local IsAssembly1 = card:IsAssemblyCard(thisEntity:GetUnitName(),'sniper_upgrade_1',thisEntity:GetOwner():GetPlayerID())
	local IsAssembly2 = card:IsAssemblyCard(thisEntity:GetUnitName(),'sniper_upgrade_2',thisEntity:GetOwner():GetPlayerID())
	--[[if not hasModifier1 and IsAssembly1 then
		thisEntity:AddNewModifier(thisEntity, nil, 'modifier_sniper_base_attack', {
			duration = -1,
		})
	elseif not IsAssembly1 then
		thisEntity:RemoveModifierByName('modifier_sniper_base_attack')
	end]]

	if not hasModifier2 and IsAssembly2 then
		thisEntity:AddNewModifier(thisEntity, nil, 'modifier_sniper_range_attack_bonus', {
			duration = -1,
		})
	elseif not IsAssembly2 then
		thisEntity:RemoveModifierByName('modifier_sniper_range_attack_bonus')
	end

	local units = FindUnitsInRadius(thisEntity:GetTeamNumber(),
		thisEntity:GetOrigin(),
		nil,
		thisEntity:Script_GetAttackRange() + ability1:GetSpecialValueFor('bonus_attack_range'),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	if #units > 0 and ability1:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ability1, -1)
		return ability1:GetCastPoint() + 0.3
	end
	return 0.1
end