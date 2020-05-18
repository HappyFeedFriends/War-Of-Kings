doom_1 = class({
	OnSpellStart 	= function(self)
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		local IsChest = target:GetUnitName() == 'npc_war_of_kings_special_chest'
		if not target.__health__ and not IsChest then 
			self:EndCooldown()
			return
		end


		local health = target.__health__ or target:GetMaxHealth()
		if target.__health__ and caster:IsAssembly('doom_upgrade_1') then 
			health = health + (health * (GetPlayerCustom(caster:GetPlayerOwnerID()):GetDifficultyData().health/100))
		end
		
		local bonusDamage = self:GetSpecialValueFor_Custom('damage_by_hero','doom_upgrade_5')/(IsChest and 2 or 1)
		print(bonusDamage)
		local dur = self:GetSpecialValueFor_Custom('duration','doom_upgrade_3')
		local nfx = ParticleManager:CreateParticle("particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN, caster );
		ParticleManager:SetParticleControl(nfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(nfx, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nfx )
		caster:AddStackModifier({
			ability = self,
			modifier = 'modifier_doom_1',
			duration = dur,
			count = math.round(health * (bonusDamage/100)),
			updateStack = true,
			caster = caster,
		})
		target:TrueKill(caster, self)
	end,
})
LinkLuaModifier("modifier_doom_1", "abilityHero/doom/doom_1", LUA_MODIFIER_MOTION_NONE)
modifier_doom_1 = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function(self) return {MODIFIER_ATTRIBUTE_MULTIPLE} end,
	DeclareFunctions 		= function(self)
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
		}
	end,	
	GetModifierPreAttack_BonusDamage = function(self) return self:GetStackCount() end,
})