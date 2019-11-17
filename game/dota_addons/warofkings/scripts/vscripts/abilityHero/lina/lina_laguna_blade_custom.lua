lina_laguna_blade_custom = class({
	OnSpellStart 	= function(self)
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil then
			local damage = self:GetSpecialValueFor( "damage" )
			local isAssembly = self:GetCaster():IsAssembly('lina_upgrade_3') -- card:IsAssemblyCard(self:GetCaster():GetUnitName(),'lina_upgrade_3',self:GetCaster():GetOwner():GetPlayerID())
			if isAssembly then
				local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
					hTarget:GetOrigin(),
					nil,
					card:GetDataCard(self:GetCaster():GetUnitName()).Assemblies['lina_upgrade_3'].data.value,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					false)
				for k,v in pairs(units) do
					ApplyDamage({
						victim = v,
						attacker = self:GetCaster(),
						damage = damage,
						damage_type = self:GetCaster():HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
						ability = self,
					})
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetOrigin(), true );
					ParticleManager:ReleaseParticleIndex( nFXIndex );
					EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )				
				end
			else
				ApplyDamage({
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = self:GetCaster():HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
					ability = self,
				})
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex );
				EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )
			end
		end
	end
})