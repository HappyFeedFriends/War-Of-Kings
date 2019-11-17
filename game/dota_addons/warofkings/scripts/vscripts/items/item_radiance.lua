LinkLuaModifier('modifier_radiance_custom_aura', 'items/item_radiance.lua', LUA_MODIFIER_MOTION_NONE)

item_radiance_2 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_radiance_custom_aura' end,
})
item_radiance_3 = item_radiance_2
item_radiance_godness = item_radiance_2

modifier_radiance_custom_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.bonus_dmg = self.ability:GetSpecialValueFor('bonus_dmg')
		self.interval = self.ability:GetSpecialValueFor('interval')
		self.radius = self.ability:GetSpecialValueFor('radius')
		self:StartIntervalThink(self.interval)
		self.parent = self:GetParent()
	end,
	DeclareFunctions 	= function()
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		}
	end,
	GetModifierPreAttack_BonusDamage 	= function(self) return self.bonus_dmg end,
	OnIntervalThink = 	function(self)
		if IsServer() then
			local units = FindUnitsInRadius(self.parent:GetTeamNumber(),
				self.parent:GetOrigin(),
				nil,
				self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,
				false)
			for _,v in pairs(units) do
				ApplyDamage({
					victim = v,
					attacker = self.parent,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability,
				})
			end
		end
	end,
})