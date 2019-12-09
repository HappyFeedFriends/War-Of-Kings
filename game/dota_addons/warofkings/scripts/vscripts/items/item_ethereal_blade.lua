LinkLuaModifier ("modifier_ethereal_blade_custom", "items/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_ethereal_blade_custom_tick", "items/item_ethereal_blade", LUA_MODIFIER_MOTION_NONE)
item_ethereal_blade_1 = class({})
item_ethereal_blade_2 = item_ethereal_blade_1
item_ethereal_godness = item_ethereal_blade_1
function item_ethereal_blade_1:GetIntrinsicModifierName()
    return "modifier_ethereal_blade_custom_tick"
end
function item_ethereal_blade_1:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/items_fx/ethereal_blade.vpcf",
		bDodgeable = true,
		bProvidesVision = true,
		iMoveSpeed = 1300,
		iVisionRadius = 250,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	ProjectileManager:CreateTrackingProjectile( info )
end 

function item_ethereal_blade_1:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	if not caster.GetBuilding then  return end
	local building = caster:GetBuilding()
	local dur
	if hTarget:GetTeamNumber() ~= caster:GetTeamNumber() then
		dur = self:GetSpecialValueFor("duration_enemy")
		ApplyDamage({
			victim = hTarget,
			attacker = caster,
			damage = building:GetLevel() * self:GetSpecialValueFor("blast_level_multiply") + self:GetSpecialValueFor("blast_damage_base"),
			damage_type = DAMAGE_TYPE_MAGICAL,
		})
		hTarget:AddNewModifier(caster,self,"modifier_ethereal_blade_custom",{duration = dur})
	end 
end
modifier_ethereal_blade_custom_tick =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	GetModifierBonusStats_Strength 		=	function(self) return self.AllAttribute end,
	GetModifierBonusStats_Agility 		=	function(self) return self.AllAttribute end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.AllAttribute end,
	OnIntervalThink = 		function(self)
		if IsServer() then
			local unit = self:GetParent():GetRandomUnitRadius(1000,{
				team = DOTA_UNIT_TARGET_TEAM_ENEMY,
				target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			})
			if self:GetAbility():IsFullyCastable() and unit then
				self:GetParent():CastAbilityOnTarget(unit, self:GetAbility(), -1)
			end
		end
	end,
},nil,class({
	_OnCreated 				= function(self) 
		self:StartIntervalThink(0.5)
		self.AllAttribute = self:GetAbility():GetSpecialValueFor('attributes')
	end,
}),true)
modifier_ethereal_blade_custom =  class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
	OnCreated 				= function(self) 
		self.movespeed = self:GetAbility():GetSpecialValueFor("blast_movement_slow")
		self.resistance = self:GetAbility():GetSpecialValueFor("ethereal_damage_bonus")
	end,
})
function modifier_ethereal_blade_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end 
function modifier_ethereal_blade_custom:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
	return funcs
end
function modifier_ethereal_blade_custom:GetModifierMoveSpeedBonus_Percentage() return self.movespeed end
function modifier_ethereal_blade_custom:GetModifierMagicalResistanceDecrepifyUnique() return self.resistance end

