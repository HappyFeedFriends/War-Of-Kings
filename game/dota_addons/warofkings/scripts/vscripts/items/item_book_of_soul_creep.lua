item_book_of_soul_creep = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local building = target:GetBuilding()
		local allXp = building:GetAllXp()
		caster.assembliesSave = caster.assembliesSave or {}
		caster.assembliesSave[target:GetUnitName()] = true
		BuildSystem:RemoveBuilding(target)
		local count = BuildSystem:GetCountBuild(caster:GetPlayerID())
		if allXp > count then
			BuildSystem:EachBuilding(caster:GetPlayerID(), function(build)
				build:AddExperience(allXp/count)
			end)
		end
		self:UpdateCharge()
	end,
})

function item_book_of_soul_creep:CastFilterResultTarget(hTarget)
	if IsServer() then
		if not hTarget.GetBuilding then
			self.error = 'dota_hud_error_only_building_target'
			return UF_FAIL_CUSTOM
		end
		if self:GetCaster().GetBuilding then 
			self.error = 'dota_hud_error_caster_only_builder'
			return UF_FAIL_CUSTOM
		end
		if self:GetCaster() == hTarget or hTarget.GetBuilding():GetPlayerOwnerID() ~= self:GetCaster():GetPlayerID() then
			self.error = 'dota_hud_error_caster_not_owner'
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function item_book_of_soul_creep:GetCustomCastErrorTarget(vLocation)
	return self.error
end