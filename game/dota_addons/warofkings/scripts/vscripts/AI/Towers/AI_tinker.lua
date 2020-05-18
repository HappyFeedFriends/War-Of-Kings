function Spawn( entityKeyValues ) 
	 if not IsServer() or not thisEntity then 
		return
	end
	if not thisEntity:GetPlayerOwnerID() then 
		return 0
	end
	thisEntity:SetContextThink( "Think", ThinkEntity, 1 ) 
end