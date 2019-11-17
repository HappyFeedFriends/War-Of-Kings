LinkLuaModifier('modifier_bloodseeker_bloodrage_custom', 'abilityHero/bloodseeker/bloodseeker_bloodrage_custom', LUA_MODIFIER_MOTION_NONE)
bloodseeker_bloodrage_custom = class({
	OnSpellStart 	= function(self)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_bloodseeker_bloodrage_custom', {
			duration = self:GetSpecialValueFor('duration'),
		})
	end,
})

modifier_bloodseeker_bloodrage_custom = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf' end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
	end,
	OnCreated 				= function(self)
		self.incoming = self:GetAbility():GetSpecialValueFor('bonus_damage')
		self.bonus_damage  = self:GetAbility():GetSpecialValueFor('bonus_damage_by_hero')
		if self:GetCaster():IsAssembly('bloodseeker_upgrade_1') then --card:IsAssemblyCard(self:GetCaster():GetUnitName(),'bloodseeker_upgrade_1',self:GetCaster():GetOwner():GetPlayerID()) then 
			self.bonus_damage = 0
		end
	end,
	GetModifierIncomingDamage_Percentage 		= function(self) return self.incoming end,
	GetModifierDamageOutgoing_ConstantTower 	= function(self) return self.bonus_damage end,
})