dark_willow_1 = class({
	OnSpellStart = function(self)
		self:GetCaster().illusionCopy = self:GetCaster().illusionCopy or {}
		local illusion = self:GetCaster():CreateIllusion({
			origin = self:GetOrigin(),
			data = { 
				duration = self:GetSpecialValueFor('duration'), 
				outgoing_damage = 100, 
				incoming_damage = 100,
			},
			AddItem = true,
			AddAbility = true,
		})
		illusion:AddNewModifier(self:GetCaster(),self,'modifier_rooted',{duration = -1})
		illusion:AddNewModifier(self:GetCaster(),self,'modifier_disarmed',{duration = -1})
		table.insert(self:GetCaster().illusionCopy,illusion)
		self:GetCaster():AddNewModifier(self:GetCaster(),self,'modifier_dark_willow_caster_buff',{duration = self:GetSpecialValueFor('duration')})
	end,
})
LinkLuaModifier("modifier_dark_willow_caster_buff", 'abilityHero/dark_willow/dark_willow_1.lua', LUA_MODIFIER_MOTION_NONE)
modifier_dark_willow_caster_buff = class({
	IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
   	DeclareFunctions		= function(self) return {MODIFIER_EVENT_ON_ATTACK_START}  end,
   	OnAttackStart           = function(self)
	   	for k,v in pairs(self:GetCaster().illusionCopy or {}) do
	   		if not v:IsNull() and v:IsAlive() then
	   		local illusion = v
		   		if illusion and illusion:AttackReady()  and self:GetCaster():GetAttackTarget() and #(self:GetCaster():GetAttackTarget():GetAbsOrigin() - illusion:GetAbsOrigin()) <= illusion:Script_GetAttackRange() then
		   			illusion:RemoveModifierByName('modifier_disarmed')
		   			illusion:PerformAttack( self:GetCaster():GetAttackTarget(), true, true, false, false, true, false, true )
		   			illusion:AddNewModifier(self:GetCaster(),self:GetAbility(),'modifier_disarmed',{duration = -1})
		   		end
	   		end
	   	end
   	end,
   	OnDestroy				= function(self)
	   	for k,v in pairs(self:GetCaster().illusionCopy or {}) do
	   		if not v:IsNull() and v:IsAlive() then
	   			v:ForceKill(false)
	   		end 
	   	end 
   		self:GetCaster().illusionCopy = {}
   	end,
})