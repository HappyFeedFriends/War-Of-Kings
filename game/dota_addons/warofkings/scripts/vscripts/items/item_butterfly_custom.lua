item_butterfly_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_butterfly_custom' end,
})
LinkLuaModifier('modifier_item_butterfly_custom', 'items/item_butterfly_custom.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_butterfly_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	} end,
	GetModifierPreAttack_BonusDamage 		= function(self) return self.passiveDamage end,
	GetModifierBonusStats_Strength 			= function(self) return self.str end,
	GetModifierBonusStats_Agility 			= function(self) return self.agi end,
	GetModifierAttackSpeedBonus_Constant 	= function(self) return self.attack_speed end,
	GetModifierPreAttack_BonusDamage 		= function(self) return self.damage end,
},nil,class({
	_OnCreated = function(self)
		self.agi = self.ability:GetSpecialValueFor('agi')
		self.str = self.ability:GetSpecialValueFor('str')
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.attack_speed = self.ability:GetSpecialValueFor('attack_speed')
	end,
}),true)