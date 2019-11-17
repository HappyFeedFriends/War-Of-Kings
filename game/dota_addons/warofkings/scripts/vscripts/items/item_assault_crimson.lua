item_assault_crimson  = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_assault_crimson' end,
})
LinkLuaModifier('modifier_item_assault_crimson', 'items/item_assault_crimson.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_assault_crimson_buff', 'items/item_assault_crimson.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_assault_crimson = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_item_assault_crimson_buff' end,
	OnCreated 				= function(self)
		self.radius = self:GetAbility():GetSpecialValueFor('radius')
	end,
})

function modifier_item_assault_crimson:GetAuraEntityReject(hEntity)
	return not hEntity.GetBuilding
end
modifier_item_assault_crimson_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		self.damage = self:GetAbility():GetSpecialValueFor('bonus_damage_aura')
		self.amp = self:GetAbility():GetSpecialValueFor('bonus_amp_aura')
		self.atk = self:GetAbility():GetSpecialValueFor('bonus_atk_speed_aura')
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		}
	end,
	GetModifierAttackSpeedBonus_Constant = function(self) return self.atk end,
	GetModifierPreAttack_BonusDamage = function(self) return self.damage end,
	GetModifierSpellAmplify_Percentage = function(self) return self.amp end,
})