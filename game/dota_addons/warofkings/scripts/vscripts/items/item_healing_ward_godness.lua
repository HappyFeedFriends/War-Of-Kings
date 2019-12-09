LinkLuaModifier("modifier_item_healing_ward_godness", "items/item_healing_ward_godness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_healing_ward_godness_aura", "items/item_healing_ward_godness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_healing_ward_godness_ai", "items/item_healing_ward_godness", LUA_MODIFIER_MOTION_NONE)
item_healing_ward_godness = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_healing_ward_godness_ai' end,
	OnSpellStart = function(self)
		self.healing = self:GetSpecialValueFor('healing')
		self.bonus_damage = self:GetSpecialValueFor('bonus_damage')
		self.amplify = self:GetSpecialValueFor('amplify')
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, 'modifier_item_healing_ward_godness_aura', {
			duration = self:GetSpecialValueFor('duration')
		})
		-- CreateModifierThinker(caster, self, 'modifier_item_healing_ward_godness_aura', {
		-- 	duration = self:GetSpecialValueFor('duration')
		-- }, self:GetCursorPosition(), caster:GetTeam(), false)
	end,
})

modifier_item_healing_ward_godness_ai = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated = function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		if not self.parent.GetBuilding then return end
		self:StartIntervalThink(1)
	end,	
	OnIntervalThink = function(self)
		if not IsServer() then return end
		if self.ability:IsFullyCastable() then 
			self.parent:CastAbilityOnPosition(self.parent:GetAbsOrigin(), self.ability, -1)
		end
	end,
})

modifier_item_healing_ward_godness = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	end,
	OnCreated = function(self)
		self.ability = self:GetAbility()
		print(self.ability.healing)
	end,	
	GetModifierSpellAmplify_Percentage = function(self) return self.ability.amplify end,
	GetModifierPreAttack_BonusDamage = function(self) return self.ability.bonus_damage end,
	GetModifierHealthRegenPercentage = function(self) return self.ability.healing end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/items_fx/healing_flask.vpcf' end,
})
modifier_item_healing_ward_godness_aura = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	GetAuraRadius 			= function(self) return -1 end,
	GetAuraSearchTeam 		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetAuraSearchFlags      = function(self) return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end,
	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end,
	GetModifierAura 		= function(self) return 'modifier_item_healing_ward_godness' end,
	OnCreated 				= function(self)
		if IsServer() then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.pID = self.parent:GetPlayerOwnerID()
		end
	end,

})

function modifier_item_healing_ward_godness_aura:GetAuraEntityReject(hEntity)
    return not hEntity.GetBuilding or hEntity.GetBuilding():GetPlayerOwnerID() ~= self.pID
end
