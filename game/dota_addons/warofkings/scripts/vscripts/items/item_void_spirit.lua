item_void_spirit = class({
	OnSpellStart 	= function(self)
	local target = self:GetCursorTarget()
		if IsServer() and target.GetBuilding then 

		end
	end,
})

function item_void_spirit:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
		if self:GetCaster().hTarget then 
			self.error = 'dota_hud_error_caster_building'
			return UF_FAIL_CUSTOM
		end
		if hTarget.GetBuilding():GetPlayerOwnerID() ~= self:GetCaster():GetPlayerID() then
			self.error = 'dota_hud_error_caster_not_owner'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_void_spirit:GetCustomCastErrorTarget(vLocation)
	return self.error
end