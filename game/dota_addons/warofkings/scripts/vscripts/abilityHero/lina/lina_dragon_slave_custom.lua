lina_dragon_slave_custom = class({
	OnSpellStart 	= function(self)
		local velocity = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
		velocity.z = 0
		velocity = velocity:Normalized()
		ProjectileManager:CreateLinearProjectile({
			EffectName = 'particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf',
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
			fStartRadius = 250,
			fEndRadius = 250,
			vVelocity = velocity * 900,
			fDistance = 1250,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		})
	end
})

function lina_dragon_slave_custom:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
    if IsClient() then return end 
    if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
        ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetSpecialValueFor( "damage" ),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        })
        if self:GetCaster():IsAssembly('lina_upgrade_2')  then --card:IsAssemblyCard(self:GetCaster():GetUnitName(),'lina_upgrade_2',self:GetCaster():GetOwner():GetPlayerID()) then
	        hTarget:AddNewModifier(self:GetCaster(), self,'modifier_lina_dragon_slave_custom_debuff', {
	            duration = card:GetDataCard(self:GetCaster():GetUnitName()).Assemblies['lina_upgrade_2'].data.duration
	        })
    	end
    end


    return false
end

