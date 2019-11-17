LinkLuaModifier ("modifier_item_fire_sword_debuff", "items/item_fire_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_fire_sword_buff", "items/item_fire_sword", LUA_MODIFIER_MOTION_NONE)
item_fire_sword = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_item_fire_sword_buff' end
})

modifier_item_fire_sword_buff =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor('bonus_damage')
		self.bonus_attack = self.ability:GetSpecialValueFor('bonus_atk')
		self.dur = self.ability:GetSpecialValueFor('duration')
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
	} end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.damage end,
	GetModifierAttackSpeedBonus_Constant = function( self ) return self.bonus_attack end,

})

modifier_item_fire_sword_debuff =  class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		self.damage = self:GetAbility():GetSpecialValueFor('damage_tick')
		self.resistance = self:GetAbility():GetSpecialValueFor('reduction_resistance')
		self.ability = self:GetAbility()
		self:StartIntervalThink(0.45)
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	} end,
	GetModifierMagicalResistanceBonus = function(self) return -self.resistance end,
	OnIntervalThink 	= function(self)
		if IsServer() then
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self.ability,
			})
		end
	end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf' end,
})

function modifier_item_fire_sword_buff:OnAttackLanded(params)
	if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
		params.target:AddNewModifier(params.attacker, self.ability, 'modifier_item_fire_sword_debuff', {
			duration = self.dur
		})
		self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
	end
end