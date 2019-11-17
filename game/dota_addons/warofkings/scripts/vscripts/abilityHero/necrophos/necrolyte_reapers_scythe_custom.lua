necrolyte_reapers_scythe_custom = class({
	OnSpellStart = 	function(self)
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local abs = target:GetAbsOrigin()
		local delay = self:GetSpecialValueFor('delay')
		local damage = self:GetSpecialValueFor_Custom('damage','necrophos_upgrade_2')
		local nfx = ParticleManager:CreateParticle( "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", PATTACH_CUSTOMORIGIN, caster );
		ParticleManager:SetParticleControl(nfx, 0, abs)
		ParticleManager:SetParticleControl(nfx, 1, abs)
		ParticleManager:ReleaseParticleIndex( nfx )
		target:AddNewModifier(caster, self, 'modifier_stunned', {
           duration = delay,
		})
		Timers:CreateTimer(delay,function()
			if target:IsAlive() and not target:IsNull() then
				ApplyDamage({
					victim = target,
					attacker = caster,
					damage = target:GetHealth() / 100 * damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				})
			end
		end)
	end,
})