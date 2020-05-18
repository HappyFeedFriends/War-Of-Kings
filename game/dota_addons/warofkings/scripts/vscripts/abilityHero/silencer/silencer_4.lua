silencer_4 = class({

	OnSpellStart 		= function(self)
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, 'modifier_silencer_4_aura', {duration = self:GetSpecialValueFor('duration')})
	end,
	GetManaCost 		= function(self)
		self.caster = self.caster or self:GetCaster()
		return self.caster:GetMaxMana() * 0.05
	end,
})
LinkLuaModifier('modifier_silencer_4_aura', 'abilityHero/silencer/silencer_4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_silencer_4_debuff', 'abilityHero/silencer/silencer_4', LUA_MODIFIER_MOTION_NONE)
modifier_silencer_4_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return -1 end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_silencer_4_debuff' end,
	GetAuraEntityReject 	= function(self,hEntity) return hEntity.playerRound ~= self.pID end,
	OnCreated 				= function(self)
		self.pID = self:GetParent():GetPlayerOwnerID()
	end,
})

modifier_silencer_4_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	CheckState 				= function(self) return {[MODIFIER_STATE_MUTED] = true} end,
	OnCreated 				= function(self)
		if IsServer() then 
			self.parent = self:GetParent()
			self.caster = self:GetCaster()
			self.ability = self:GetAbility()
			self.damage = self.ability:GetSpecialValueFor_Custom('int_mult','silencer_2')
			self:StartIntervalThink(self.ability:GetSpecialValueFor('interval'))
		end
	end,
	GetEffectAttachType 	= function(self) return PATTACH_OVERHEAD_FOLLOW end,
	GetEffectName 			= function(self) return 'particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf' end,
	OnIntervalThink 		= function(self)
		if IsClient() and self.caster and not self.caster:IsNull() then return end

		ApplyDamage({
 			victim = self.parent,
 			attacker = self.caster,
 			ability = self.ability,
 			damage = self.damage * (self.caster.GetIntellect and self.caster:GetIntellect() or 0),
 			damage_type = DAMAGE_TYPE_MAGICAL,
		})
	end,

})
