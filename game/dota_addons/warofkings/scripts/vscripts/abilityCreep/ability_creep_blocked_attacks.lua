ability_creep_blocked_attacks = class({
	
})

function ability_creep_blocked_attacks:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	if not caster:HasModifier('modifier_ability_creep_blocked_attacks') then
		local modifier = caster:AddNewModifier(caster, self, 'modifier_ability_creep_blocked_attacks', {duration = 10})
		modifier:SetStackCount(5)
	end
end
LinkLuaModifier('modifier_ability_creep_blocked_attacks', 'abilityCreep/ability_creep_blocked_attacks', LUA_MODIFIER_MOTION_NONE)
modifier_ability_creep_blocked_attacks = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		local caster = self:GetParent()
		self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        self:AddParticle( self.particle, false, false, -1, false, true )
	end,
	OnDestroy 		= function(self)
		if self.particle then 
			ParticleManager:DestroyParticle(self.particle, true)
			ParticleManager:ReleaseParticleIndex( self.particle );
		end
	end,
})