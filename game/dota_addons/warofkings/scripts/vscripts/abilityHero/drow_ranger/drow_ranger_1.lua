drow_ranger_1 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_drow_ranger_1_buff' end,
})
LinkLuaModifier('modifier_drow_ranger_1_buff', 'abilityHero/drow_ranger/drow_ranger_1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_drow_ranger_1_debuff', 'abilityHero/drow_ranger/drow_ranger_1', LUA_MODIFIER_MOTION_NONE)

modifier_drow_ranger_1_buff = class({
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
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.movespeed = -self.ability:GetSpecialValueFor('movespeed')
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.__GetManaCost = self.ability.GetManaCost
	end,
	OnAttackLanded 			= function(self,data)
		if  (IsServer() and data.attacker == self.parent and self.ability:GetAutoCastState() and self.ability:IsOwnersManaEnough()) then 
			self.parent:ReduceMana(self.__GetManaCost(self.ability,self.ability:GetLevel()))
			local modifier = data.target:AddNewModifier(self.parent, self.ability,'modifier_drow_ranger_1_debuff', {
               duration = self.duration,
			})
			if modifier then 
				modifier:SetStackCount(self.movespeed)
			end
			ApplyDamage({
 				victim = data.target,
 				attacker = self.parent,
 				damage = self.damage,
 				ability = self.ability,
 				damage_type = DAMAGE_TYPE_PHYSICAL,
			})
		end
	end,
	OnRefresh 	= function(self)
		if not self.ability then return end
		self.duration = self.ability:GetSpecialValueFor('duration')
		self.movespeed = -self.ability:GetSpecialValueFor('movespeed')
		self.damage = self.ability:GetSpecialValueFor('damage')
	end,
})

modifier_drow_ranger_1_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		}
	end,
	GetModifierMoveSpeedBonus_Percentage = function(self) return -self:GetStackCount() end,
})