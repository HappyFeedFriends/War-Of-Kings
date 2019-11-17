LinkLuaModifier ("modifier_medusa_split_shot_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_dragon_splash_attack_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
medusa_split_shot_custom = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_medusa_split_shot_custom' end,
})

modifier_medusa_split_shot_custom = modifier_medusa_split_shot_custom or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_medusa_split_shot_custom:DeclareFunctions()
local funcs =
	{	
		MODIFIER_EVENT_ON_ATTACK,	
	}
	return funcs 
end

function modifier_medusa_split_shot_custom:OnAttack(params)
	if params.attacker == self:GetCaster()  then
		local targets = self:GetAbility():GetSpecialValueFor_Custom("arrow_count",'medusa_upgrade_3')
		self:GetCaster():SplitShot(self:GetAbility(),self:GetCaster():Script_GetAttackRange(),targets)
	end 
end

function medusa_split_shot_custom:OnProjectileHit( hTarget, vLocation )  
	local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())/100 * self:GetSpecialValueFor_Custom("damage_modifier_tooltip",'medusa_upgrade_2')
	local damageTable = 
	{
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
end
dragon_splash_attack_custom =  class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_dragon_splash_attack_custom' end,
})
modifier_dragon_splash_attack_custom =  class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_dragon_splash_attack_custom:DeclareFunctions()
local funcs =
	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
	}
	return funcs 
end

function modifier_dragon_splash_attack_custom:OnAttackLanded(params)
	if params.attacker == self:GetParent() and IsServer() then
		local range = self:GetAbility():GetSpecialValueFor_Custom("range",'dragon_upgrade_2') + #(params.attacker:GetAbsOrigin() + self:GetParent():GetAbsOrigin())
		local damage =  params.damage / 100 * self:GetAbility():GetSpecialValueFor_Custom("damage",'dragon_upgrade_1')
		DoCleaveAttack(self:GetParent(), params.target,self:GetAbility(), damage, 128.0, 128.0, range, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf")
	end
end

shadow_shaman_hex_custom = class({
	OnSpellStart = function(self)
		if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetCursorTarget()
			if card:IsAssemblyCard(caster:GetUnitName(),'shaman_upgrade_1',caster:GetOwner():GetPlayerID()) then
				local targets = FindUnitsInRadius(caster:GetTeamNumber(),
					target:GetOrigin(), 
					nil, 
					card:GetDataCard(caster:GetUnitName()).Assemblies['shaman_upgrade_1'].data.value, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
					FIND_CLOSEST,
					false)
				for k,v in pairs(targets) do
					v:AddNewModifier(caster, self, 'modifier_shadow_shaman_voodoo', {duration = self:GetSpecialValueFor('duration')})
				end
			else
				target:AddNewModifier(caster, self, 'modifier_shadow_shaman_voodoo', {duration = self:GetSpecialValueFor('duration')})
			end
		end
	end,
})

obsidian_destroyer_arcane_orb_custom = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_obsidian_destroyer_arcane_orb_custom' end,
})
LinkLuaModifier ("modifier_bonus_damage_arcane_orb", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_obsidian_destroyer_arcane_orb_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
modifier_bonus_damage_arcane_orb = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions		= function(self) return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	} end,
	GetModifierPreAttack_BonusDamage = function(self) return self:GetStackCount() end,
})

modifier_obsidian_destroyer_arcane_orb_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions		= function(self) return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	} end,
})
function modifier_obsidian_destroyer_arcane_orb_custom:OnAttackStart(params) 
	if IsServer() and params.attacker == self:GetParent() then
		local mana = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())
		if card:IsAssemblyCard(self:GetCaster():GetUnitName(),'devourer_upgrade_2',self:GetCaster():GetOwner():GetPlayerID()) then
			mana = mana - (mana / 100 * card:GetSpecialValueFor_Upgrade(self:GetCaster(),'devourer_upgrade_2').value)
		end
		local projectile = self:GetAbility():GetAutoCastState() and mana <= self:GetCaster():GetMana() and 'particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf' or GetKeyValueByHeroName(self:GetCaster():GetUnitName(), 'ProjectileModel')
		self:GetCaster():SetRangedProjectileName(projectile)
		self.flag = self:GetAbility():GetAutoCastState() and mana <= self:GetCaster():GetMana()
		self.mana = mana
	end
