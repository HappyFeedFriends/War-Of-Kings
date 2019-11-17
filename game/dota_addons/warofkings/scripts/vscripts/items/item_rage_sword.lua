LinkLuaModifier ("modifier_item_rage_sword", "items/item_rage_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_rage_sword_active", "items/item_rage_sword", LUA_MODIFIER_MOTION_NONE)
item_rage_sword = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_item_rage_sword' end,
	OnSpellStart 				= function(self)
		self:GetCaster():AddNewModifier(self:GetCaster(), self,'modifier_item_rage_sword_active', {
			duration = self:GetSpecialValueFor('duration'),
		})
	end,
})

modifier_item_rage_sword =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor('bonus_damage')
		self.bonus_attack = self.ability:GetSpecialValueFor('bonus_atk')
		if self:GetParent().GetBuilding then 
			self.parent = self:GetParent()
			self:StartIntervalThink(0.2)
		end
	end,
	OnIntervalThink = 		function(self)
		if IsServer() then
			if self.ability:IsFullyCastable() then
				local unit = self.parent:GetRandomUnitRadius(self.parent:Script_GetAttackRange(),{
					team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				})
				if unit then
					self.parent:CastAbilityNoTarget(self.ability, -1)
				end
			end
		end
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	
	} end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.damage end,
	GetModifierAttackSpeedBonus_Constant = function( self ) return self.bonus_attack end

})

modifier_item_rage_sword_active =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.attacktime = self.ability:GetSpecialValueFor('base_attack_time')
		self.bonus_attack = self.ability:GetSpecialValueFor('bonus_atk_active')
	end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	
	} end,
	GetModifierBaseAttackTimeConstant = function( self ) return self.attacktime end,
	GetModifierAttackSpeedBonus_Constant = function( self ) return self.bonus_attack end

})