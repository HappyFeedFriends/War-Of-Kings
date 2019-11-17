item_tpscroll_custom = class({
	OnSpellStart 	= function(self)
		local building = self:GetCaster()
		local position = self:GetCursorPosition()
		local blocker = BuildSystem:CreateBlocker(BuildSystem:GridNavSquare(BUILDING_SIZE, position))
		position = BuildSystem:MoveBuilding(building, position)
		building:FireTeleported(position)
		BuildSystem:RemoveBlocker(blocker)
	end,
})

function item_tpscroll_custom:CastFilterResultLocation(vLocation)
	if self:GetCaster():HasModifier("modifier_building") then
		if IsServer() then
			SnapToGrid(BUILDING_SIZE, vLocation)
			if not BuildSystem:ValidPosition(BUILDING_SIZE, vLocation, nil) then
				self.error = "dota_hud_error_cant_build_at_location"
				return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
	self.error = "dota_hud_error_caster_building"
	return UF_FAIL_CUSTOM
end

function item_tpscroll_custom:GetCustomCastErrorLocation(vLocation)
	return self.error
end