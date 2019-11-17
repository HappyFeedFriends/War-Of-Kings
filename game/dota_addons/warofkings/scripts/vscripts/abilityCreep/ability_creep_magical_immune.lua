ability_creep_magical_immune = class({})

function ability_creep_magical_immune:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, 'modifier_ability_creep_magical_immune', {duration = 3})
end
LinkLuaModifier('modifier_ability_creep_magical_immune', 'abilityCreep/ability_creep_magical_immune', LUA_MODIFIER_MOTION_NONE)
modifier_ability_creep_magical_immune = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/items_fx/black_king_bar_avatar_b.vpcf' end,
	CheckState 				= function(self) return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	end,
})