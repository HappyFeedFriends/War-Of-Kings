ability_creep_healing = class({})

function ability_creep_healing:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster, self, 'modifier_ability_healing', {duration = 3})
end
LinkLuaModifier('modifier_ability_healing', 'abilityCreep/ability_creep_healing', LUA_MODIFIER_MOTION_NONE)
modifier_ability_healing = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions		= function(self)
		return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
	end,
	GetModifierHealthRegenPercentage 	= function(self) return 4.35 end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/items_fx/healing_flask_b.vpcf' end,

})