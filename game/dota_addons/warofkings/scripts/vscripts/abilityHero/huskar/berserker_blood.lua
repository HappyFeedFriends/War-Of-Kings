LinkLuaModifier ("modifier_berserker_blood_custom", "abilityHero/huskar/berserker_blood.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_berserker_blood_custom_damage", "abilityHero/huskar/berserker_blood.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_berserker_blood_custom_atk_speed", "abilityHero/huskar/berserker_blood.lua", LUA_MODIFIER_MOTION_NONE)
huskar_berserker_blood_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_berserker_blood_custom' end,
})

modifier_berserker_blood_custom_damage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
    GetModifierPreAttack_BonusDamage    = function(self) return self:GetStackCount() end,
})

modifier_berserker_blood_custom_atk_speed = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
    GetModifierAttackSpeedBonus_Constant    = function(self) return self:GetStackCount() end,
})

modifier_berserker_blood_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		if IsServer() then
			if not self:GetParent():GetOwner() then return end
			self.ability	= self:GetAbility()
			self.caster		= self:GetCaster()
			self.parent		= self:GetParent()
			self.floor = self:GetAbility():GetSpecialValueFor('hp_threshold_max')
			self.maxAttackSpeed = self:GetAbility():GetSpecialValueFor('maximum_attack_speed')
			self.maxDamage = self:GetAbility():GetSpecialValueFor('maximum_damage')
			self.maxhealth = self.parent:GetOwner():GetMaxHealth()
			self:StartIntervalThink(0.1)
		end
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then
			local parent = self.parent
			local floor = self.floor
			local maxAttackSpeed = self.maxAttackSpeed
			local maxDamage = self.maxDamage
			local healthPct = parent:GetOwner():GetHealthPercent()
			-- don't read this code if you want to stay in your mind
			local p = self.maxhealth * (floor/100)
			local a = math.max((healthPct - p) / (self.maxhealth - p),0)
			local bonusAttackSpeed = (1-a) * maxAttackSpeed
			local bonusDamage = (1-a) * maxDamage
			local modifierAttackSpeed = parent:FindModifierByName('modifier_berserker_blood_custom_atk_speed') or parent:AddNewModifier(parent,self,'modifier_berserker_blood_custom_atk_speed',{duration = -1})
			local modifierDamage = parent:FindModifierByName('modifier_berserker_blood_custom_damage') or parent:AddNewModifier(parent,self,'modifier_berserker_blood_custom_damage',{duration = -1})
			if modifierAttackSpeed and modifierAttackSpeed:GetStackCount() ~= bonusAttackSpeed then
				modifierAttackSpeed:SetStackCount(bonusAttackSpeed)
			end
			if modifierDamage and modifierDamage:GetStackCount() ~= bonusDamage then
				modifierDamage:SetStackCount(bonusDamage)
			end
		end
	end,
	OnRefresh = 	function(self)
		if not IsServer() then return end
		self.floor = self:GetAbility():GetSpecialValueFor('hp_threshold_max')
		self.maxAttackSpeed = self:GetAbility():GetSpecialValueFor('maximum_attack_speed')
		self.maxDamage = self:GetAbility():GetSpecialValueFor('maximum_damage')
	end,
})

