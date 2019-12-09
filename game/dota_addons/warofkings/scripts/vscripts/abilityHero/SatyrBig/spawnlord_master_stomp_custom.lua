spawnlord_master_stomp_custom = class({
	OnSpellStart 	= function( self )
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor('radius')
		local damage = self:GetSpecialValueFor('damage')
		local duration = self:GetSpecialValueFor('duration')
		local nfx = ParticleManager:CreateParticle("particles/neutral_fx/neutral_prowler_shaman_stomp.vpcf", PATTACH_CUSTOMORIGIN,caster );
		ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 1, Vector(radius,radius,radius))
		ParticleManager:ReleaseParticleIndex( nfx )

		local units = FindUnitsRadiusDefaultAbility(radius,caster:GetOrigin(),caster)

		for k,v in pairs(units) do
			ApplyDamage({
				attacker  = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self,
				victim = v,
			})
			if v:IsAlive() then 
				v:AddNewModifier(caster, self, 'modifier_spawnlord_master_stomp_custom_debuff', {
					duration = duration
				})
			end
		end
	end
})

LinkLuaModifier('modifier_spawnlord_master_stomp_custom_debuff', 'abilityHero/SatyrBig/spawnlord_master_stomp_custom', LUA_MODIFIER_MOTION_NONE)
modifier_spawnlord_master_stomp_custom_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.armor = -(self:GetParent():GetPhysicalArmorValue(false) / 100 * self.ability:GetSpecialValueFor('armor_reduction_pct'))
	end,
	DeclareFunctions 		= function(self) return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end,
	GetModifierPhysicalArmorBonus 	= function(self) return self.armor end,
})

