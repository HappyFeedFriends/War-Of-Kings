item_armor_aura = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_armor_aura_aura' end,
})
LinkLuaModifier('modifier_item_armor_aura_aura', 'items/item_armor_aura.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_armor_aura_buff', 'items/item_armor_aura.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_armor_aura_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_item_armor_aura_buff' end,
	OnCreated 				= function(self)
		self.radius = self:GetAbility():GetSpecialValueFor('radius')
		self:GetAbility().armor = self:GetAbility():GetSpecialValueFor('armor')
	end,
})

function modifier_item_armor_aura_aura:GetAuraEntityReject(hEntity)
	return not hEntity.GetBuilding
end
modifier_item_armor_aura_buff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		}
	end,
	OnCreated 	= function(self)
		self.ability = self:GetAbility()
	end,
	GetModifierPhysicalArmorBonus = function(self) return self.ability.armor end,
})