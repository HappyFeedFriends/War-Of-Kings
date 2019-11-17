LinkLuaModifier("modifier_veil_of_discord_custom", "items/item_veil_of_discord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_of_discord_custom_debuff", "items/item_veil_of_discord", LUA_MODIFIER_MOTION_NONE) 
item_veil_of_discord_1 =  class({})
item_veil_of_discord_2 = item_veil_of_discord_1

function item_veil_of_discord_1:GetIntrinsicModifierName()
	return "modifier_veil_of_discord_custom"
end

function item_veil_of_discord_1:OnSpellStart()
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")
	local point = self:GetCursorPosition()
	local dur = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),point,nil,radius, self:GetAbilityTargetTeam(),self:GetAbilityTargetType(),self:GetAbilityTargetFlags(),FIND_CLOSEST, false )
	local particle = ParticleManager:CreateParticle(  "particles/items2_fx/veil_of_discord.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(radius, radius, radius))
	for _,target in pairs(units) do
		target:AddNewModifier(self:GetCaster(),self,"modifier_veil_of_discord_custom_debuff",{duration = dur})
	end 
end

modifier_veil_of_discord_custom = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
	IsPermanent             = function(self) return false end,
	GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})
function modifier_veil_of_discord_custom:OnCreated()
	self.amp = self:GetAbility():GetSpecialValueFor('bonus_amplify')
	self.mpregen = self:GetAbility():GetSpecialValueFor('bonus_mana_regen')
	if self:GetParent().GetBuilding then 
		self:StartIntervalThink(0.2)
	end
end

function modifier_veil_of_discord_custom:OnIntervalThink()
	if IsServer() then
		local unit = self:GetParent():GetRandomUnitRadius(1000,{
			team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		})
		if self:GetAbility():IsFullyCastable() and unit then
			self:StartIntervalThink(self:GetAbility():GetCastPoint() + 0.3)
			self:GetParent():CastAbilityOnPosition(unit:GetAbsOrigin(), self:GetAbility(), -1)
		end
	end
end

function modifier_veil_of_discord_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end
function modifier_veil_of_discord_custom:GetModifierConstantManaRegen()return self.mpregen end
function modifier_veil_of_discord_custom:GetModifierSpellAmplify_Percentage() return self.amp end

modifier_veil_of_discord_custom_debuff = modifier_veil_of_discord_custom_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})
function modifier_veil_of_discord_custom_debuff:OnCreated() 
	self.reduction = self:GetAbility():GetSpecialValueFor("reduction_magic")
end
function modifier_veil_of_discord_custom_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_veil_of_discord_custom_debuff:GetEffectName()
    return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_veil_of_discord_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_veil_of_discord_custom_debuff:GetModifierMagicalResistanceBonus() return self.reduction end