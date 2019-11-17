LinkLuaModifier ("modifier_bloodthor_custom", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bloodthor_custom_active", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_bloodthor_custom_critical", "items/item_bloodthorn", LUA_MODIFIER_MOTION_NONE)

item_bloodthorn_1 = class({})
item_bloodthorn_godness = item_bloodthorn_1
function item_bloodthorn_1:GetIntrinsicModifierName()
    return "modifier_bloodthor_custom"
end

function item_bloodthorn_1:OnSpellStart()
	if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
		self:GetCursorTarget():TriggerSpellReflect(self)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_bloodthor_custom_active",{duration = self:GetSpecialValueFor("duration")})
	end
end 

modifier_bloodthor_custom = modifier_bloodthor_custom or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_bloodthor_custom:OnCreated()
	self.atkspeed = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.mp = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.chance = self:GetAbility():GetSpecialValueFor("passive_chance_crit")
	self.critical = self:GetAbility():GetSpecialValueFor("passive_critical") 
	if self:GetCaster().GetBuilding then
		self:StartIntervalThink(0.5)
	end
end

function modifier_bloodthor_custom:OnIntervalThink()
	if IsServer()   then
		local unit = self:GetParent():GetRandomUnitRadius(1000,{
			team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		})
		if unit and self:GetAbility():IsFullyCastable() then
			self:StartIntervalThink(self:GetAbility():GetCastPoint() + 0.4)
			self:GetParent():CastAbilityOnTarget(unit, self:GetAbility(), -1)
		end
	end
end

function modifier_bloodthor_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_bloodthor_custom:GetModifierAttackSpeedBonus_Constant() return self.atkspeed end
function modifier_bloodthor_custom:GetModifierPreAttack_BonusDamage() return self.damage end
function modifier_bloodthor_custom:GetModifierConstantManaRegen() return self.mp end
function modifier_bloodthor_custom:GetModifierPreAttack_CriticalStrike() 
	if RollPercentage(self.chance) then
		return self.critical
	end
end

modifier_bloodthor_custom_active = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

function modifier_bloodthor_custom_active:OnCreated()
	self.damage = 0
	self.criticalActive = self:GetAbility():GetSpecialValueFor("critical_active")
	self.damageEnd = self:GetAbility():GetSpecialValueFor("damage_end")
end 

function modifier_bloodthor_custom_active:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bloodthor_custom_active:OnTooltip()
	return self.criticalActive
end

function modifier_bloodthor_custom_active:OnAttackStart(keys)
	local parent = self:GetParent()
	if parent == keys.target then
		local ability = self:GetAbility()
		local attacker = keys.attacker
		parent:AddNewModifier(attacker, ability, "modifier_bloodthor_custom_critical", {duration = 1})
	end
end

function modifier_bloodthor_custom_active:OnTakeDamage(event)
	if IsServer() and self:GetParent() == event.unit then
		self.damage = self.damage + (event.damage * self.damageEnd/100)
	end
end

function modifier_bloodthor_custom_active:OnDestroy()
	if IsServer() then
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage(damage)
	end
end

function modifier_bloodthor_custom_active:GetEffectName()
    return "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf"
end

function modifier_bloodthor_custom_active:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_bloodthor_custom_active:CheckState()
	return {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true}
end

modifier_bloodthor_custom_critical = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})


function modifier_bloodthor_custom_critical:OnCreated()
	self.criticalActive = self:GetAbility():GetSpecialValueFor("critical_active")
end
function modifier_bloodthor_custom_critical:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED		
	}
end

function modifier_bloodthor_custom_critical:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		if keys.target == self:GetParent() and keys.target:HasModifier("modifier_bloodthor_custom_active") then
			return self.criticalActive
		else
			self:Destroy()
		end
	end
end

function modifier_bloodthor_custom_critical:OnAttackLanded(keys)
	if IsServer() and self:GetCaster() == keys.attacker then
		keys.attacker:RemoveModifierByName("modifier_bloodthor_custom_critical")
	end
end