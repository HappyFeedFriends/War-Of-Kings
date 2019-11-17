item_xp_book = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		local playerID = UnitVarToPlayerID(self:GetCaster())
		if target.GetBuilding and playerID and playerID > -1 then
			target = target:GetBuilding()
			target:AddExperience(self:GetSpecialValueFor('xp_bonus'))
			self:UpdateCharge()
			GetPlayerCustom(playerID):UpdateQuest(QUEST_FOR_BATTLE_USE_XP_BOOK,1)
			return
		end
		DisplayError(playerID, '#War_of_kings_hud_error_target_none_building')
	end,
})