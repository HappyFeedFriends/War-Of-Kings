item_damage_book = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		local playerID = UnitVarToPlayerID(self:GetCaster())
		if target.GetBuilding and playerID and playerID > -1 then
			-- target = target:GetBuilding()
			target:AddStackModifier({
				ability = self,
				modifier = 'modifier_item_damage_book',
				caster = self:GetCaster(),
				count = self:GetSpecialValueFor('value')
			})
			self:UpdateCharge()
			return
		end
		DisplayError(playerID, '#War_of_kings_hud_error_target_none_building')
	end,
})
LinkLuaModifier("modifier_item_damage_book", "items/item_damage_book", LUA_MODIFIER_MOTION_NONE)
modifier_item_damage_book = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		}
	end,	
	GetModifierPreAttack_BonusDamage = function(self) return self:GetStackCount() end,
})