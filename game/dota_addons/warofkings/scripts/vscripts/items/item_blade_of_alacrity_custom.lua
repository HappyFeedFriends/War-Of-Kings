item_blade_of_alacrity_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_blade_of_alacrity_custom' end,
})
LinkLuaModifier('modifier_item_blade_of_alacrity_custom', 'items/item_blade_of_alacrity_custom.lua', LUA_MODIFIER_MOTION_NONE)

item_eagle_custom = item_blade_of_alacrity_custom
modifier_item_blade_of_alacrity_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierBonusStats_Agility 		=	function(self) return self.agi end,
},nil,class({
	_OnCreated 	= function(self)
		self.agi = self:GetAbility():GetSpecialValueFor('value')
	end,
}),true)