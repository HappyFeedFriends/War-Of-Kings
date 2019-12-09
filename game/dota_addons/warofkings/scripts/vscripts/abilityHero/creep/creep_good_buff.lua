LinkLuaModifier('modifier_creep_good_buff_aura', 'abilityHero/creep/creep_good_buff', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_creep_good_buff', 'abilityHero/creep/creep_good_buff', LUA_MODIFIER_MOTION_NONE)
creep_good_buff = class({
	GetIntrinsicModifierName = function(self) return 'modifier_creep_good_buff_aura' end,
})

modifier_creep_good_buff_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_creep_good_buff' end,
	OnCreated 				= function(self)
		self.radius = self:GetAbility():GetSpecialValueFor('radius')
	end,
})

modifier_creep_good_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes 			= function(self) return {MODIFIER_ATTRIBUTE_MULTIPLE} end,
	OnCreated 				= function(self)
		self.bonus_damage = self:GetAbility():GetSpecialValueFor('bonus_damage')
	end,
	DeclareFunctions 					= function(self) return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
	GetModifierPreAttack_BonusDamage 	= function(self) return self.bonus_damage end,
})