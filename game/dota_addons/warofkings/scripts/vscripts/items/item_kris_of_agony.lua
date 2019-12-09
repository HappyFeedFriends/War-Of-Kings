LinkLuaModifier("modifier_item_kris_of_agony", "items/item_kris_of_agony", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_kris_of_agony_buff", "items/item_kris_of_agony", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_kris_of_agony_count_stack", "items/item_kris_of_agony", LUA_MODIFIER_MOTION_NONE)
item_kris_of_agony_1 = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_item_kris_of_agony' end,
})

item_kris_of_agony_2 = item_kris_of_agony_1
item_kris_of_agony_3 = item_kris_of_agony_1

local tableClass = {
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE	
	} end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.passiveDamage end,
	GetModifierBonusStats_Strength 		=	function(self) return self.AllAttribute end,
	GetModifierBonusStats_Agility 		=	function(self) return self.AllAttribute end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.AllAttribute end,
}

modifier_item_kris_of_agony =  class(tableClass,nil,class({
	_OnCreated 				= function(this,data) -- call modifier_attribute_all_base
		this.bonus_stack = this.ability:GetSpecialValueFor('bonus_stack')
		this.max_stack_bonus = this.ability:GetSpecialValueFor('max_stack_bonus')
		this.max_bonus = this.ability:GetSpecialValueFor('max_bonus')
		this.bonus_damage = this.ability:GetSpecialValueFor('bonus_damage')
		this.passiveDamage = this.ability:GetSpecialValueFor('bonus_damage_passive') or 0 -- In case of patches from Gabe that would be on by default == 0
		this.AllAttribute = this.ability:GetSpecialValueFor('Attributes')
	end,
}),true)

function modifier_item_kris_of_agony:OnTakeDamage(params)
	if params.attacker == self.parent  then
		local modifier = self.parent:FindModifierByName('modifier_item_kris_of_agony_buff')
		if modifier and modifier:GetStackCount()/self.bonus_damage >= self.max_bonus then return end
		local sModifierStack = 'modifier_item_kris_of_agony_count_stack'
		self.parent:AddStackModifier({
			ability = self.ability,
			modifier = sModifierStack,
			count = params.damage/100*self.bonus_stack,
			caster = self.parent,
		})
		local imodifierCount = self.parent:FindModifierByName(sModifierStack):GetStackCount()
		if imodifierCount >= self.max_stack_bonus then
			self.parent:AddStackModifier({
				ability = self.ability,
				modifier = sModifierStack,
				count = -self.max_stack_bonus,
				caster = self.parent,
			})	
			self.parent:AddStackModifier({
				ability = self.ability,
				modifier = 'modifier_item_kris_of_agony_buff',
				caster = self.parent,
			})		
		end
	end
end
modifier_item_kris_of_agony_buff =  class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.bonus_damage = self.ability:GetSpecialValueFor('bonus_damage')
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
	} end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.bonus_damage * self:GetStackCount() end,
})

modifier_item_kris_of_agony_count_stack =  class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_TOOLTIP,	
	} end,
	OnTooltip 				= function(self) return self:GetStackCount() end,
})
