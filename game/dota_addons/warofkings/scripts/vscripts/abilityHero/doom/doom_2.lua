LinkLuaModifier('modifier_doom_2_buff', 'abilityHero/doom/doom_2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_doom_2_debuff', 'abilityHero/doom/doom_2', LUA_MODIFIER_MOTION_NONE)
doom_2 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_doom_2_buff' end,
})

modifier_doom_2_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	end,	
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.duration_stunned = self.ability:GetSpecialValueFor('duration_stunned')
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.__GetManaCost = self.ability.GetManaCost
		self.__GetMana = self.parent.GetMana
		self.__StartCooldown = self.ability.StartCooldown
	end,
	OnAttackLanded 			= function(self,data)
		if  (IsServer() 
			and data.attacker == self.parent
			and self.ability:GetAutoCastState() 
			and self.__GetManaCost(self.ability,self.ability:GetLevel()) <= self.__GetMana(self.parent)
			and self.ability:IsCooldownReady()
			) then 
			self.parent:ReduceMana(self.__GetManaCost(self.ability,self.ability:GetLevel()))
			data.target:AddNewModifier(self.parent, self.ability,'modifier_doom_2_debuff', {
               duration = self.duration,
			})
			data.target:AddNewModifier(self.parent, self.ability,'modifier_stunned', {
               duration = self.duration_stunned,
			})
			self.__StartCooldown(self.ability,self.ability:GetCooldown(self.ability:GetLevel()))
		end
	end,
	OnRefresh 	= function(self)
		if not self.ability then return end
		self.duration_stunned = self.ability:GetSpecialValueFor('duration_stunned')
		self.duration = self.ability:GetSpecialValueFor('duration')
	end,
})

modifier_doom_2_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,	
	OnCreated 				= function(self)
		if IsClient() then return end
		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.damage = self.ability:GetSpecialValueFor_Custom('damage','doom_upgrade_4')
		self:StartIntervalThink(1)
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then 
			ApplyDamage({
				victim = self.parent,
				attacker = self.caster,
				damage = self.damage,
				ability = self.ability,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
		end
	end,
	CheckState 				= function(self)
		return {
			[MODIFIER_STATE_DISARMED] = true,
		}
	end,
})