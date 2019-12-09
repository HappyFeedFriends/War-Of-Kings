LinkLuaModifier("modifier_shadow_fiend_shadowraze_custom_debuff", 'abilityHero/shadow_fiend/shadow_fiend_shadowraze_custom.lua', LUA_MODIFIER_MOTION_NONE) 

shadow_fiend_shadowraze_custom = class({
	OnSpellStart = function(self)
		local caster  = self:GetCaster()
		local dur = self:GetSpecialValueFor('duration')
		local damage = self:GetSpecialValueFor_Custom('damage','sf_upgrade_1','damage')
		print(damage)
		local count = self:GetSpecialValueFor('damage_bonus')
		local IsAssembly = caster:IsAssembly('sf_upgrade_2')
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self:GetSpecialValueFor('radius'),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false)

		for _,unit in pairs(units) do
			local nfx = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", PATTACH_CUSTOMORIGIN, caster );
			ParticleManager:SetParticleControl(nfx, 0, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex( nfx )
			unit:AddStackModifier({
				ability = self,
				modifier = 'modifier_shadow_fiend_shadowraze_custom_debuff',
				caster = caster,
				duration = dur,
				count = count,
			})
			local stacks = unit:FindAbilityByName('modifier_shadow_fiend_shadowraze_custom_debuff') and unit:FindAbilityByName('modifier_shadow_fiend_shadowraze_custom_debuff'):GetStackCount() or 0
			ApplyDamage({
 				victim = unit,
 				attacker = caster,
 				damage_type = DAMAGE_TYPE_MAGICAL,
 				ability = self,
 				damage = damage + (damage/100 * stacks)
			})
			if IsAssembly then 
				caster:PerformAttack( unit, true, true, true, true, true, false, true )
			end
		end
	end,
})

modifier_shadow_fiend_shadowraze_custom_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
})

