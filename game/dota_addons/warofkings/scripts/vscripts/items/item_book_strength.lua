item_book_strength = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget() or self:GetCaster()
		local value = self:GetSpecialValueFor('value')
		target:ModifyStrength(value)
		if target.fStrengthBook then 
			target.fStrengthBook = target.fStrengthBook + value
		end
		self:UpdateCharge()
	end,
})

function item_book_strength:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_book_strength:GetCustomCastErrorTarget(vLocation)
	return self.error
end