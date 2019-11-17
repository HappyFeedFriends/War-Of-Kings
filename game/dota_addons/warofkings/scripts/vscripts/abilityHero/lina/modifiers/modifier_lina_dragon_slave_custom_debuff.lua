modifier_lina_dragon_slave_custom_debuff = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf' end,
    OnCreated 				= function(self)
    	self:StartIntervalThink(0.4)
    end,
    OnIntervalThink 		= function(self)
    if IsClient() then return end
    if not self:GetCaster() then self:Destroy() return end
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = card:GetDataCard(self:GetCaster():GetUnitName()).Assemblies['lina_upgrade_2'].data.value,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		})
    end,
})