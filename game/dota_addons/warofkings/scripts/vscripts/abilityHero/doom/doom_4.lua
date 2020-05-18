doom_4 = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()

		target:AddNewModifier(caster, self, 'modifier_doom_4_debuff', {
           duration = self:GetSpecialValueFor('duration')
		})
	end,
})

LinkLuaModifier("modifier_doom_4_debuff", "abilityHero/doom/doom_4", LUA_MODIFIER_MOTION_NONE)
modifier_doom_4_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function(self) return {MODIFIER_ATTRIBUTE_MULTIPLE} end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_EVENT_ON_DEATH
		}
	end,	
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.radius = self.ability:GetSpecialValueFor('radius')
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.damage_per_tick = self.ability:GetSpecialValueFor('damage_per_tick')
		self.duration = self.ability:GetSpecialValueFor('duration')
		self:StartIntervalThink(1)
	end,
	OnIntervalThink 		= function(self)
		if IsClient() then return end
		ApplyDamage({
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage_per_tick,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability,
		})
	end,
	OnDeath = function(self,data) 
		if IsClient() or data.unit ~= self.parent then return end
		local IsAssembly = self.caster:IsAssembly('doom_upgrade_2')
		local units = FindUnitsInRadius(self.parent:GetTeamNumber(),
		self.caster:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)

		for k,v in pairs(units) do
			if v ~= self.parent then 
				if IsAssembly then 
					v:AddNewModifier(self.caster, self.ability, 'modifier_doom_4_debuff',{
						duration = self.duration,
					})
				end
				ApplyDamage({
					victim = v,
					attacker = self.caster,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability,
				})
			end
		end
	end,
})