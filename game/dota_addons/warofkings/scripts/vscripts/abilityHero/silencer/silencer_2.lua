silencer_2 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_silencer_2_buff' end,
})
LinkLuaModifier('modifier_silencer_2_buff', 'abilityHero/silencer/silencer_2', LUA_MODIFIER_MOTION_NONE)

modifier_silencer_2_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnRefresh 				= function(self)
		if IsClient() or not self.ability then return end

			self.int_mult = self.ability:GetSpecialValueFor('int_mult')
			self.physical_damage = self.ability:GetSpecialValueFor('physical_damage')	
	end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.int_mult = self.ability:GetSpecialValueFor('int_mult')
			self.physical_damage = self.ability:GetSpecialValueFor('physical_damage')
		end
	end,
})