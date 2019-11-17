LinkLuaModifier("modifier_item_healing_armor", "items/item_healing_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_healing_armor_regen", "items/item_healing_armor", LUA_MODIFIER_MOTION_NONE)
item_healing_armor = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_item_healing_armor' end,
})

modifier_item_healing_armor =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		if not self:GetAbility() then return end
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.duration_healing = self.ability:GetSpecialValueFor('duration_healing')
		self.cooldown = self.ability:GetCooldown(1)
		self.bonus_health = self.ability:GetSpecialValueFor('bonus_health')
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		}
	end,
	GetModifierExtraHealthBonus = function(self) return self.bonus_health end,
})
modifier_item_healing_armor_regen = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.heal = self.ability:GetSpecialValueFor('heal')
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		}
	end,
	GetModifierHealthRegenPercentage = function(self) return self.heal end,
})
function modifier_item_healing_armor:OnShieldRemove(data)
	if not self.ability:IsCooldownReady() then return end
	self.parent:AddNewModifier(self.parent, self.ability, 'modifier_item_healing_armor_regen', {
		duration = self.duration_healing
	})
	self.ability:StartCooldown(self.cooldown)
end