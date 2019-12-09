item_ogre_axe_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_ogre_axe_custom' end,
})
LinkLuaModifier('modifier_item_ogre_axe_custom', 'items/item_ogre_axe_custom.lua', LUA_MODIFIER_MOTION_NONE)

item_reaver_custom = item_ogre_axe_custom
modifier_item_ogre_axe_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierBonusStats_Strength 		=	function(self) return self.value end,
},nil,class({
	_OnCreated 	= function(self)
		self.value = self:GetAbility():GetSpecialValueFor('value')
	end,
}),true)