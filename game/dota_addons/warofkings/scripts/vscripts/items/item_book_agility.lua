item_book_agility = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget() or self:GetCaster()
		local value = self:GetSpecialValueFor('value')
		target:ModifyAgility(value)
		if target.fAgilityBook then 
			target.fAgilityBook = target.fAgilityBook + value
		end
		self:UpdateCharge()
	end,
})

function item_book_agility:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_book_agility:GetCustomCastErrorTarget(vLocation)
	return self.error
end