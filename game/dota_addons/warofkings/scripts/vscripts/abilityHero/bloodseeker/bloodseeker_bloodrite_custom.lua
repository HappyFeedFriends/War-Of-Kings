bloodseeker_bloodrite_custom = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local point =  self:GetCursorPosition()
		CreateModifierThinker(caster, self, 'modifier_bloodrite_aura', {
			duration = self:GetSpecialValueFor('duration')
		}, point, caster:GetTeam(), false)
	end,
	GetIntrinsicModifierName = function(self) return 'bloodseeker_bloodrite_passive' end,
})
LinkLuaModifier('modifier_bloodrite_aura', 'abilityHero/bloodseeker/bloodseeker_bloodrite_custom.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_bloodrite_debuff', 'abilityHero/bloodseeker/bloodseeker_bloodrite_custom.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_bloodrite_debuff_main', 'abilityHero/bloodseeker/bloodseeker_bloodrite_custom.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('bloodseeker_bloodrite_passive', 'abilityHero/bloodseeker/bloodseeker_bloodrite_custom.lua', LUA_MODIFIER_MOTION_NONE)
bloodseeker_bloodrite_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return { MODIFIER_EVENT_ON_ABILITY_EXECUTED } end,
})
function bloodseeker_bloodrite_passive:OnAbilityExecuted(data)
	local parent = self:GetParent()
	if data.unit ~= parent then return end
	local pID = self:GetCaster():GetPlayerOwnerID()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		parent:GetOrigin(),
		nil,
		-1,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)
	for k,v in pairs(units) do
		if v.playerRound == pID and v:HasModifier('modifier_bloodrite_debuff_main') then 
			ApplyDamage({
				victim = v,
				attacker = parent,
				damage = self:GetAbility():GetSpecialValueFor('damage_per_use'),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			})
		end
	end
end

modifier_bloodrite_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_bloodrite_debuff' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.radius = self.ability :GetSpecialValueFor('radius')
			self.duration = self.ability :GetSpecialValueFor_Custom('duration_creep','bloodseeker_upgrade_2')
			self.parent = self:GetParent()
			self.caster = self:GetCaster()
			self.nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring_lv.vpcf", PATTACH_CUSTOMORIGIN, self.caster );
			ParticleManager:SetParticleControl(self.nfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.nfx, 1, Vector(self.radius,self.radius,self.radius))
		end
	end,
	OnDestroy = function(self)
		if self.nfx then
			ParticleManager:DestroyParticle(self.nfx, true)
			ParticleManager:ReleaseParticleIndex( self.nfx )
		end
	end,
})
modifier_bloodrite_debuff_main = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf' end,
})

modifier_bloodrite_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		if IsServer() and self:GetAbility() and not self:GetParent():HasModifier('modifier_bloodrite_debuff_main') then 
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_bloodrite_debuff_main', {
				duration = self:GetAbility().duration
			})
		end
	end,
})