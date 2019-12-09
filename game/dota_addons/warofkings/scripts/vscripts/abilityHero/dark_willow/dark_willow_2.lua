LinkLuaModifier("modifier_dark_willow_bedlam_custom", 'abilityHero/dark_willow/dark_willow_2.lua', LUA_MODIFIER_MOTION_NONE)
dark_willow_2 = class({
	OnSpellStart = function(self)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_dark_willow_bedlam_custom', {
			duration = self:GetSpecialValueFor('duration')
		})
	end,
})

modifier_dark_willow_bedlam_custom = class({
	IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,	
	GetEffectAttachType 	= function(self) return PATTACH_OVERHEAD_FOLLOW end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf' end,
	OnCreated 				= function(self)
		if not IsServer() then return end
		self.ability = self:GetAbility()
		self.chance = self.ability:GetSpecialValueFor('chance_stunned')
		self.dur_chance = self.ability:GetSpecialValueFor('duration_stunned')
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		local interval = self.caster:IsAssembly('dark_willow_2') and self.caster:GetSpecialValueForBuilding('dark_willow_2') or 0.65
		self:StartIntervalThink(interval)
	end,
	OnIntervalThink 		= function(self)
		if IsClient() then return end

		ApplyDamage({
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage,
			ability = self.ability,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})

		if RollPercentage(self.chance) then 
			self.parent:AddNewModifier(self.caster,self.ability, 'modifier_stunned', {
 				duration = self.dur_chance,
			})
		end
	end,
})