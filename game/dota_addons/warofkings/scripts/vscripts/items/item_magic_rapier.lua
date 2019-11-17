item_magic_rapier = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_magic_rapier' end,
})
item_magic_rapier_godness = item_magic_rapier
LinkLuaModifier('modifier_item_magic_rapier', 'items/item_magic_rapier.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_magic_rapier = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.amplify = self:GetAbility():GetSpecialValueFor('bonus_amplify')
	end,
	DeclareFunctions	 	= function(self) 
		return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
	end,
	GetModifierSpellAmplify_Percentage 		= function(self) return self.amplify end,
})