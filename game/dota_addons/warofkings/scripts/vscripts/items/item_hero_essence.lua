item_hero_essence = class({
	OnSpellStart 	= function(self)
		self:GetCursorTarget():GetBuilding():UpgradeBuilding()
		self:UpdateCharge()
	end,
	CastFilterResultTarget 	= function(self,hTarget)
		if IsServer() then 
			if not hTarget.GetBuilding then 
				self.error = "#dota_hud_error_only_building_target"
				return UF_FAIL_CUSTOM
			end

			if hTarget:GetBuilding():GetRariry() ~= 'Starting_towers' then 
				self.error = "#dota_hud_error_only_building_starting"
				return UF_FAIL_CUSTOM
			end

			if hTarget:GetBuilding():IsMaxGrade() then 
				self.error = "#dota_hud_error_only_building_max_grade"
				return UF_FAIL_CUSTOM
			end

		end
		return UF_SUCCESS
	end,
	GetCustomCastErrorTarget 	= function(self)
		return self.error
	end,
})