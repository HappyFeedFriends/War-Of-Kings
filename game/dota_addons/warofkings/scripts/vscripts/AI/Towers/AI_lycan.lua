function Spawn( entityKeyValues ) 
    if not IsServer() or not thisEntity then
        return
    end
    if not thisEntity:GetPlayerOwnerID() then 
    	return 0
    end
    ability1 = thisEntity:FindAbilityByName( "lycan_shapeshift" )
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end

function ThinkEntity()
	if thisEntity:GetAttackTarget() and ability1:IsFullyCastable() and ability1:GetAutoCastState() then
		thisEntity:CastAbilityNoTarget(ability1, -1)
		return ability1:GetCastPoint() + 0.3
	end
	return 0.1
end