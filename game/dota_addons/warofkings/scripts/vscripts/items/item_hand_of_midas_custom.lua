LinkLuaModifier ("modifier_hand_of_midas_ai", "items/item_hand_of_midas_custom", LUA_MODIFIER_MOTION_NONE)
item_hand_of_midas_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_hand_of_midas_ai' end,
	OnSpellStart 	= function(self)
		if self:GetCaster().GetBuilding and not self:GetCursorTarget():IsBoss() then
			local xp,gold = self:GetSpecialValueFor("xp_multiplier"),self:GetSpecialValueFor("bonus_gold")
			self:GetCursorTarget():Midas(gold,xp,self:GetCaster(),self)
		else
			self:StartCooldown(0)
		end
	end,
})

modifier_hand_of_midas_ai =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})
function modifier_hand_of_midas_ai:OnCreated()
	if self:GetCaster().GetBuilding then
		self:StartIntervalThink(0.5)
	end
end

function modifier_hand_of_midas_ai:OnIntervalThink()
	if IsServer()   then
		local unit = self:GetParent():GetRandomUnitRadius(900,{
			team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		},function(unit)
			return not unit:IsBoss()
		end)
		if unit and self:GetAbility():IsFullyCastable() then
			self:StartIntervalThink(self:GetAbility():GetCastPoint() + 0.4)
			self:GetParent():CastAbilityOnTarget(unit, self:GetAbility(), -1)
		end
	end
end