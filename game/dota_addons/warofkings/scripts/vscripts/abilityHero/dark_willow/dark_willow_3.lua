dark_willow_3 = class({
	OnSpellStart = function(self)

		local dur = self:GetSpecialValueFor('duration')
		local radius = self:GetSpecialValueFor('radius')
		local damage = self:GetSpecialValueFor('damage')
		local caster = self:GetCaster()
		local damage_type = caster:IsAssembly('dark_willow_1') and caster:GetSpecialValueForBuilding('dark_willow_1') or DAMAGE_TYPE_MAGICAL
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", PATTACH_CUSTOMORIGIN, self.caster );
		ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 1, Vector(radius,2,radius))
		ParticleManager:SetParticleControl(nfx, 60, Vector(RandomInt(10,240),RandomInt(10,240),RandomInt(10,240)))
		ParticleManager:SetParticleControl(nfx, 61, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( nfx );
		for k,v in pairs(units) do
			v:AddNewModifier(caster, self, 'modifier_fear_creep_custom', {
	          duration = dur,
			})
			ApplyDamage({
				victim = v,
				attacker = caster,
				damage = damage,
				damage_type = damage_type,
				ability = self,
			})
		end
	end,
})