crystal_maiden_crystal_nova_custom = class({
	OnSpellStart 	= function(self)
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local radius = self:GetSpecialValueFor('radius')
		local damage = self:GetSpecialValueFor('nova_damage')
		local duration = self:GetSpecialValueFor('duration')
		EmitSoundOn('Hero_Crystal.CrystalNova', caster:GetOwner())
		local nfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, self.caster );
		ParticleManager:SetParticleControl(nfx, 0, point)
		ParticleManager:SetParticleControl(nfx, 1, Vector(0,radius,radius))
		ParticleManager:ReleaseParticleIndex( nfx )

		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)

		for k,v in pairs(units) do
			ApplyDamage({
				attacker = caster,
				damage = damage,
				victim = v,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			})
			if v:IsAlive() then 
				v:AddNewModifier(caster, self, 'modifier_crystal_nova_debuff', {
					duration = duration,
				})
			end
		end
	end,
})
LinkLuaModifier('modifier_crystal_nova_debuff', 'abilityHero/CrystalMaiden/crystal_maiden_crystal_nova_custom', LUA_MODIFIER_MOTION_NONE)
modifier_crystal_nova_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.move = self.ability:GetSpecialValueFor('movespeed_slow')
	end,

	DeclareFunctions 		= function(self)
		return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	end,

	GetModifierMoveSpeedBonus_Percentage = function(self) return self.move end,

})