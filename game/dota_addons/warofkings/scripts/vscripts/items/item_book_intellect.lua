item_book_intellect = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget() or self:GetCaster()
		local value = self:GetSpecialValueFor('value')
		target:ModifyIntellect(value)
		if target.fIntellectBook then 
			target.fIntellectBook = target.fIntellectBook + value
		end
		self:UpdateCharge()
	end,
})

function item_book_intellect:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_book_intellect:GetCustomCastErrorTarget(vLocation)
	return self.error
end