end
function modifier_obsidian_destroyer_arcane_orb_custom:OnAttackLanded(params)
	if self.flag and self.mana and params.attacker == self:GetParent() and IsServer() then
		self:GetParent():ReduceMana(self.mana)
		local damage = ApplyDamage({
			victim = params.target,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetMana()/100 * self:GetAbility():GetSpecialValueFor_Custom("mana_pool_damage_pct"),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
		})
		self:GetCaster():AddStackModifier({
			ability = self:GetAbility(),
			modifier  = 'modifier_bonus_damage_arcane_orb',
			duration = self:GetAbility():GetSpecialValueFor_Custom("damage_bonus_duration"),
			count = self:GetAbility():GetSpecialValueFor_Custom("damage_bonus"), 
			caster = self:GetCaster(),
		})
		DoCleaveAttack(self:GetParent(), params.target,self:GetAbility(), damage, 128.0, 128.0, self:GetAbility():GetSpecialValueFor_Custom("radius"), "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf")
	end
end

obsidian_destroyer_sanity_eclipse_custom = class({
	OnSpellStart = function( self )
		local point = self:GetCursorPosition()
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor('radius')
		local particle = ParticleManager:CreateParticle('particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf', PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, point)
		ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0))
		ParticleManager:SetParticleControl(particle, 2, Vector(radius,0,0))
		ParticleManager:SetParticleControl(particle, 3, Vector(radius,0,0))
		local targets = FindUnitsInRadius(caster:GetTeamNumber(),
			point, 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_CLOSEST,
			false)
		for k,v in pairs(targets) do
			ApplyDamage({
				victim = v,
				attacker = caster,
				damage = math.max(math.abs(caster:GetMaxMana() - v:GetMana()) * self:GetSpecialValueFor_Custom("damage_multiplier"),0),
				damage_type = card:IsAssemblyCard(caster:GetUnitName(),'devourer_upgrade_1',caster:GetOwner():GetPlayerID()) and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
				ability = self,
			})
			v:ReduceMana(v:GetMaxMana()/100 * self:GetSpecialValueFor_Custom("mana_drain"))
		end
	end
})

pugna_life_drain_custom = class({
	OnSpellStart = function( self )
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		self.modifiers = self.modifiers or {}
		if caster:HasScepter() then
			self:EndCooldown()
		end
		if card:IsAssemblyCard(caster:GetUnitName(),'pugna_upgrade_1',caster:GetOwner():GetPlayerID()) then
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
					target:GetOrigin(), 
					nil, 
					card:GetDataCard(caster:GetUnitName()).Assemblies['pugna_upgrade_1'].data.value, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
					FIND_CLOSEST,
					false)
			for k,v in pairs(units) do
				table.insert(self.modifiers,v:AddNewModifier(caster, self, 'modifier_pugna_life_drain_custom', {duration = -1}))
			end
			return
		end
		table.insert(self.modifiers,target:AddNewModifier(caster, self, 'modifier_pugna_life_drain_custom', {duration = -1}))
	end,
	OnChannelFinish = function(self)
		if IsServer() then
			for k,v in pairs(self.modifiers) do
				v:GetParent():RemoveModifierByName('modifier_pugna_life_drain_custom')
				self.modifiers[k] = nil
			end
			self:GetCaster():Stop()
		end
	end,
})
LinkLuaModifier ("modifier_pugna_life_drain_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
modifier_pugna_life_drain_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions		= function(self) return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	} end,
	OnCreated 				= function(self)
		if IsServer() then
			self.damagepertick = self:GetAbility():GetSpecialValueFor('health_drain')
			self.LifeDrainParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(self.LifeDrainParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.LifeDrainParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		end
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor('tick_rate'))
	end,
	OnIntervalThink 		= function(self)
		if IsServer() then
			if math.abs(#(self:GetCaster():GetOrigin() - self:GetParent():GetOrigin())) > self:GetAbility():GetSpecialValueFor('cast_range_tooltip') then
				self:Destroy()
				return
			end
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damagepertick,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
		end
	end,
	OnDestroy = function(self)
		if IsServer() then
			for k,v in pairs(self:GetAbility().modifiers) do
				if v == self then
					self:GetAbility().modifiers[k] = nil
				end
			end
			if table.length(self:GetAbility().modifiers) < 1 then
				self:GetAbility():OnChannelFinish(false)
			end
			ParticleManager:DestroyParticle(self.LifeDrainParticle,false)
		end
	end,
})
-- self:GetAbility():GetAutoCastState()
LinkLuaModifier ("modifier_tusk_walrus_punch_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
tusk_walrus_punch_custom = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_tusk_walrus_punch_custom' end,
})

