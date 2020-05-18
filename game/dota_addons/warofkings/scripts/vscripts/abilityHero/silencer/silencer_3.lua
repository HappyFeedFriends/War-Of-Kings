silencer_3 = class({
	OnSpellStart 		= function(self)
		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		local radius = self:GetSpecialValueFor('radius')
		local duration = self:GetSpecialValueFor('duration_silence')
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster);
		ParticleManager:SetParticleControl(nfx, 0, point)
		ParticleManager:SetParticleControl(nfx, 1, Vector(radius,radius,radius))
  		ParticleManager:ReleaseParticleIndex( nfx )
		for k,v in pairs(units) do
			v:AddNewModifier(caster, self, 'modifier_silencer_3_debuff',{
                 duration = duration
			})
		end
	end,	
})
LinkLuaModifier('modifier_silencer_3_debuff', 'abilityHero/silencer/silencer_3', LUA_MODIFIER_MOTION_NONE)

modifier_silencer_3_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.caster = self:GetCaster()
			self.int_mult = self.ability:GetSpecialValueFor('int_mult')
			self.damage = self.ability:GetSpecialValueFor_Custom('damage','silencer_5')
			self:StartIntervalThink(self.ability:GetSpecialValueFor('delay'))
		end
	end,
	CheckState 				= function(self)
		return {
			[MODIFIER_STATE_MUTED] = true,
		}
	end,
	GetEffectAttachType 	= function(self) return PATTACH_OVERHEAD_FOLLOW end,
	GetEffectName 			= function(self) return 'particles/econ/items/silencer/silencer_ti6/silencer_last_word_ti6_silence.vpcf' end,
	OnIntervalThink 		= function(self)
		if IsClient() then return end
		local intMult = (self.caster.GetIntellect and (self.caster:GetIntellect()) or 0) * self.int_mult
		ApplyDamage({
 			victim = self.parent,
 			attacker = self.caster,
 			ability = self.ability,
 			damage = self.damage + intMult,
 			damage_type = DAMAGE_TYPE_MAGICAL,
		})
		self:StartIntervalThink(-1)
	end,
})