item_essence_scepter_custom = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		target:AddNewModifier(self:GetCaster(), nil, 'modifier_item_essence_scepter_custom', {duration = -1})
		self:UpdateCharge()
	end,
	GetIntrinsicModifierName = function(self) return 'modifier_item_essence_scepter_custom_root' end,
})
LinkLuaModifier('modifier_item_essence_scepter_custom', 'items/item_essence_scepter_custom.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_essence_scepter_custom_root', 'items/item_essence_scepter_custom.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_essence_scepter_custom_root = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnCreated 				= function(self)
		if IsServer() and self:GetAbility() and BuildSystem:IsBuilding(self:GetParent()) then
			self:GetParent():AddNewModifier(self:GetParent(), nil, 'modifier_item_essence_scepter_custom', {duration = -1})
			self:GetAbility():UpdateCharge()
		end
	end,
})
modifier_item_essence_scepter_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	IsAura 					= function(self) return true end,
	DeclareFunctions  = function(self)
		return {MODIFIER_PROPERTY_IS_SCEPTER}
	end,
	GetModifierScepter = function(self) return 1 end
})