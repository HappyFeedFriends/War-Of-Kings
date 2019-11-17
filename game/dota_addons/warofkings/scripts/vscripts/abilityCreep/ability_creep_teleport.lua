ability_creep_teleport = class({
	
})

function ability_creep_teleport:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	if newPathCorner:sub(#newPathCorner,#newPathCorner) ~= '9' then 
		local nfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_CUSTOMORIGIN, self.caster );
		ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nfx );
		FindClearSpaceForUnit(caster, nextPathCorner):GetAbsOrigin(), true)
	end
end