LinkLuaModifier('modifier_creep_bed_aura_debuff_aura', 'abilityHero/creep/creep_bed_aura_debuff', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_creep_bed_aura_debuff_debuff', 'abilityHero/creep/creep_bed_aura_debuff', LUA_MODIFIER_MOTION_NONE)
creep_bed_aura_debuff = class({
	GetIntrinsicModifierName = function(self) return 'modifier_creep_bed_aura_debuff_aura' end,
})

modifier_creep_bed_aura_debuff_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_creep_bed_aura_debuff_debuff' end,
	OnCreated 				= function(self)
		self.radius = self:GetAbility():GetSpecialValueFor('radius')
	end,
})

modifier_creep_bed_aura_debuff_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes 			= function(self) return {MODIFIER_ATTRIBUTE_MULTIPLE} end,
	OnCreated 				= function(self)
		self.armor_reduction = self:GetAbility():GetSpecialValueFor('armor_reduction')
	end,
	DeclareFunctions 		= function(self) return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end,
	GetModifierPhysicalArmorBonus 	= function(self) return self.armor_reduction end,
})