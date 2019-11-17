LinkLuaModifier ("modifier_slark_kill_shot_1", "abilityHero/slark/slark_kill_shot_1.lua", LUA_MODIFIER_MOTION_NONE)
slark_kill_shot_1 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_slark_kill_shot_1' end,
})

modifier_slark_kill_shot_1 = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_ATTACK_LANDED} end,
    OnAttackLanded 			= function(self)
    	if IsServer() and self:GetParent():GetAttackTarget() and not self:GetParent():GetAttackTarget():IsBoss() and RollPercentage(self:GetAbility():GetSpecialValueFor('chance_shot')) then
    		ApplyDamage({
    			ability = self:GetAbility(),
    			damage = self:GetParent():GetAttackTarget():GetHealth(),
    			victim = self:GetParent():GetAttackTarget(),
    			attacker = self:GetCaster(),
    			damage_type = DAMAGE_TYPE_PURE,
    		})
    	end
    end,
})