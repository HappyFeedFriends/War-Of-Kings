item_flicker_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_flicker_custom' end,
})
LinkLuaModifier('modifier_item_flicker_custom', 'items/item_flicker.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_flicker_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetModifierBonusStats_Intellect 	= function(self) return self.int end,
	-- DeclareFunctions 		= function(self)
	-- 	return {MODIFIER_EVENT_ON_ABILITY_EXECUTED}
	-- end,
	OnAbilityExecuted 		= function(self,data)
		local ability = data.ability 
		if IsServer() and ability ~= self.ability and self.parent == data.unit and self.ability:IsCooldownReady() then 
			data.ability:EndCooldown()

			local IsUnitTarget = self.ability:_IsBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET)


		end
	end,
},nil,class({
	_OnCreated = function(self)
		self.int_damage = self.ability:GetSpecialValueFor('int_damage')
		self.base_damage = self.ability:GetSpecialValueFor('base_damage')
		self.int = self.ability:GetSpecialValueFor('int')
	end,
}),true)
