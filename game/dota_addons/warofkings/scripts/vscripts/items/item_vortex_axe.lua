LinkLuaModifier('modifier_item_vortex_axe', 'items/item_vortex_axe.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_remove_shield_amount', 'items/item_vortex_axe.lua', LUA_MODIFIER_MOTION_NONE)
item_vortex_axe_1 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_vortex_axe' end,
	OnSpellStart = function(self)
		local modif = self:GetCursorTarget():FindModifierByName('modifier_shield')
		if modif then 
			local stackCount = modif:GetStackCount() -- value shield
			local removeStack = stackCount/100*self:GetSpecialValueFor('active_remove_shield')
			modif:SetStackCount(math.max(stackCount - removeStack,0))
			local amountmodify = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, 'modifier_remove_shield_amount', {
				duration = self:GetSpecialValueFor('active_remove_shield_duration')
			})
			amountmodify:SetStackCount(removeStack)
		end
	end,
})
item_vortex_axe_2 = item_vortex_axe_1
item_vortex_axe_3 = item_vortex_axe_1
modifier_remove_shield_amount = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	OnDestroy 				= function(self)
		if IsServer() then
			self:GetParent():AddStackModifier({
				ability = self:GetAbility(),
				modifier = 'modifier_shield',
				count = self:GetStackCount(),
				caster = self:GetParent(),
			})
		end
	end,
})

modifier_item_vortex_axe = class({
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
		self.damage_shield = self.ability:GetSpecialValueFor('damage_shield')
		self.bonus_damage = self.ability:GetSpecialValueFor('bonus_damage')
		self.bonus_attack_speed = self.ability:GetSpecialValueFor('bonus_attack_speed')
		self.bonus_health = self.ability:GetSpecialValueFor('bonus_health')
		self.parent = self:GetParent()
		--self.cooldown = self.ability:GetCooldown(self.ability:GetLevel())
		self.building = self.parent.GetBuilding
		if self.building then 
			self:StartIntervalThink(self.ability:GetCastPoint() + 0.3)
		end
	end,
	OnIntervalThink 	= function(self)
		if IsServer() and self.ability:IsCooldownReady() then
			local unit = self.parent:GetRandomUnitRadius(1100,{
				team = DOTA_UNIT_TARGET_TEAM_ENEMY,
				target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			},function(unit)
				return not unit:HasModifier('modifier_remove_shield_amount') and unit:HasModifier('modifier_shield')
			end)
			if unit then
				self.parent:CastAbilityOnTarget(unit, self.ability, -1)
			end
		end
	end,
	DeclareFunctions = function(self)
		return {
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
	end,
	GetModifierExtraHealthBonus = function(self) return self.bonus_health end,
	GetModifierPreAttack_BonusDamage = function( self ) return self.bonus_damage end,
	GetModifierAttackSpeedBonus_Constant = function( self ) return self.bonus_attack_speed end,
})

function modifier_item_vortex_axe:OnAttackLanded(data)
	if data.attacker == self.parent and data.target:HasModifier('modifier_shield') then 
		ApplyDamage({
			victim = data.target,
			damage = data.damage/100 * self.damage_shield,
			attacker = data.attacker,
			ability = self.ability,
			damage_type = DAMAGE_TYPE_PURE,
		})
	end
end

