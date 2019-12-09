crystal_maiden_freezing_field_custom = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local point = caster:GetOrigin()
		self.move = self:GetSpecialValueFor('movespeed_slow')
		self.expRadius = self:GetSpecialValueFor('explosion_radius')
		self.expMin = self:GetSpecialValueFor('explosion_min_dist')
		self.expMax = self:GetSpecialValueFor('explosion_max_dist')
		self.damage = self:GetSpecialValueFor('damage')
		self.aura = self:GetSpecialValueFor('radius')
		CreateModifierThinker(caster, self, 'modifier_crystal_maiden_field_aura', {
			duration = self:GetSpecialValueFor('duration_tooltip')
		}, point, caster:GetTeam(), false)
	end,
})

LinkLuaModifier('modifier_crystal_maiden_field_aura', 'abilityHero/CrystalMaiden/crystal_maiden_freezing_field_custom', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_crystal_maiden_field_debuff', 'abilityHero/CrystalMaiden/crystal_maiden_freezing_field_custom', LUA_MODIFIER_MOTION_NONE)
modifier_crystal_maiden_field_aura = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_crystal_maiden_field_debuff' end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.radius = self.ability.aura
		self.max = self.ability.expMax
		self.min = self.ability.expMin
		self.expRadius = self.ability.expRadius
		self.damage = self.ability.damage
		self.nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, self.parent );
		ParticleManager:SetParticleControl(self.nfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.nfx, 1, Vector(self.radius,self.radius,self.radius))
		self:StartIntervalThink(0.1)
	end,
	OnIntervalThink 		= function(self)
		if not IsServer() then  return end
		local pos = self.parent:GetOrigin() + RandomVector(RandomInt(self.min,self.max))
		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_CUSTOMORIGIN, self.parent );
		ParticleManager:SetParticleControl(nfx, 0, pos)
		ParticleManager:SetParticleControl(nfx, 1, Vector(self.expRadius,self.expRadius,self.expRadius))
		ParticleManager:ReleaseParticleIndex( nfx )

		local units = FindUnitsInRadius(self.parent:GetTeamNumber(),
		pos,
		nil,
		self.expRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
		for k,v in pairs(units) do
			ApplyDamage({
				victim = v,
				attacker = self.parent,
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			})
		end
	end,
	OnDestroy 				= function(self)
		if self.nfx then 
			ParticleManager:ReleaseParticleIndex( self.nfx )
			ParticleManager:DestroyParticle(self.nfx, true)
		end
	end,
-- particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf
})

modifier_crystal_maiden_field_debuff = class({
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
		if not self.ability then self:Destroy()  return end
		self.move = self.ability.move
	end,

	DeclareFunctions 		= function(self)
		return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	end,

	GetModifierMoveSpeedBonus_Percentage = function(self) return self.move end,
})