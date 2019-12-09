nevermore_dark_lord_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_nevermore_dark_lord_custom_aura' end,
})

LinkLuaModifier ("modifier_nevermore_dark_lord_custom_aura", "abilityHero/shadow_fiend/nevermore_dark_lord_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_nevermore_dark_lord_custom_debuff", "abilityHero/shadow_fiend/nevermore_dark_lord_custom.lua", LUA_MODIFIER_MOTION_NONE)


modifier_nevermore_dark_lord_custom_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_nevermore_dark_lord_custom_debuff' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.radius = self.ability:GetSpecialValueFor('presence_radius')
		end
	end,
})

modifier_nevermore_dark_lord_custom_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,	
	OnCreated 				= function(self)
		self.abiltiy = self:GetAbility()
		self.parent = self:GetParent()
		self.reduction = self.abiltiy:GetSpecialValueFor('presence_armor_reduction')
		self.magicalReduction = -self.abiltiy:GetSpecialValueFor('magical_resistance_reduction')
		self:StartIntervalThink(1)
	end,
	OnRefresh 				= function(self) 
		if not IsServer() or not self.abiltiy then return end
		self.reduction = self.abiltiy:GetSpecialValueFor('presence_armor_reduction')
		self.magicalReduction = -self.abiltiy:GetSpecialValueFor('magical_resistance_reduction')
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then 
			self.IsAssembly = self.parent:IsAssembly('sf_upgrade_1')
		end
	end,
	DeclareFunctions 		= function(self)
		return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
	end,
	GetModifierPhysicalArmorBonus 		= function(self) return self.reduction end,
	GetModifierMagicalResistanceBonus 	= function(self) return self.IsAssembly and self.magicalReduction or 0 end,
})