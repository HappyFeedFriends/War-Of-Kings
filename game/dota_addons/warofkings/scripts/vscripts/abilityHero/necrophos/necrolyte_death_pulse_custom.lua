necrolyte_death_pulse_custom = class({
	OnSpellStart = function(self)
			local caster = self:GetCaster()
			local abs = caster:GetAbsOrigin()
			self.healing = self:GetSpecialValueFor('heal')
			self.abs = abs
			local unit = FindUnitsInRadius(caster:GetTeam(), 
			abs, 
			nil, 
			1100,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)	
		for k,v in pairs(unit) do	
			ProjectileManager:CreateTrackingProjectile({
				Target = v,
				Source = caster,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
				bDodgeable = true,
				bProvidesVision = true,
				iMoveSpeed = 700,
				iVisionRadius = 250,
				iVisionTeamNumber = caster:GetTeamNumber(),
			})
		end
	end,
})
function necrolyte_death_pulse_custom:OnProjectileHit( hTarget, vLocation ) 
	if hTarget then 
		if hTarget ~= self:GetCaster() then
			ApplyDamage({
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetSpecialValueFor('damage'),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			})
			ProjectileManager:CreateTrackingProjectile({
				Target = self:GetCaster(),
				Source = hTarget,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
				bDodgeable = true,
				bProvidesVision = true,
				iMoveSpeed = 1300,
				iVisionRadius = 250,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			})
		else 
			if card:IsAssemblyCard(hTarget:GetUnitName(),'necrophos_upgrade_1',hTarget:GetOwner():GetPlayerID()) and hTarget:GetHealth() == hTarget:GetMaxHealth() then
				local data = card:GetDataCard(hTarget:GetUnitName()).Assemblies.necrophos_upgrade_1.data
				local count = data.value 
				local healPct = data.heal
				local unit = FindUnitsInRadius(hTarget:GetTeam(), 
					self.abs, 
					nil, 
					600,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_CLOSEST,
					false)
				if #unit > 0 then 
					for i=1,count do 
						if unit[i] and unit[i] ~= hTarget then
							unit[i]:Heal(self.healing/100 * healPct,hTarget)
						end
					end
				end
				return
			end
			hTarget:Heal(self.healing,hTarget)
		end
	end
end
-- OnProjectileHit