ability_creep_invulneable = class({

})

function ability_creep_invulneable:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, 'modifier_ability_creep_invulneable', {duration = 2})
end
LinkLuaModifier('modifier_ability_creep_invulneable', 'abilityCreep/ability_creep_invulneable', LUA_MODIFIER_MOTION_NONE)
modifier_ability_creep_invulneable = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_omniknight/omniknight_repel_buff_b.vpcf' end,
	CheckState 				= function(self) return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	end,
})