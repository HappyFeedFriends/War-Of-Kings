LinkLuaModifier('modifier_ability_creep_movespeed', 'abilityCreep/ability_creep_movespeed', LUA_MODIFIER_MOTION_NONE)
ability_creep_movespeed = class({})

function ability_creep_movespeed:OnSwapPathCorner(data)
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, 'modifier_ability_creep_movespeed', {duration = 2})
end

modifier_ability_creep_movespeed = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf' end,
	GetModifierMoveSpeedBonus_Percentage 	= function(self) return 50 end,
})
