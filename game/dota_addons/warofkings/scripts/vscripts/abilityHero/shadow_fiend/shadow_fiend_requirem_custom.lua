LinkLuaModifier ("modifier_shadow_fiend_requirem_custom_aura", "abilityHero/shadow_fiend/shadow_fiend_requirem_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_shadow_fiend_requirem_custom_debuff", "abilityHero/shadow_fiend/shadow_fiend_requirem_custom.lua", LUA_MODIFIER_MOTION_NONE)
shadow_fiend_requirem_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_shadow_fiend_requirem_custom_aura' end,
})
modifier_shadow_fiend_requirem_custom_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_shadow_fiend_requirem_custom_debuff' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.radius = self.ability:GetSpecialValueFor('radius')
		end
	end,
})

modifier_shadow_fiend_requirem_custom_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_EVENT_ON_DEATH
	} end,
	OnCreated = function(self)
		self.parent = self:GetParent()
		self.abiltiy = self:GetAbility()
		self.damage = self.abiltiy:GetSpecialValueFor('damage')
		self.attacker= self:GetCaster()
		self.damageaAOE = self.abiltiy:GetSpecialValueFor('radius_damage')
	end,
})

function modifier_shadow_fiend_requirem_custom_debuff:OnDeath(data)
	if not IsServer() then return end
	if data.unit == self.parent  then 
		local caster  = self.parent
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self.damageaAOE,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_CUSTOMORIGIN, data.unit );
		ParticleManager:SetParticleControl(nfx, 0, data.unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 1, data.unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 60, Vector(149,16,16))
		ParticleManager:SetParticleControl(nfx, 61, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( nfx );
		for _,unit in pairs(units) do
			if unit ~= data.unit then 
				ApplyDamage({
					victim = unit,
					attacker = self.attacker,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability,
				})
			end
		end	
	end
end
