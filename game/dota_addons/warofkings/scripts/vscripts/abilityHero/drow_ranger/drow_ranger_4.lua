drow_ranger_4 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_drow_ranger_4_buff' end,
})
LinkLuaModifier('modifier_drow_ranger_4_buff', 'abilityHero/drow_ranger/drow_ranger_4', LUA_MODIFIER_MOTION_NONE)

modifier_drow_ranger_4_buff = class({
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
		self._ability = self.parent:FindAbilityByName('drow_ranger_3')
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.chance = self.ability:GetSpecialValueFor('chance')
		self.manaCost = self.ability:GetManaCost(self.ability:GetLevel())
	end,
	OnRefresh 				= function(self)
		if IsClient() or not self.ability then  return end
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.chance = self.ability:GetSpecialValueFor('chance')
		self.manaCost = self.ability:GetManaCost(self.ability:GetLevel())
	end,
	DeclareFunctions		= function(self)
	 	return {
	 		MODIFIER_EVENT_ON_ATTACK_LANDED,
	 	}
	end,
	OnAttackLanded 			= function(self,data)
		if IsClient() or data.attacker ~= self.parent or not self.ability:IsCooldownReady() or not self.ability:IsOwnersManaEnough() then return end
		local bAutoCast = self.ability:GetAutoCastState()
		if bAutoCast and self._ability and self._ability:GetAutoCastState() and not self.parent:IsAssembly('drow_ranger_1') then 
			self.ability:ToggleAutoCast()
			return 
		end
		if bAutoCast and RollPercentage(self.chance) then 

			local bonusDamage = data.target:FindModifierByName('modifier_drow_ranger_1_debuff')
			bonusDamage = bonusDamage and bonusDamage:GetStackCount() or 0
			local dmg = self.ability:GetSpecialValueFor_Custom('chance_bonus_dmg','drow_ranger_2')
			ApplyDamage({
 				victim = data.target,
 				attacker = self.parent,
 				damage = dmg + (dmg/100 * bonusDamage),
 				damage_type = DAMAGE_TYPE_MAGICAL,
 				ability = self.ability,
			})
			data.target:AddNewModifier(self.parent, self.ability, 'modifier_stunned',{
				duration = self.duration
			})
			self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
			self.parent:ReduceMana(self.manaCost)
		end
	end,
})