item_mystic_staff_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_mystic_staff_buff_custom' end,
})
LinkLuaModifier('modifier_mystic_staff_buff_custom', 'items/item_mystic_staff.lua', LUA_MODIFIER_MOTION_NONE)

modifier_mystic_staff_buff_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.mp = self:GetAbility():GetSpecialValueFor('mana_regen')
		self.penetration = self:GetAbility():GetSpecialValueFor('magic_penetraion')
		self.amp = self:GetAbility():GetSpecialValueFor('amplify') 
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,	
	} end,
	GetMagicPenetration 	= function(self) 
		return self.penetration
	end,
	GetModifierConstantManaRegen = function( self ) return self.mp end,
	GetModifierSpellAmplify_Percentage = function( self ) return self.amp end
})