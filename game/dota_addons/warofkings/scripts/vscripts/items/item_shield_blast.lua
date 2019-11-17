item_shield_blast = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_shield_blast' end,
})
LinkLuaModifier('modifier_item_shield_blast', 'items/item_shield_blast.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_shield_blast = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor('damage')
		self.duration_stunned = self.ability:GetSpecialValueFor('duration_stunned')
		self.bonus_health = self.ability:GetSpecialValueFor('bonus_health')
		self.parent = self:GetParent()
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		}
	end,
	GetModifierExtraHealthBonus = function(self) return self.bonus_health end,
})
-- custom event
--[[
	hAttacker,
	iShieldOld,
	fDamage_end,
	fDamage_start,
	iDamage_type,
	hModifier,
]]
function modifier_item_shield_blast:OnShieldRemove(data)
	if not self.ability:IsCooldownReady() then return end
	self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel()))
	local target = data.hAttacker
	local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl(nFXIndex1, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(nFXIndex1, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
	ParticleManager:SetParticleControl(nFXIndex1, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ApplyDamage({
		victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	})
	target:AddNewModifier(self.parent,self.ability,'modifier_stunned',{duration = self.duration_stunned})
end