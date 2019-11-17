LinkLuaModifier ("modifier_bounty_hunter_track_custom", "abilityHero/bounty_hunter/bounty_hunter_track_custom", LUA_MODIFIER_MOTION_NONE)
bounty_hunter_track_custom = class({
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		target:AddNewModifier(caster, self, 'modifier_bounty_hunter_track_custom', {duration = -1})
	end,	
})

modifier_bounty_hunter_track_custom  = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
	GetEffectAttachType 	= function(self) return PATTACH_OVERHEAD_FOLLOW end,
	GetEffectName 			= function(self) return 'particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield_mark.vpcf' end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_EVENT_ON_DEATH,
		}
	end,
	OnCreated 				= function(self)
		if not IsServer() then return end
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		if not BuildSystem:IsBuilding(self.caster) or 
			not self.caster:GetOwner() or 
			not self.caster:GetOwner():GetPlayerID() then 
			self:Destroy()
			return
		end
		self.player = self.caster:GetPlayerOwner()
		self.bonus_gold = self:GetAbility():GetSpecialValueFor('bonus_gold')
	end,
})

function modifier_bounty_hunter_track_custom:OnDeath(data)
	if not IsServer() then return end
	if data.unit == self.parent then 
		SendOverheadEventMessage(self.player, OVERHEAD_ALERT_GOLD, self.caster, math.floor(self.bonus_gold), self.player)
		self.caster:GetOwner():ModifyGold(self.bonus_gold, false, DOTA_ModifyGold_Unspecified)
	end
end