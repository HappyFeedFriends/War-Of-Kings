LinkLuaModifier ("modifier_omni_slash_custom", "abilityHero/juggernaut/omni_slash.lua", LUA_MODIFIER_MOTION_NONE)
juggernaut_omni_slash_custom = class({
	GetIntrinsicModifierName = function(self) return 'modifier_omni_slash_custom' end,
})

modifier_omni_slash_custom = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_ATTACK_START} end,
    OnAttackStart 			= function(self)
    	if self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() and not self:GetAbility().IsAttack and self:GetCaster():GetOwner() then 
    		local countAttack = self:GetAbility():GetSpecialValueFor('count_attack')
    		self:GetAbility().IsAttack = true
    		for i=1,countAttack do
    			if self:GetParent():GetAttackTarget() then
	    			if self:GetParent():IsAlive() then
	    				local unit = self:GetParent():GetAttackTarget()
	    				self:GetParent():PerformAttack(unit, true, true, true, true, false, false, true)
	    			else
	    				local unit = FindUnitsInRadius(self:GetParent():GetTeam(), 
	    					self:GetParent():GetAttackTarget():GetAbsOrigin(), 
	    					nil, 
	    					650,
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
							FIND_CLOSEST,
							false)[1]
	    				if unit then
	    					self:GetParent():PerformAttack(unit, true, true, true, true, false, false, true)
	    				end
	    			end
    			end
    		end
    		local cooldown = self:GetCaster():IsAssembly('juggernaut_upgrade_1') --card:IsAssemblyCard(self:GetCaster():GetUnitName(),'juggernaut_upgrade_1',self:GetCaster():GetOwner():GetPlayerID()) 
    		and card:GetDataCard(self:GetCaster():GetUnitName()).Assemblies['juggernaut_upgrade_1'].data.value 
    		or self:GetAbility():GetCooldown(self:GetAbility():GetLevel())
    		self:GetAbility():StartCooldown(cooldown)
    		self:GetAbility().IsAttack = false
    	end
    end,
})
