item_book_all_stats = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget() or self:GetCaster()
		target:ModifyIntellect(self:GetSpecialValueFor('value'))
		target:ModifyStrength(self:GetSpecialValueFor('value'))
		target:ModifyAgility(self:GetSpecialValueFor('value'))
		self:UpdateCharge()
	end,
})

function item_book_all_stats:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_book_all_stats:GetCustomCastErrorTarget(vLocation)
	return self.error
end