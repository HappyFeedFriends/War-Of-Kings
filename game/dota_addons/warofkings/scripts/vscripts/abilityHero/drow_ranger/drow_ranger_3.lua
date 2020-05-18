drow_ranger_3 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_drow_ranger_3_buff' end,
})
LinkLuaModifier('modifier_drow_ranger_3_buff', 'abilityHero/drow_ranger/drow_ranger_3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_drow_ranger_3_buff_dur', 'abilityHero/drow_ranger/drow_ranger_3', LUA_MODIFIER_MOTION_NONE)

modifier_drow_ranger_3_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,	
	OnCreated 				= function(self)
		if IsClient() then return end
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self._ability = self.parent:FindAbilityByName('drow_ranger_4')
		self.chance_bonus_dmg = self.ability:GetSpecialValueFor('chance_bonus_dmg')
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.chance = self.ability:GetSpecialValueFor('chance')
	end,
	OnRefresh 				= function(self)
		if IsClient() or not self.ability then  return end
		self.chance_bonus_dmg = self.ability:GetSpecialValueFor('chance_bonus_dmg')
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.chance = self.ability:GetSpecialValueFor('chance')
	end,
	DeclareFunctions		= function(self)
	 	return {
	 		MODIFIER_EVENT_ON_ATTACK_LANDED,
	 	}
	end,
	OnAttackLanded 			= function(self,data)
		if IsClient() or data.attacker ~= self.parent then return end
		local bAutoCast = self.ability:GetAutoCastState()
		if bAutoCast and self._ability and self._ability:GetAutoCastState() and not self.parent:IsAssembly('drow_ranger_1') then 
			self._ability:ToggleAutoCast()
		end

		if bAutoCast and RollPercentage(self.chance) then 
			ApplyDamage({
 				victim = data.target,
 				attacker = self.parent,
 				damage = self.chance_bonus_dmg,
 				damage_type = DAMAGE_TYPE_PHYSICAL,
 				ability = self.ability,
			})
			self.parent:AddNewModifier(self.parent, self.ability, 'modifier_drow_ranger_3_buff_dur',{
				duration = self.duration
			})
		end
	end,
})

modifier_drow_ranger_3_buff_dur = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,	
	OnCreated 				= function(self)
		if IsClient() then return end
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self:SetStackCount(self.ability:GetSpecialValueFor('bonus_atk'))
		self.bonus_atk_speed = self.ability:GetSpecialValueFor('bonus_atk_speed')
	end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		}
	end,
	GetModifierPreAttack_BonusDamage 		= function(self) return self:GetStackCount() end,
	GetModifierAttackSpeedBonus_Constant 	= function(self) return self.bonus_atk_speed end,
})