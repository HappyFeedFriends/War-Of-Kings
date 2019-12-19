attributes = class({})

LinkLuaModifier("modifier_attributes_custom_strength", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_agility", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_intellect", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_attributes_custom_base_strength", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_base_agility", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_base_intellect", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_attributes_custom_primary_0", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_primary_1", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attributes_custom_primary_2", 'InheritClasses/modifier_attributes.lua', LUA_MODIFIER_MOTION_NONE)

ModuleRequire(...,'modifier_attributes')
--[[
	Taken from 
 	https://github.com/Mickeyjojo/-/blob/57f36374f134c005cf6e4f9cfe67d020bcb15f99/root/scripts/vscripts/mechanics/attribute.lua
]]--
function attributes:Create(mBuilding)
	local hUnit = mBuilding:GetUnitEntity()
	local tData = GetUnitKV(hUnit:GetUnitName())

	if not tData then 
		print('[Attributes] kvData = null, unit name = ' .. hUnit:GetUnitName())
		return 
	end

	hUnit.iPrimaryAttribute = tData.AttributePrimary and _G[tData.AttributePrimary] or DOTA_ATTRIBUTE_INVALID

	if hUnit.iPrimaryAttribute == DOTA_ATTRIBUTE_INVALID then
		print('[Attributes] PrimaryAttribute = null, unit name = ' .. hUnit:GetUnitName())
		return
	end

	hUnit.fBaseStrength = tData.AttributeBaseStrength or 0
	hUnit.fStrength = self.fBaseStrength
	hUnit.fStrengthGain = tData.AttributeStrengthGain or 0
	hUnit.fStrengthBook = 0
	hUnit.fStrength_bonus = 0

	hUnit.fBaseAgility = tData.AttributeBaseAgility or 0
	hUnit.fAgility = self.fBaseAgility
	hUnit.fAgilityGain = tData.AttributeAgilityGain or 0
	hUnit.fAgilityBook = 0
	hUnit.fAgility_bonus = 0

	hUnit.fBaseIntellect = tData.AttributeBaseIntelligence or 0
	hUnit.fIntellect = self.fBaseIntellect
	hUnit.fIntellectGain = tData.AttributeIntelligenceGain or 0
	hUnit.fIntellectBook = 0
	hUnit.fIntellect_bonus = 0

	hUnit.hStrModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_strength", {duration=-1})
	hUnit.hAgiModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_agility", {duration=-1})
	hUnit.hIntModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_intellect", {duration=-1})

	hUnit.hBaseStrModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_base_strength", {duration=-1})
	hUnit.hBaseAgiModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_base_agility", {duration=-1})
	hUnit.hBaseIntModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_base_intellect", {duration=-1})

	hUnit.hPrimaryModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_attributes_custom_primary_" .. hUnit.iPrimaryAttribute, {duration=-1})

	hUnit.GetPrimaryAttribute = function(self)
		return self.iPrimaryAttribute
	end

	hUnit.GetBaseStrength = function(self)
		return self.fBaseStrength
	end
	hUnit.GetStrength = function(self)
		return self.fStrength
	end
	hUnit.GetStrengthGain = function(self)
		return self.fStrengthGain
	end
	hUnit.ModifyStrength = function(self, fChanged, bIsBase)
		self.fStrength = self.fStrength + fChanged
		if bIsBase ~= nil and bIsBase == true then
			self.fBaseStrength = self.fBaseStrength + fChanged
		end
		self:_updateStrength()
	end
	hUnit.SetBaseStrength = function(self, fStrength)
		local fChanged = fStrength - self.fBaseStrength
		self:ModifyStrength(fChanged, true)
	end
	hUnit._updateStrength = function(self)
		self.hStrModifier:SetStackCount(math.max(self.fStrength, 0))
		self.hBaseStrModifier:SetStackCount(math.max(self.fBaseStrength, 0))
	end

	hUnit.GetBaseAgility = function(self)
		return self.fBaseAgility
	end
	hUnit.GetAgility = function(self)
		return self.fAgility
	end
	hUnit.GetAgilityGain = function(self)
		return self.fAgilityGain
	end
	hUnit.ModifyAgility = function(self, fChanged , bIsBase)
		self.fAgility = self.fAgility + fChanged
		if bIsBase ~= nil and bIsBase == true then
			self.fBaseAgility = self.fBaseAgility + fChanged
		end
		self:_updateAgility()
	end
	hUnit.SetBaseAgility = function(self, fAgility)
		local fChanged = fAgility - self.fBaseAgility
		self:ModifyAgility(fChanged, true)
	end
	hUnit._updateAgility = function(self)
		self.hAgiModifier:SetStackCount(math.max(self.fAgility, 0))
		self.hBaseAgiModifier:SetStackCount(math.max(self.fBaseAgility, 0))
	end

	hUnit.GetBaseIntellect = function(self)
		return self.fBaseIntellect
	end
	hUnit.GetIntellect = function(self)
		return self.fIntellect
	end
	hUnit.GetIntellectGain = function(self)
		return self.fIntellectGain
	end
	hUnit.ModifyIntellect = function(self, fChanged , bIsBase)
		self.fIntellect = self.fIntellect + fChanged
		if bIsBase ~= nil and bIsBase == true then
			self.fBaseIntellect = self.fBaseIntellect + fChanged
		end
		self:_updateIntellect()
	end
	hUnit.SetBaseIntellect = function(self, fIntellect)
		local fChanged = fIntellect - self.fBaseIntellect
		self:ModifyIntellect(fChanged, true)
	end
	hUnit._updateIntellect = function(self)
		self.hIntModifier:SetStackCount(math.max(self.fIntellect, 0))
		self.hBaseIntModifier:SetStackCount(math.max(self.fBaseIntellect, 0))
	end

	hUnit.ReCalculateAttributes = function(self)
		local attribute = self:GetAllAttributesBonus()
		attribute.fStrength = attribute.fStrength + self.fBaseStrength
		attribute.fAgility = attribute.fAgility + self.fBaseAgility
		attribute.fIntellect = attribute.fIntellect + self.fBaseIntellect
		self.fIntellect = attribute.fIntellect  + self.fIntellectBook + self.fIntellect_bonus
		self.fAgility = attribute.fAgility + self.fAgilityBook + self.fAgility_bonus
		self.fStrength = attribute.fStrength + self.fStrengthBook + self.fStrength_bonus

		self:_updateIntellect()
		self:_updateAgility()
		self:_updateStrength()
	end
	hUnit:ReCalculateAttributes()
end

function CDOTA_BaseNPC:GetAllAttributesBonus()
	local attribute = {
		fStrength = 0,
		fAgility = 0,
		fIntellect = 0,
	}
	for _,modifier in pairs(self:FindAllModifiers()) do
		if not self.__Destroy then 
			attribute.fStrength = attribute.fStrength + (modifier.GetModifierBonusStats_Strength and modifier:GetModifierBonusStats_Strength() or 0)
			attribute.fAgility = attribute.fAgility + (modifier.GetModifierBonusStats_Agility and modifier:GetModifierBonusStats_Agility() or 0)
			attribute.fIntellect = attribute.fIntellect + (modifier.GetModifierBonusStats_Intellect and modifier:GetModifierBonusStats_Intellect() or 0)
		end
	end
	return attribute
end