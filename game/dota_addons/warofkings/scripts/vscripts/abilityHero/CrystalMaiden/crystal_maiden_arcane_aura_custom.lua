LinkLuaModifier('modifier_crystal_maiden_arcane_aura_custom_aura', 'abilityHero/CrystalMaiden/crystal_maiden_arcane_aura_custom', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_crystal_maiden_arcane_aura_custom_buff', 'abilityHero/CrystalMaiden/crystal_maiden_arcane_aura_custom', LUA_MODIFIER_MOTION_NONE)
crystal_maiden_arcane_aura_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_crystal_maiden_arcane_aura_custom_aura' end,
})
modifier_crystal_maiden_arcane_aura_custom_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return -1 end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_crystal_maiden_arcane_aura_custom_buff' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.caster = self:GetCaster()
			self.pID = self.parent:GetPlayerOwnerID()
		end
	end,
})
function modifier_crystal_maiden_arcane_aura_custom_aura:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
modifier_crystal_maiden_arcane_aura_custom_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.manaRegen = self.ability:GetSpecialValueFor('mana_regen')
		self.amp = self.ability:GetSpecialValueFor('amp')
	end,	
	OnRefresh 				= function(self)
		if IsClient() then return end
		if not self.ability then return end	
		self.manaRegen = self.ability:GetSpecialValueFor('mana_regen')
		self.amp = self.ability:GetSpecialValueFor('amp')
	end,
	DeclareFunctions 		= function(self)
		return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
	end,
	GetModifierConstantManaRegen = function(self) return self.manaRegen end,
	GetModifierSpellAmplify_Percentage = function(self) return self.amp end,
})