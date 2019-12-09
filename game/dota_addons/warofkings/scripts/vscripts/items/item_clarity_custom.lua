item_clarity_custom = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()

		target:AddNewModifier(self:GetCaster(), self, 'modifier_item_clarity_custom',{
			duration = self:GetSpecialValueFor('duration')
		})
		self:UpdateCharge()
	end,
})
LinkLuaModifier ("modifier_item_clarity_custom", "items/item_clarity_custom.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_clarity_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		local ability = self:GetAbility()
		self.regen = math.max(self:GetParent():GetMaxMana() / 100 * ability:GetSpecialValueFor('regen'),ability:GetSpecialValueFor('regen_min'))
	end,
	DeclareFunctions	 	= function(self) 
		return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}
	end,
	GetModifierConstantManaRegen 		= function(self) return self.regen end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/items_fx/healing_clarity.vpcf' end,
})