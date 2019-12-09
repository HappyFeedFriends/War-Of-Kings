zeus_static_field_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_zeus_static_field_custom' end,
	GetManaCost 				 = function(self)
		return self:GetCaster():GetMaxMana() * 0.03
	end,


})

LinkLuaModifier ("modifier_zeus_static_field_custom", "abilityHero/zeus/zeus_static_field_custom.lua", LUA_MODIFIER_MOTION_NONE)

modifier_zeus_static_field_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self)
		return {MODIFIER_EVENT_ON_ABILITY_EXECUTED} 
	end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.ability:GetManaCost(self.ability:GetLevel())
	end,
})

function modifier_zeus_static_field_custom:OnAbilityExecuted(data)
	local abilityUse = data.ability
	local caster = data.unit 

	if self.ability:GetAutoCastState() and caster == self.parent and not abilityUse:IsItem() then 
		local ManaCost = self.ability:GetManaCost(1)
		if self.parent:GetMana() < ManaCost then return end
		local target = self.parent:GetRandomUnitRadius(1200,{
			team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		})
		if target then 
			ApplyDamage({
				attacker = caster,
				victim = target,
				damage = ManaCost + (self.parent:GetMana() / 100 * self.ability:GetSpecialValueFor_Custom('mana_damage','zeus_upgrade_2')),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self.ability,
			})
			self.parent:ReduceMana(ManaCost)
		end
	end
end