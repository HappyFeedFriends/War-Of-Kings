silencer_1 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_silencer_1_buff' end,
})
LinkLuaModifier('modifier_silencer_1_buff', 'abilityHero/silencer/silencer_1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_silencer_1_int_steal', 'abilityHero/silencer/silencer_1', LUA_MODIFIER_MOTION_NONE)
modifier_silencer_1_buff = class({
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
			self.duration = self.ability:GetSpecialValueFor('duration')	
	end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.int_mult = self.ability:GetSpecialValueFor('int_mult')
			self.duration = self.ability:GetSpecialValueFor('duration')
		end
	end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	} end,
	OnAttackLanded 			= function(self,data)
		if  IsServer() and data.attacker == self.parent and self.ability:GetAutoCastState() and  self.ability:IsCooldownReady() and self.ability:IsOwnersManaEnough() then 
			local count = self.ability:GetSpecialValueFor_Custom('int_steal','silencer_3')
			local stacks = self.parent:AddStackModifier({
				ability = self.ability,
				modifier = 'modifier_silencer_1_int_steal',
				duration = self.duration,
				count = count,
				updateStack = false,
				caster = self.parent,
			})
			self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
			self.parent:ReduceMana(self.ability:GetManaCost(self.ability:GetLevel()))
			if stacks > 0 then 
				self.parent:ModifyIntellect(count)
			end
		end 
	end,
})

modifier_silencer_1_int_steal = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
},nil,class({
	_OnDestroy 				= function(self)
		if IsServer() and self.parent.ReCalculateAttributes then 
			self.parent:ReCalculateAttributes()
		end
	end,
}),true)