item_soul_book = class({
	GetIntrinsicModifierName = function(self) return 'modifier_soul_book' end,
	OnSpellStart 		= function(self)
		CreateModifierThinker(self:GetCaster(), self, 'modifeir_soul_book_aura', {duration = self:GetSpecialValueFor('duration')}, self:GetCursorPosition(), self:GetTeam(), false)
	end,
})

-- GetIntrinsicModifierName = function(self) return 'modifier_item_assault_crimson' end,
LinkLuaModifier('modifeir_soul_book_aura', 'items/item_soul_book.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_soul_book', 'items/item_soul_book.lua', LUA_MODIFIER_MOTION_NONE)

modifier_soul_book = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self) 
		self.amp = self:GetAbility():GetSpecialValueFor('bonus_amp')
		if self:GetParent().GetBuilding then
			self:StartIntervalThink(0.2)
		end
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then
			if self:GetAbility():IsFullyCastable()  then
				local unit = self:GetParent():GetRandomUnitRadius(1000,{
					team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				})
				if unit then
					-- self:StartIntervalThink(self:GetAbility():GetCastPoint() + 0.3)
					self:GetParent():CastAbilityOnPosition(unit:GetAbsOrigin(), self:GetAbility(), -1)
				end
			end
		end
	end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}	end,
	GetModifierSpellAmplify_Percentage 	= function(self) return self.amp end,
})

modifeir_soul_book_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	--[[IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return self.radius end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_ENEMY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_soul_book_debuff' end,]]
	OnCreated 				= function(self)
		self.radius = self:GetAbility():GetSpecialValueFor('radius')
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.damage = self:GetAbility():GetSpecialValueFor('damage_per_tick')
		self.pertick = self:GetAbility():GetSpecialValueFor('damage_per_health')
		self.ability = self:GetAbility()
		self:StartIntervalThink(1)
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then
			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)	
			ParticleManager:SetParticleControl(iParticle, 0, self.parent:GetOrigin())
			ParticleManager:SetParticleControl(iParticle, 4, Vector(self.radius, self.radius, self.radius))
			ParticleManager:SetParticleControl(iParticle, 5, Vector(self.radius, self.radius, self.radius))
			local units = FindUnitsInRadius(
				self.parent:GetTeam(), 
				self.parent:GetAbsOrigin(), 
				nil,
				self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,
				false)
			for k,v in pairs(units) do
				ApplyDamage({
					victim = v,
					attacker = self.caster,
					damage = self.damage + v:GetHealth()/100 * self.pertick,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability
				})
			end
		end
	end,
})