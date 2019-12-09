LinkLuaModifier('modifier_item_rod_of_atos_custom', 'items/item_rod_of_atos_custom.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_rod_of_atos_custom_debuff', 'items/item_rod_of_atos_custom.lua', LUA_MODIFIER_MOTION_NONE)
item_rod_of_atos_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_rod_of_atos_custom' end,
	OnSpellStart 			= function(self)
		ProjectileManager:CreateTrackingProjectile({
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/items2_fx/rod_of_atos_attack.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = 900,
			iVisionRadius = 250,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		})
	end,
})
item_rob_of_atos_godness = item_rod_of_atos_custom
modifier_item_rod_of_atos_custom_debuff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	CheckState 				= function(self) return {
		[MODIFIER_STATE_ROOTED] = true,
	} end,
	DeclareFunctions 		= function(self)
		return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
	end,
	GetModifierMagicalResistanceBonus = function(self) return self.resist end,
	OnCreated 				= function(self)
		self.resist = -self:GetAbility():GetSpecialValueFor('magic_resistance')
	end,
	GetEffectAttachType 	= function(self) return PATTACH_ABSORIGIN end,
	GetEffectName 			= function(self) return 'particles/items2_fx/rod_of_atos.vpcf' end,
})

modifier_item_rod_of_atos_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.int end,
	OnIntervalThink = 		function(self)
		if IsServer() then
			if self.ability:IsFullyCastable() then
				local unit = self.parent:GetRandomUnitRadius(1100,{
					team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				})
				if unit then
					self.parent:CastAbilityOnTarget(unit, self.ability, -1)
				end
			end
		end
	end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	} end,
	GetModifierSpellAmplify_Percentage = function(self) return self.amp end,
},nil,class({
	_OnCreated 				= function(self)
		self.amp = self:GetAbility():GetSpecialValueFor('bonus_amp')
		self.int = self:GetAbility():GetSpecialValueFor('bonus_intellect')
		if self:GetCaster().GetBuilding then
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self:StartIntervalThink(0.2)
		end
	end,
}),true)

function item_rod_of_atos_custom:OnProjectileHit( hTarget, vLocation )
	if hTarget then
		hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_item_rod_of_atos_custom_debuff', {
			duration = self:GetSpecialValueFor('duration')
		})
	end
end

