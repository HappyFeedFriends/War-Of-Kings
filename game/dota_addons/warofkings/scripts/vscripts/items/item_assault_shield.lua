item_assault_shield = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_assault_shield' end,
})
LinkLuaModifier('modifier_item_assault_shield', 'items/item_assault_shield.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_assault_shield = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.bonus_shield = self.ability:GetSpecialValueFor('bonus_shield')
		self.max_health_shield = self.ability:GetSpecialValueFor('max_health_shield')
		self.bonus_health = self.ability:GetSpecialValueFor('bonus_health')
		self.cooldown  = self.ability:GetSpecialValueFor('shield_cooldown_tooltip')
		self.parent = self:GetParent()
		self.building = self.parent.GetBuilding
		if self.building then 
			self.ability:StartCooldown(self.cooldown)
			self:StartIntervalThink(self.cooldown)
		end
	end,
	OnIntervalThink 	= function(self)
		if IsServer() then 
			local modif = self.parent:FindModifierByName('modifier_shield')
			local bLimitHp = modif and modif:GetStackCount()/self.parent:GetMaxHealth()*100 > self.max_health_shield
			if not bLimitHp then
				self.ability:StartCooldown(self.cooldown)
				self.building():AddShield(self.bonus_shield,self.ability)
			end
		end
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		}
	end,
	GetModifierExtraHealthBonus = function(self) return self.bonus_health end,
})
