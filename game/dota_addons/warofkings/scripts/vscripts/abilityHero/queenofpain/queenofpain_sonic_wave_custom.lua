queenofpain_sonic_wave_custom = class({
	OnAbilityPhaseStart = function(self)
		self.cooldown = card:IsAssemblyCard(self:GetCaster():GetUnitName(),'queen_upgrade_1',self:GetCaster():GetOwner():GetPlayerID())
		return true
	end,
	OnSpellStart 	= function(self)
		local velocity = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
		velocity.z = 0
		velocity = velocity:Normalized()
		ProjectileManager:CreateLinearProjectile({
			EffectName = 'particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf',
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
			fStartRadius = 200,
			fEndRadius = 700,
			vVelocity = velocity * 1200,
			fDistance = self:GetSpecialValueFor( "distance" ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		})
	end,
})
function queenofpain_sonic_wave_custom:GetCooldown(iLevel)
	return self.cooldown and 35 or self.BaseClass.GetCooldown(self, iLevel)
end

function queenofpain_sonic_wave_custom:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
    if IsClient() then return end 
    if hTarget ~= nil then
        ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetSpecialValueFor( "damage" ),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self,
        })
        if self:GetCaster():HasScepter() then
        	hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_stunned', {
              duration = self:GetSpecialValueFor( "duration_stunned" )
        	})
        end
    end


    return false
end