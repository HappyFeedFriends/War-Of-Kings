item_shield_buff = class({
	OnSpellStart = function(self)
		local build = self:GetCursorTarget():GetBuilding()
		local shieldBonus = self:GetSpecialValueFor('bonus_shield')
		build:AddShield(shieldBonus,self)
		self:UpdateCharge()
	end,
})

function item_shield_buff:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end
function item_shield_buff:GetCustomCastErrorTarget(hTarget)
	return "dota_hud_error_only_building_target"
end