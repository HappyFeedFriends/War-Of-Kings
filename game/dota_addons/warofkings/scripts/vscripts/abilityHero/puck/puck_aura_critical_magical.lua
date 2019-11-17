LinkLuaModifier ("modifier_puck_aura_critical_magical", "abilityHero/puck/puck_aura_critical_magical", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_puck_aura_critical_magical_buff", "abilityHero/puck/puck_aura_critical_magical", LUA_MODIFIER_MOTION_NONE)
puck_aura_critical_magical = class({
	GetIntrinsicModifierName = function(self) return 'modifier_puck_aura_critical_magical' end,
})

modifier_puck_aura_critical_magical = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_puck_aura_critical_magical_buff' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.radius = self.ability :GetSpecialValueFor('radius')
			self.ability.magicalCritical = self.ability:GetSpecialValueFor('magical_critical')
			self.ability.magicalCriticalChance = self.ability:GetSpecialValueFor('magical_criticalChance')
			self.parent = self:GetParent()
		end
	end,
	OnRefresh = function(self)
		if not self.ability then return end
		self.radius = self.ability:GetSpecialValueFor('radius')
		self.ability.magicalCritical = self.ability:GetSpecialValueFor('magical_critical')
		self.ability.magicalCriticalChance = self.ability:GetSpecialValueFor('magical_criticalChance')
	end,
})

modifier_puck_aura_critical_magical_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated =	function(self)
		self.ability = self:GetAbility()
	end,
	GetMagicalCriticalDamage = function(self) return self.ability.magicalCritical end,
	GetMagicalCriticalChance = function(self) return self.ability.magicalCriticalChance end,
})