LinkLuaModifier ("modifier_burning_spear_custom", "abilityHero/huskar/burning_spear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_burning_spear_custom_debuff_damage", "abilityHero/huskar/burning_spear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_burning_spear_custom_debuff_counter", "abilityHero/huskar/burning_spear.lua", LUA_MODIFIER_MOTION_NONE)
huskar_burning_spear_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_burning_spear_custom' end,
})

modifier_burning_spear_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	--GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
	} end,
})

function modifier_burning_spear_custom:OnAttackLanded(params)
	if IsServer() and params.attacker == self:GetParent() and self:GetAbility():GetAutoCastState() and params.attacker:GetMana() >= 15 then
		params.attacker:ReduceMana(15.0)
		params.target:AddStackModifier({
			ability = self:GetAbility(),
			modifier  = 'modifier_burning_spear_custom_debuff_counter',
			duration = self:GetAbility():GetSpecialValueFor('duration_tooltip'),
			caster = self:GetCaster(),
			updateStack = true,
		})
		params.target:AddNewModifier(params.attacker, self:GetAbility(), 'modifier_burning_spear_custom_debuff_damage', {
			duration = self:GetAbility():GetSpecialValueFor('duration_tooltip'),
		})
	end
end

modifier_burning_spear_custom_debuff_damage = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self:StartIntervalThink(0.8)
	end,
	OnIntervalThink 		= function(self) 
		if IsServer() and self:GetAbility() then
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self:GetAbility():GetSpecialValueFor('burn_damage'),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			})
		end
	end,
	OnDestroy 			= function(self)
		if IsServer() and self:GetParent():HasModifier('modifier_burning_spear_custom_debuff_counter') then
			self:GetParent():AddStackModifier({
				ability = self:GetAbility(),
				modifier  = 'modifier_burning_spear_custom_debuff_counter',
				caster = self:GetCaster(),
				count = -1,
				updateStack = true,
			})
		end
	end,
})

modifier_burning_spear_custom_debuff_counter = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf' end,
})
