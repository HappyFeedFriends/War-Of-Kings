LinkLuaModifier ("modifier_undying_reincornation", "abilityHero/undying/undying_reicornation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_undying_creep_reincornation", "abilityHero/undying/undying_reicornation.lua", LUA_MODIFIER_MOTION_NONE)
undying_reicornation = class({
	GetIntrinsicModifierName = function(self) return 'modifier_undying_reincornation' end,
})

modifier_undying_reincornation = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_DEATH,	
	} end,
})
function modifier_undying_reincornation:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end

function modifier_undying_reincornation:OnDeath(data)
	if IsServer() and data.unit:IsCreature() and data.unit.playerRound and self.ability:IsCooldownReady() then 
		--local owner = data.unit.playerRound
		self.ability.creeps = self.ability.creeps or {}
		if (table.length(self.ability.creeps) > 1) then return end
		local unit = CreateUnitByName(data.unit:GetUnitName(), self.parent:GetOrigin(), false,self.parent, self.parent, self.parent:GetTeamNumber())
		unit.indexCreep = #self.ability.creeps + 1
		self.ability.creeps[unit.indexCreep] = unit
		unit:SetBaseDamageMin(self.ability:GetSpecialValueFor('damage'))
		unit:SetBaseDamageMax(self.ability:GetSpecialValueFor('damage'))
		unit:AddNewModifier(self.parent, self.ability, 'modifier_undying_creep_reincornation', {
			duration = -1,
		})
	end
end

modifier_undying_creep_reincornation = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
	} end,
	CheckState = function(self) return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	} end,
	OnCreated = function(self)
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
	end,
})

function modifier_undying_creep_reincornation:OnAttackLanded(data)
	if IsServer() and self.parent:GetAttackTarget() == data.target then
		self.parent:Kill()
		self.ability.creeps[self.parent.indexCreep] = nil
	end
end
