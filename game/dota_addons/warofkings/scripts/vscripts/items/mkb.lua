item_monkey_king_bar_2 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_monkey_king_bar_custom' end,
})

item_monkey_king_bar_3 = class({
	GetIntrinsicModifierName = function(self) return 'modifier_item_monkey_king_bar_custom' end,
})
item_monkey_king_bar_godness = item_monkey_king_bar_3
LinkLuaModifier('modifier_item_monkey_king_bar_custom', 'items/mkb.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_monkey_king_bar_custom_debuff', 'items/mkb.lua', LUA_MODIFIER_MOTION_NONE)
modifier_item_monkey_king_bar_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return true end,
	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_EVENT_ON_ATTACK_LANDED,	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	} end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor( "bonus_damage" )
		self.atkSpeed = self.ability:GetSpecialValueFor( "bonus_attack_speed" )
		self.chance = self.ability:GetSpecialValueFor('bonus_chance')
		self.dur = self.ability:GetSpecialValueFor('stunned_duration')
		self.bonusdamage = self.ability:GetSpecialValueFor('bonus_chance_damage')
		self.cooldown = self.ability:GetCooldown(self.ability:GetLevel())
	end,

	GetModifierPreAttack_BonusDamage 	= function(self) return self.damage end,
	GetModifierMoveSpeedBonus_Percentage = 	function(self) return self.atkSpeed end,
})

function modifier_item_monkey_king_bar_custom:OnAttackLanded(params)
	if params.attacker == self:GetParent() and IsServer() and self.ability:IsCooldownReady() and RollPercentage(self.chance) then
		ApplyDamage({
			victim = params.target,
			attacker = params.attacker,
			ability = self.ability,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage = self.bonusdamage
		})
		local caster = self:GetParent()
		local vec = params.target:GetAbsOrigin()
		-- particles/econ/items/zeus/arcana_chariot/zeus_arcana_tgw_bolt_child_b.vpcf
		local nFXIndex = ParticleManager:CreateParticle( 'particles/econ/items/zeus/arcana_chariot/zeus_arcana_tgw_bolt_child_b.vpcf', PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl(nFXIndex, 0, vec)
		ParticleManager:SetParticleControl(nFXIndex, 1, Vector(vec.x,vec.y,800))

		ParticleManager:ReleaseParticleIndex( nFXIndex );
		if self.ability:GetAbilityName() == 'item_monkey_king_bar_3' or self.ability:GetAbilityName() == 'item_monkey_king_bar_godness' then
			params.target:AddNewModifier(params.attacker, self.ability, self.ability:GetAbilityName() == 'item_monkey_king_bar_godness' and 'modifier_stunned' or 'modifier_item_monkey_king_bar_custom_debuff', {
              duration = self.dur
			})
			self.ability:StartCooldown(self.cooldown)
		end
	end
end

modifier_item_monkey_king_bar_custom_debuff = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return true end,
	DeclareFunctions 		= function(self) return 	{	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	} end,
	GetModifierMoveSpeedBonus_Percentage = function(self) return self.movespeed end,
	OnCreated 				= function(self)
		self.ability = self:GetAbility()
		self.movespeed = -self.ability:GetSpecialValueFor( "movespeed" )
	end,
})