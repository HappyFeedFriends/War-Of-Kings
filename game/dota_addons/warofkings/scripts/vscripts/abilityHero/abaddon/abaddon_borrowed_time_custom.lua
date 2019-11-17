LinkLuaModifier('modifier_abaddon_borrowed_custom', 'abilityHero/abaddon/abaddon_borrowed_time_custom', LUA_MODIFIER_MOTION_NONE)
abaddon_borrowed_time_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_abaddon_borrowed_custom' end,
})

modifier_abaddon_borrowed_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
	end,

})

function modifier_abaddon_borrowed_custom:OnFatalDamage(data)
	if not self.ability:IsCooldownReady() or not self.parent:GetPlayerOwner() then return end
	local health = 2
	if self:GetCaster():IsAssembly('abaddon_upgrade_1') then --card:IsAssemblyCard(self:GetCaster():GetUnitName(),'abaddon_upgrade_1',self:GetCaster():GetOwner():GetPlayerID()) then
		health = 1
	end
	self.parent:Heal(self.parent:GetMaxHealth()/health,self.parent)
	self.parent:AddNewModifier(self.parent, self.ability, 'modifier_invulnerable', {
		duration = self.ability:GetSpecialValueFor('duration')
	})
	self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
end
