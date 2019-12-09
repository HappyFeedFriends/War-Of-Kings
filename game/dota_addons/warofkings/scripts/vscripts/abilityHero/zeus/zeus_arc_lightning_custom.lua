zeus_arc_lightning_custom = class({
	OnSpellStart 	= function(self)
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local arc_damage = self:GetSpecialValueFor_Custom('arc_damage','zeus_upgrade_1')
		EmitSoundOn('Hero_Zuus.ArcLightning.Cast', caster:GetOwner())
		local bolt = ParticleManager:CreateParticle('particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf', PATTACH_WORLDORIGIN, caster)
   	 	ParticleManager:SetParticleControl(bolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    	ParticleManager:SetParticleControl(bolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))	
		ApplyDamage({
			attacker = caster,
			damage = arc_damage,
			victim = target,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		})
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			target:GetOrigin(),
			nil,
			self:GetSpecialValueFor('radius'),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
		for k,v in pairs(units) do
			if v ~= target then
				local bolt = ParticleManager:CreateParticle('particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf', PATTACH_WORLDORIGIN, target)
   	 			ParticleManager:SetParticleControl(bolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
    			ParticleManager:SetParticleControl(bolt,1,Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z + v:GetBoundingMaxs().z ))	
				ApplyDamage({
					attacker = caster,
					damage = arc_damage,
					victim = v,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				})
			end
		end
	end,
})
