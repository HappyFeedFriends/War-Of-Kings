LinkLuaModifier ("modifier_scythe_of_vyse_buff", "items/item_scythe_of_vyse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_scythe_of_vyse_custom", "items/item_scythe_of_vyse", LUA_MODIFIER_MOTION_NONE)
item_scythe_of_vyse_1 = item_scythe_of_vyse_1 or class({})
item_scythe_of_vyse_2 = item_scythe_of_vyse_1 or class({})
item_scythe_vyse_godness = item_scythe_of_vyse_1 or class({})
function item_scythe_of_vyse_1:GetIntrinsicModifierName()
    return "modifier_scythe_of_vyse_buff"
end

function item_scythe_of_vyse_1:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if not caster.GetBuilding then return end
	local dur = self:GetSpecialValueFor("duration")
	target:TriggerSpellReflect(self)
	target:EmitSound("DOTA_Item.Sheepstick.Activate")
	target:AddNewModifier(caster,self,"modifier_scythe_of_vyse_custom",{duration = dur})
end  

modifier_scythe_of_vyse_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	GetModifierBonusStats_Intellect 	=	function(self) return self.intellect end,
	DeclareFunctions 		= function(self) return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	} end,
	GetModifierConstantManaRegen = function(self) return self.mpregen end,

},nil,class({
	_OnCreated 				= function(self)
		self.mpregen = self:GetAbility():GetSpecialValueFor('bonus_mana_regen')
		self.intellect = self:GetAbility():GetSpecialValueFor('intellect')
		if not self:GetParent().GetBuilding then return end
		self:StartIntervalThink(0.2)
	end,
}),true)

function modifier_scythe_of_vyse_buff:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then
	local radius = self:GetAbility():GetSpecialValueFor("range_tooltip")
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius, 
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_CLOSEST, 
		false )
		for _,target in pairs(units) do
			if self:GetAbility():IsFullyCastable() and not (target:IsHexed() and target:IsBoss() and target:IsInvisible() and target:IsInvulnerable() and target:IsMagicImmune()) then
				self:GetCaster():CastAbilityOnTarget(target, self:GetAbility(), -1)
				return self:GetAbility():GetCastPoint() + 0.4
			end 
		end 
	end 
end 


modifier_scythe_of_vyse_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})
function modifier_scythe_of_vyse_custom:OnCreated()
	self.base = self:GetAbility():GetSpecialValueFor("base_movespeed")
end
function modifier_scythe_of_vyse_custom:DeclareFunctions()
local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}
	return funcs 
end

function modifier_scythe_of_vyse_custom:GetModifierModelChange()
	return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function modifier_scythe_of_vyse_custom:CheckState()
	return {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end
function modifier_scythe_of_vyse_custom:OnDestroy()
	if IsServer() and self:GetAbility():GetName() == 'item_scythe_vyse_godness' then
		local ability = self:GetAbility()
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = ability:GetSpecialValueFor('damage'),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability,
		})
	end
end
function modifier_scythe_of_vyse_custom:GetModifierMoveSpeed_Limit(self) return self.base end
function modifier_scythe_of_vyse_custom:GetModifierMoveSpeed_Max(self) return self.base end