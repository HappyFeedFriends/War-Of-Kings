LinkLuaModifier ("modifier_purify_sabre_godness", "items/item_purify_sabre_godness", LUA_MODIFIER_MOTION_NONE)
item_purify_sabre_godness = class({
	GetIntrinsicModifierName = function(self) return 'modifier_purify_sabre_godness' end,
})

modifier_purify_sabre_godness = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self) 
		self.damage = self:GetAbility():GetSpecialValueFor('damage_pure')
		self.parent = self:GetParent()
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	end,
})

function modifier_purify_sabre_godness:OnAttackLanded(data)
	if data.attacker == self.parent then 
		ApplyDamage({
			attacker = self.parent,
			damage = data.damage/100*self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			victim = data.target,
		})
	end
end