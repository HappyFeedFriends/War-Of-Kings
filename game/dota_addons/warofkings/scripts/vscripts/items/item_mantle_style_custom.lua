item_mantle_style_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_mantle_style_custom' end,
	OnSpellStart 				= function(self)
		local caster = self:GetCaster()
		local dur = self:GetSpecialValueFor('duration')
		local origin = caster:GetOrigin()
		local outgoing = self:GetSpecialValueFor('outgoing_damage')
		for i=1,self:GetSpecialValueFor('amount') do 
			caster:CreateIllusion({
				Origin = origin + RandomVector(RandomInt(25,60)),
				data = { 
					duration = dur, 
					outgoing_damage = outgoing, 
					incoming_damage = 100,
				},
				AddItem = true,
				AddAbility = true,
			})
		end
	end,
})
LinkLuaModifier('modifier_item_mantle_style_custom', 'items/item_mantle_style_custom.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_mantle_style_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierBonusStats_Strength 		=	function(self) return self.all end,
	GetModifierBonusStats_Agility 		=	function(self) return self.all end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.all end,
	OnIntervalThink 					= 	function(self)
		if IsServer() and  self.ability:IsFullyCastable() then 
			self.parent:CastAbilityNoTarget(self.ability, -1)
		end
	end,
},nil,class({
	_OnCreated 				= function(self)
		if self.parent.GetBuilding then 
			self:StartIntervalThink(1)
		end
		self.all = self.ability:GetSpecialValueFor('all_stats') 
	end,
}),true)