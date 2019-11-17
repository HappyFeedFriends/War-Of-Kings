LinkLuaModifier("modifier_dagon_custom", "items/item_dagon", LUA_MODIFIER_MOTION_NONE)
item_dagon_custom_1 =  class({})
item_dagon_custom_2 =  item_dagon_custom_1
item_dagon_custom_3 =  item_dagon_custom_1
item_dagon_custom_4 =  item_dagon_custom_1
item_dagon_custom_5 =  item_dagon_custom_1
item_dagon_custom_6 =  item_dagon_custom_1
item_dagon_custom_7 =  item_dagon_custom_1
item_dagon_custom_8 =  item_dagon_custom_1
function item_dagon_custom_1:OnSpellStart()
	local particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_POINT, self:GetCaster())
	local damage = self:GetSpecialValueFor("damage")
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT, "attach_attack1", self:GetCaster():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, self:GetCursorTarget(), PATTACH_POINT, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(particle, 2, Vector(damage,0,0))
	local damage_table =
	{
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	ApplyDamage(damage_table)
end 

function item_dagon_custom_1:GetIntrinsicModifierName()
	return "modifier_dagon_custom"
end

modifier_dagon_custom =  class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	
	DeclareFunctions 		= function(self) return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	} end,
	GetModifierConstantManaRegen = function(self) return self.mpregen end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
})

function modifier_dagon_custom:OnCreated()
	self.mpregen = self:GetAbility():GetSpecialValueFor('mana_regen')
	if self:GetCaster().GetBuilding then
		self:StartIntervalThink(0.2)
	end
end

function modifier_dagon_custom:OnIntervalThink()
	if IsServer() and self:GetAbility():IsFullyCastable() then
		local unit = self:GetParent():GetRandomUnitRadius(800,{
			team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		})
		if unit then 
			self:StartIntervalThink(self:GetAbility():GetCastPoint() + 0.3)
			self:GetCaster():CastAbilityOnTarget(unit, self:GetAbility(), -1)
		end
	end
end