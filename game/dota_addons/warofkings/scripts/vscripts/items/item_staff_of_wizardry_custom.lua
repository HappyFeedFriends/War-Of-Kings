item_staff_of_wizardry_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_staff_of_wizardry_custom' end,
})
LinkLuaModifier('modifier_item_staff_of_wizardry_custom', 'items/item_staff_of_wizardry_custom.lua', LUA_MODIFIER_MOTION_NONE)

item_mystic_staff_custom_1 = item_staff_of_wizardry_custom
modifier_item_staff_of_wizardry_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierBonusStats_Intellect 		=	function(self) return self.value end,
},nil,class({
	_OnCreated 	= function(self)
		self.value = self:GetAbility():GetSpecialValueFor('value')
	end,
}),true)