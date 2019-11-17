LinkLuaModifier("modifier_magical_damage_rune_bonus", 'ability.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_ability_bonus_physical_damage", 'ability.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bonus_life", 'ability.lua', LUA_MODIFIER_MOTION_NONE)
ability_remove_unit = class({
	OnSpellStart 	= function(self)
	local pID = self:GetCaster():GetPlayerID()
	local building = self:GetCursorTarget().GetBuilding
		if building and building():GetPlayerOwnerID() == pID then 
			BuildSystem:RemoveBuilding(self:GetCursorTarget())
		end
	end,
})

ability_card_refresh1 = class({
	OnSpellStart = function(self)
		local goldcost = self:GetGoldCost(1)
		local playerid = self:GetCaster():GetPlayerID()
		if GetPlayerCustom(playerid):GetGold() < goldcost then 
			DisplayError(playerid,'#dota_hud_error_not_enough_gold')
			self:EndCooldown()
			return 
		end
		local chance = {
			common = 45,
			uncommon = 35,
			rare = 55,
			mythical = 10,
			legendary = 2,
		}
		card:RefreshingCards(chance,self:GetCaster():GetPlayerID(),goldcost)
		self:GetCaster():SetGold(99999, false) -- fixed
	end,
})
ability_card_refresh2 = class({
	OnSpellStart = function(self)
		local goldcost = self:GetGoldCost(1)
		local playerid = self:GetCaster():GetPlayerID()
		if GetPlayerCustom(playerid):GetGold() < goldcost then 
			DisplayError(playerid,'#dota_hud_error_not_enough_gold')
			self:EndCooldown()
			return 
		end
		local chance = {
			common = 45,
			uncommon = 35,
			rare = 55,
			mythical = 20,
			legendary = 10,
		}
		card:RefreshingCards(chance,self:GetCaster():GetPlayerID(),goldcost)
		self:GetCaster():SetGold(99999, false)
	end,
})
ability_card_refresh3 = class({
	OnSpellStart = function(self)
		local goldcost = self:GetGoldCost(1)
		local playerid = self:GetCaster():GetPlayerID()
		if GetPlayerCustom(playerid):GetGold() < goldcost then 
			DisplayError(playerid,'#dota_hud_error_not_enough_gold')
			self:EndCooldown()
			return 
		end
		local chance = {
			common = 10,
			uncommon = 15,
			rare = 65,
			mythical = 45,
			legendary = 25,
		}
		local goldcost = self:GetGoldCost(1)
		card:RefreshingCards(chance,self:GetCaster():GetPlayerID(),goldcost)
		self:GetCaster():SetGold(99999, false)
	end,
})

ability_bonus_life = class({
	OnSpellStart 	= function(self)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_bonus_life', {duration = -1})
	end,
})
ability_bonus_magical_damage = class({
	OnSpellStart 	= function(self)
		BuildSystem:EachBuilding(self:GetCaster():GetPlayerID(),function(building)
			building.hUnit:AddNewModifier(building.hUnit, self, 'modifier_magical_damage_rune_bonus', {duration = 15})
		end)
	end,
})

modifier_magical_damage_rune_bonus = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end,
    GetModifierSpellAmplify_Percentage 	= function(self) return 250 end,
    GetModifierPercentageCooldown   = function(self) return 65 end,
})
modifier_bonus_life = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
})
function modifier_magical_damage_rune_bonus:GetEffectName()
	return "particles/generic_gameplay/rune_arcane.vpcf"
end

function modifier_magical_damage_rune_bonus:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_ability_bonus_physical_damage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return true end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
    GetModifierBaseDamageOutgoing_Percentage 	= function(self) return 250 end,
    GetModifierAttackSpeedBonus_Constant   = function(self) return 200 end,
})

function modifier_ability_bonus_physical_damage:GetEffectName()
	return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_ability_bonus_physical_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

ability_bonus_physical_damage = class({	
	OnSpellStart 	= function(self)
		BuildSystem:EachBuilding(self:GetCaster():GetPlayerID(),function(building)
			building.hUnit:AddNewModifier(building.hUnit, self, 'modifier_ability_bonus_physical_damage', {duration = 15})
		end)
	end,
})