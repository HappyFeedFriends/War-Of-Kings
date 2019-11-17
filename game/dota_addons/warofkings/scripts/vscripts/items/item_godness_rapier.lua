LinkLuaModifier ("modifier_item_godness_rapier", "items/item_godness_rapier", LUA_MODIFIER_MOTION_NONE)
item_godness_rapier = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_godness_rapier' end,
})

modifier_item_godness_rapier = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self) 
		self.damage = self:GetAbility():GetSpecialValueFor('damage')
	end,
	DeclareFunctions = function(self) return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
	GetModifierPreAttack_BonusDamage = function(self) return self.damage end,
})