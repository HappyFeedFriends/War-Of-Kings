LinkLuaModifier ("modifier_item_ice_sword", "items/item_ice_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ice_sword_debuff", "items/item_ice_sword", LUA_MODIFIER_MOTION_NONE)
item_ice_sword = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_ice_sword' end,
})

modifier_item_ice_sword = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	DeclareFunctions 		= function(self) return {	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	} end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.damage end,
	GetModifierAttackSpeedBonus_Constant = function( self ) return self.bonus_attack end,
	GetModifierBonusStats_Agility 		=	function(self) return self.agi end,
},nil,class({
	_OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor('bonus_damage')
		self.bonus_attack = self.ability:GetSpecialValueFor('bonus_atk')
		self.dur = self.ability:GetSpecialValueFor('duration')
		self.durDamage = self.ability:GetSpecialValueFor('duration_damage')
		self.agi = self.ability:GetSpecialValueFor('bonus_agility')
	end,
}),true)
modifier_item_ice_sword_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self) 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor('damage_tick'),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self:GetAbility(),
		}
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then
			ApplyDamage(self.damageTable)
		end
	end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf' end,
})
function modifier_item_ice_sword:OnAttackLanded(params)
	if params.attacker == self:GetParent() and self.ability:IsCooldownReady() then
		params.target:AddNewModifier(self:GetParent(), self.abiltiy, 'modifier_stunned', {
			duration = self.dur,
		})
		params.target:AddNewModifier(self:GetParent(), self.ability, 'modifier_item_ice_sword_debuff', {
			duration = self.durDamage,
		})
		self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
	end
end