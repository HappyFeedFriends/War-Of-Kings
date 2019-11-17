LinkLuaModifier ("modifier_battle_fury_custom", "items/item_battle_fury", LUA_MODIFIER_MOTION_NONE)
item_battle_fury_1 = class({})
item_battle_fury_2 = item_battle_fury_1
function item_battle_fury_1:GetIntrinsicModifierName()
    return "modifier_battle_fury_custom"
end

function item_battle_fury_1:OnProjectileHit( hTarget, vLocation )
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor("split_damage")
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
end

modifier_battle_fury_custom = modifier_battle_fury_custom or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_battle_fury_custom:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attack_speed")
end
function modifier_battle_fury_custom:DeclareFunctions()
local funcs =
	{	
		MODIFIER_EVENT_ON_ATTACK,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	
	}
	return funcs 
end

function modifier_battle_fury_custom:OnAttack(params)
	if params.attacker == self:GetCaster() and params.attacker:IsAttackRange()  then
		self:GetCaster():SplitShot(self:GetAbility(),self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("bonus_target"))
	end 
end

function modifier_battle_fury_custom:GetModifierPreAttack_BonusDamage()
	return	self.damage
end

function modifier_battle_fury_custom:GetModifierAttackSpeedBonus_Constant()
	return	self.attackspeed
end