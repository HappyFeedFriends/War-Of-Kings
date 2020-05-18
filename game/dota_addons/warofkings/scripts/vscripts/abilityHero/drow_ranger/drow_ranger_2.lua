drow_ranger_2 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_drow_ranger_2_aura' end,
})
LinkLuaModifier('modifier_drow_ranger_2_aura', 'abilityHero/drow_ranger/drow_ranger_2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_drow_ranger_2_buff', 'abilityHero/drow_ranger/drow_ranger_2', LUA_MODIFIER_MOTION_NONE)

modifier_drow_ranger_2_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_drow_ranger_2_buff' end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.radius = self.ability:GetSpecialValueFor('radius')
		self.ability.atk_speed = self.ability:GetSpecialValueFor('atk_speed')
		if IsServer() then
			self:SetStackCount(self.ability:GetSpecialValueFor('damage'))
		end
	end,
	OnRefresh 				= function(self)
		if self.ability then 
			self.radius = self.ability:GetSpecialValueFor('radius')
			self.ability.atk_speed = self.ability:GetSpecialValueFor('atk_speed')
			self:SetStackCount(self.ability:GetSpecialValueFor('damage'))
		end
	end,
})

modifier_drow_ranger_2_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		if IsServer() then
			self:SetStackCount(self.ability:GetSpecialValueFor('damage'))
		end
	end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		}
	end,
	OnRefresh 			= function(self)
		if self.ability then 
			self:SetStackCount(self.ability:GetSpecialValueFor('damage'))
		end
	end,
	GetModifierPreAttack_BonusDamage 		= function(self) return self:GetStackCount() * (self.parent == self.caster and 1.3 or 1) end,
	GetModifierAttackSpeedBonus_Constant 	= function(self) return self.ability and (self.ability.atk_speed or 0) * (self.parent == self.caster and 1.3 or 1)  end,
})