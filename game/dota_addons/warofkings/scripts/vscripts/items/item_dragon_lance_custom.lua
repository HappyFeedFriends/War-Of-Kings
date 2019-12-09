item_dragon_lance_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_dragon_lance_custom' end,
})
LinkLuaModifier('modifier_item_dragon_lance_custom', 'items/item_dragon_lance_custom.lua', LUA_MODIFIER_MOTION_NONE)
item_dragon_lance_2 = = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_dragon_lance_custom' end,
})
item_dragon_lance_3 = = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_dragon_lance_custom' end,
})
item_dragon_lance_godness = = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_dragon_lance_custom' end,
})

modifier_item_dragon_lance_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetModifierBonusStats_Agility 		=	function(self) return self.agi end,
	GetModifierBonusStats_Strength 		=	function(self) return self.str end,
	DeclareFunctions 		= function(self) return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end,
	GetModifierAttackRangeBonus 	= function(self) return self.attack_range end,
},nil,class({
	_OnCreated 	= function(self)
		self.agi = self.ability:GetSpecialValueFor('bonus_agility')
		self.str = self.ability:GetSpecialValueFor('bonus_strength')
		self.attack_range = self.ability:GetSpecialValueFor('base_attack_range')
	end,
}),true)