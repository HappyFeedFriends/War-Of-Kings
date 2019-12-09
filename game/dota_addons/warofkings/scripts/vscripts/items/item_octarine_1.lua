item_octarine_core_1 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_octarine_core_custom' end,
	OnSpellStart 	= function(self)
		if self:GetAbilityName() == 'item_octarine_core_godness' then 
			local nPreviewFX = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nPreviewFX, 0, self:GetCaster():GetOrigin() )
			self:GetParent():Refreshing()
		end
	end,
})
item_octarine_core_2 = item_octarine_core_1
item_octarine_core_godness = item_octarine_core_1
modifier_octarine_core_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierPercentageCooldown 	= function(self) return self.cooldown end,
	GetModifierSpellAmplify_Percentage 	= function(self) return self.amp end,
	GetModifierPercentageManacost 		= function(self) return self.manacost end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.intellect end,
},nil,class({
	_OnCreated 						= function(self)
		if not self:GetAbility() then return end
		self.abiltiy = self:GetAbility()
		self.cooldown = self.abiltiy:GetSpecialValueFor('cooldown_reduction')
		self.manacost = self.abiltiy:GetSpecialValueFor('manacost')
		self.amp = self.abiltiy:GetSpecialValueFor('amplify')
		self.parent = self:GetParent()
		self.intellect = self.abiltiy:GetSpecialValueFor('intellect')
		if self.abiltiy:GetAbilityName() == 'item_octarine_core_godness' and self.parent.GetBuilding then 
			self:StartIntervalThink(1)
		end
	end,
}),true)
function modifier_octarine_core_custom:OnIntervalThink()
	if IsServer() and self.abiltiy:IsFullyCastable() then
		local count = 0
		for i=0, self.parent:GetAbilityCount() - 1 do
			local current_ability = self.parent:GetAbilityByIndex(i)
			if current_ability and not NOT_REFRESHING[current_ability:GetAbilityName()] and not current_ability:IsCooldownReady() then
				count = count+1
				if count > 1 then break end
			end
		end
		if count > 1 then 
			self.parent:CastAbilityNoTarget(self.abiltiy, -1)
		end
	end
end
function modifier_octarine_core_custom:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs 
end