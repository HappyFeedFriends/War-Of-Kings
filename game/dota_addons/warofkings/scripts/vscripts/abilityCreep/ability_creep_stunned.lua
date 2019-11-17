ability_creep_stunned = class({

})

function ability_creep_stunned:OnSwapPathCorner(data) -- custom event
	local newPathCorner = data.newPathCorner
	local nextPathCorner = data.nextPathCorner
	local caster = self:GetCaster()
	local target = caster:GetRandomUnitRadius(800,{
		team = DOTA_UNIT_TARGET_TEAM_ENEMY,
		target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	},function(unit)
		return unit.GetBuilding and not unit:IsStunned()
	end)
	if target then 
		ProjectileManager:CreateTrackingProjectile({
			Target = target,
			Source = caster,
			Ability = self,
			EffectName = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = 900,
			iVisionRadius = 250,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		})
	end
end

function ability_creep_stunned:OnProjectileHit( hTarget, vLocation )
	if hTarget then
		hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_stunned', {
			duration = 2,
		})
		self:RemoveSelf()
	end
end