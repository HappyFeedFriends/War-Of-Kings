lion_finger_of_death_custom = class({
	OnSpellStart = function(self)
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local cardBonusModif = caster:FindModifierByName('modifier_lion_finger_of_death_custom_card_bonus')
		local damage = self:GetSpecialValueFor('damage') + (cardBonusModif and cardBonusModif:GetStackCount() or 0 )
		local nFXIndex = ParticleManager:CreateParticle('particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf', PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})
		if not target:IsAlive() then 
			self:EndCooldown()
			caster:GiveMana(self:GetManaCost(self:GetLevel())/2)
			if card:IsAssemblyCard(caster:GetUnitName(),'lion_upgrade_1',caster:GetOwner():GetPlayerID()) then 
				local data = card:GetDataCard(caster:GetUnitName()).Assemblies.lion_upgrade_1.data
				caster:AddStackModifier({
					ability = self,
					modifier = 'modifier_lion_finger_of_death_custom_card_bonus',
					count = data.value,
					caster = caster,
				})
			end
		end
	end,
})
LinkLuaModifier('modifier_lion_finger_of_death_custom_card_bonus', 'abilityHero/lion/lion_finger_of_death_custom.lua', LUA_MODIFIER_MOTION_NONE)
modifier_lion_finger_of_death_custom_card_bonus = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
})