modifier_tusk_walrus_punch_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions		= function(self) return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	} end,
	GetModifierPreAttack_CriticalStrike 	= function(self)
		if self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady() and IsServer() and self:GetAbility():GetManaCost(self:GetAbility():GetLevel()-1) < self:GetParent():GetMana() then
			local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1)
			local caster = self:GetParent()
			if card:IsAssemblyCard(caster:GetUnitName(),'tusk_upgrade_2',caster:GetOwner():GetPlayerID()) then
				cooldown = cooldown - card:GetDataCard(caster:GetUnitName()).Assemblies['tusk_upgrade_2'].data.value
			end
			self:GetAbility():StartCooldown(cooldown)
			caster:ReduceMana(self:GetAbility():GetManaCost(self:GetAbility():GetLevel()-1))
			--[[local particle = ParticleManager:CreateParticle('particles/units/heroes/hero_tusk/tusk_walruspunch_txt_ult.vpcf', PATTACH_CUSTOMORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())]]
			return self:GetAbility():GetSpecialValueFor_Custom("crit_multiplier",'tusk_upgrade_1')
		end
	end,
})
LinkLuaModifier ("modifier_bounty_hunter_jinada_custom", "HeroAbility", LUA_MODIFIER_MOTION_NONE)
bounty_hunter_jinada_custom = class({
	GetIntrinsicModifierName 	= function(self) return 'modifier_bounty_hunter_jinada_custom' end,
})

modifier_bounty_hunter_jinada_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
	DeclareFunctions		= function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	} end,
	OnCreated 	= function(self)
		if self:GetCaster():GetOwner() then 
			self.ability = self:GetAbility()
			self.parent = self:GetCaster()
			self.player = PlayerResource:GetPlayer(self.parent:GetOwner():GetPlayerID())
			self.criticalDamage = self.ability:GetSpecialValueFor('critical_damage')
		end
	end,
	OnRefresh = 	function(self)
		if not IsServer() or not self.ability then return end
		self.criticalDamage = self.ability:GetSpecialValueFor('critical_damage')
	end,
	GetModifierPreAttack_CriticalStrike = function(self)
		if self.ability:IsCooldownReady() then
			return self.criticalDamage
		end
		return nil
	end,
})

function modifier_bounty_hunter_jinada_custom:OnAttackLanded(params)
	if IsServer() and self.player and params.attacker == self:GetParent() and self.ability:IsCooldownReady() then
		local bonusgold = self.ability:GetSpecialValueFor_Custom("bonus_gold",'bounty_hunter_1')
		local player = self.player
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, params.target, math.floor(bonusgold), player)
		self.parent:GetOwner():ModifyGold(bonusgold, false, DOTA_ModifyGold_Unspecified)
		self.ability:StartCooldown(self.ability:GetCooldown(self.ability:GetLevel() - 1))
	end
end

zuus_thundergods_wrath_custom = class({
	OnSpellStart = function( self )
		local thisEntity = self:GetCaster()
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, thisEntity )
		ParticleManager:SetParticleControl( nFXIndex1, 0, thisEntity:GetAbsOrigin() );
		ParticleManager:SetParticleControl( nFXIndex1, 1, thisEntity:GetAbsOrigin() );
		ParticleManager:SetParticleControl( nFXIndex1, 62, Vector(9999,9999,9999) );
		ParticleManager:ReleaseParticleIndex( nFXIndex1 )
		local enemy = FindUnitsInRadius(thisEntity:GetTeamNumber(),
			thisEntity:GetOrigin(),
			nil,
			FIND_UNITS_EVERYWHERE,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_CLOSEST,
			false)
		for k,v in pairs(enemy) do
			if v.playerRound == thisEntity:GetOwner():GetPlayerID() then 
				local target = v
				ApplyDamage({
					victim = v,
	                attacker = thisEntity, 
					damage = self:GetSpecialValueFor('damage'),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
	            })
            	local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, thisEntity )
				ParticleManager:SetParticleControl(nFXIndex1, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
				ParticleManager:SetParticleControl(nFXIndex1, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
				ParticleManager:SetParticleControl(nFXIndex1, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
			end
		end
	end,
})