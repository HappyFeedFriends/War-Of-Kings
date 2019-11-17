item_basher_3 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_basher_3' end,
})
LinkLuaModifier('modifier_item_basher_3', 'items/item_basher_3.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_basher_3 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	OnCreated 				= function(self)
		self.damage = self:GetAbility():GetSpecialValueFor('damage')
	end,
	GetModifierPreAttack_BonusDamage = function(self) return self.damage end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	} end,
})

function modifier_item_basher_3:OnAttackLanded(params)
	if IsServer() and params.attacker == self:GetParent() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		if not params.target:IsStunned() and RollPercentage(ability:GetSpecialValueFor('bash_chance')) and ability:IsCooldownReady() then
			params.target:AddNewModifier(caster, ability, 'modifier_stunned', {
				duration = ability:GetSpecialValueFor('bash_duration')
			})
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end

		if RollPercentage(ability:GetSpecialValueFor('light_chance')) then
			local nFXIndex = ParticleManager:CreateParticle( 'particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf', PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin() + Vector( 0, 0, 50 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndex );
			ApplyDamage({
				victim = params.target,
				attacker = caster,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
				damage = ability:GetSpecialValueFor('light_damage')
			})
		end
	end
end