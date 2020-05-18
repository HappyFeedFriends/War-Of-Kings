--[[
	Author: Watcher of Samsara
	Redesigned: War of kings (HappyFeedFriends)
	Date Create: ?????? 
	Date last update: 15.09.19
	Description: The player's building class is used for more convenient work with each building separately (the reference to the building is obtained through GetBuilding, in CDOTA_BaseNPC
]]

if not Building then
	Building = class({})
	Building.tBuildings = {}
end


function Building.insert(hBuilding)
	local iIndex = 1
	while Building.tBuildings[iIndex] ~= nil do
		iIndex = iIndex + 1
	end
	Building.tBuildings[iIndex] = hBuilding
	return iIndex
end

function Building.remove(hBuilding)
	if type(hBuilding) == "number" then 
		local iIndex = hBuilding
		if Building.tBuildings[iIndex] ~= nil then
			Building.tBuildings[iIndex] = nil
			return true
		end
	else 
		for iIndex, _hBuilding in pairs(Building.tBuildings) do
			if _hBuilding == hBuilding then
				Building.tBuildings[iIndex] = nil
				return true
			end
		end
	end
	return false
end

-- 类相关
function NewBuilding(...)
	return Building(...)
end

function Building:MaxXpByLevel(lvl)
	return math.floor(150 + (150 * 0.15 * (lvl or self.iLevel)))
end

function Building:GetLevelByXp(xp)
	xp = xp or self.allXp
	local i = 1;
	while xp > 0 do
		xp = xp - self:MaxXpByLevel(i)
		if xp >= 0 then
			i = i + 1
		end
	end
	return i
end

function Building:IsAssembly(name)
	if not self.hOwner then return false end
	local data = CustomNetTables:GetTableValue('PlayerData', "player_" .. self.hOwner:GetPlayerOwnerID()).BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())].hIsAssemblies
	return data[name] == 1
end

function CDOTA_BaseNPC:IsAssembly(name)
	if  not BuildSystem:IsBuilding(self) then 
		return false
	end
	return self.GetBuilding():IsAssembly(name)
end

function CDOTA_BaseNPC:GetSpecialValueForBuilding(key,name)
	name = name or 'value'
	local data = card:GetDataCard(self:GetUnitName()) 
	if data and data.Assemblies[key] and data.Assemblies[key].data and data.Assemblies[key].data[name] then 
		return data.Assemblies[key].data[name]
	end
	return 0
end

function Building:GetNeedXpByLevelUp(lvl)
	lvl = lvl or self.iLevel;
	return self:GetXpByLevelUp(lvl) - self.allXp;
end

function Building:GetTotalEarnedXP()
	return self:GetCurrentXp() + self:GetNeedXpByLevelUp()
end

function Building:GetAllXp()
	return self.allXp 
end

function Building:GetLevel()
	return self.iLevel
end

function Building:GetCurrentXp(myXp)
	local xp = myXp or self.allXp
	local i = 0
	while true do
		i = i + 1;
		local add = self:MaxXpByLevel(i)
		xp = xp - add
		if xp < 0 then
			return xp + add
		end
	end
end

function Building:GetXpByLevelUp(lvl)
	local xp = 0;
	lvl = lvl or self.iLevel
	for i = 1,lvl do
		xp = xp + self:MaxXpByLevel(i);
	end
	return xp;
end

function Building:LevelUpBuilding(lvlup)
	local hUnit = self.hUnit
	local uniqueBonusGain = GetPlayerCustom(self.hOwner:GetPlayerOwnerID()):GetUniqueBonus() == UNIQUE_BONUS_TOWER_LEVEL and 2 or 0
	local primaryAttribute = hUnit:GetPrimaryAttribute()
	hUnit:ModifyStrength((hUnit:GetStrengthGain() + uniqueBonusGain) * lvlup,true)
	hUnit:ModifyIntellect((hUnit:GetIntellectGain() + uniqueBonusGain) * lvlup,true)
	hUnit:ModifyAgility((hUnit:GetAgilityGain() + uniqueBonusGain )* lvlup,true)
end

function Building:AddShield(amount,ability)
	local shieldCount = self:GetShieldCount()
	self.hUnit:AddStackModifier({
		ability = ability,
		modifier = 'modifier_shield',
		count = amount,
		caster = self.hUnit,
	})
	for k,v in pairs(self.hUnit:FindAllModifiers() ) do
		if v.OnShieldAdd then
			v:OnShieldAdd({ -- custom event modifier
				iamount = amount,
				iShieldOld = shieldCount,
				iShieldNew = self:GetShieldCount(),
			})
		end
	end
end

function Building:GetLevel()
	return self.iLevel
end


function Building:IsCreep()
	return self.bIsCreep
end
-- static
function Building:IsCreepByName(name)
	local rarity = card.AllCards[name] and card.AllCards[name].type or ''
	return rarity == 'uncommon'
end

function Building:IsStartingTower()
	return CARD_DATA.CARDS.Starting_towers[self:GetUnitEntityName()]
end

function Building:IsHero()
	return not self:IsCreep()
end

function CDOTA_BaseNPC:IsCreepBuild()
	if  not BuildSystem:IsBuilding(self) then 
		return false
	end
	return self.GetBuilding():IsCreep()
end

function Building:AddExperience(amount)
	self.allXp = math.max(self.allXp + amount,0)
	local levelbyxp = self:GetLevelByXp()
	if self.iLevel < levelbyxp then
		self:LevelUpBuilding(levelbyxp - self.iLevel)
	end
	self.iLevel = levelbyxp
	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local nettables = CustomNetTables:GetTableValue('PlayerData', "player_" .. iPlayerID)
	if nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())] then
		nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())] = {
			Grade = self.iGrade,
			Level = self.iLevel,
			iXp =  self:GetCurrentXp(),
			iMaxXp = self:GetTotalEarnedXP(),
			iMaxGrade = nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())].iMaxGrade,
			hIsAssemblies = nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())].hIsAssemblies,
		}
		CustomNetTables:SetTableValue("PlayerData", "player_" .. iPlayerID, nettables)
	end
end

function Building:IsMaxGrade()
	return self.iGrade == CARD_DATA.MAX_GRADE[self:GetRariry()]
end

function Building:IsGodness(class)
	if not class then 
		return self:GetRariry() == 'Godness'
	end
	return self:GetRariry() == 'Godness' and self:GetClass() == class
end

-- constructor
function Building:constructor(sName, vLocation, fAngle, hOwner,cost)
	self.iIndex = Building.insert(self)
	self.vLocation = vLocation
	self.fAngle = fAngle
	self.hOwner = hOwner
	self.iGrade = 1
	self.allXp = 0
	self.iLevel = 1
	self.damage = 0
	self.iGoldCost = cost or 0
	self.invul = false 
	self:Replace(sName)
	self.iRarity = card.AllCards[sName] and card.AllCards[sName].type or ''

	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local __Player = GetPlayerCustom(iPlayerID)
	local nettables = CustomNetTables:GetTableValue('PlayerData', "player_" .. iPlayerID)
	nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())] = {
		Grade = self.iGrade,
		Level = self.iLevel,
		iXp =  0,
		iMaxXp = self:GetTotalEarnedXP(),
		iMaxGrade = CARD_DATA.MAX_GRADE[self:GetRariry()],
		hIsAssemblies = {},
	}
	CustomNetTables:SetTableValue("PlayerData", "player_" .. iPlayerID, nettables)
	if __Player:GetUniqueBonus() == UNIQUE_BONUS_TOWER_LEVEL then 
		self:AddExperience(self:GetXpByLevelUp(9))
	end

	self.hBlocker = BuildSystem:CreateBlocker(BuildSystem:GridNavSquare(BUILDING_SIZE, vLocation))
	attributes:Create(self)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), 'RemoveAndCreateBuilding', {})
end

-- add star 
function Building:UpgradeBuilding(iBonus)
	if self:IsMaxGrade() then return end
	self.iGrade = math.min(self.iGrade + (iBonus or 1),CARD_DATA.MAX_GRADE[self:GetRariry()])
	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local __Player = GetPlayerCustom(iPlayerID)
	__Player:SetValueQuest(QUEST_FOR_BATTLE_UPGRADE_TOWER_GRADE,BuildSystem:GetMaxGrade(iPlayerID))
	local nettables = CustomNetTables:GetTableValue('PlayerData', "player_" .. iPlayerID)
	nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())].Grade = self.iGrade
	CustomNetTables:SetTableValue("PlayerData", "player_" .. iPlayerID, nettables)
	local unit = self.hUnit
	if not self:IsCreep() then 
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() + (self.MaxDamage * 0.25))
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() + (self.MinDamage * 0.25))
	end
	local particle = ParticleManager:CreateParticle('particles/econ/events/ti7/hero_levelup_ti7_godray.vpcf', PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "General.FemaleLevelUp", self.hOwner)
	for i=0,24 do
		local ability = self.hUnit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(self.iGrade)
		end
	end
	if self:IsMaxGrade() then
		self.particleMaxGrade = ParticleManager:CreateParticle('particles/econ/events/fall_major_2016/teleport_end_fm06_glow.vpcf', PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl(self.particleMaxGrade, 0, unit:GetAbsOrigin())
	end
end

function Building:Move(vLocation)
	SnapToGrid(BUILDING_SIZE, vLocation)
	self.vLocation = vLocation
	self.hUnit:SetAbsOrigin(vLocation)
	BuildSystem:SetBlockerPolygon(self.hBlocker, BuildSystem:GridNavSquare(BUILDING_SIZE, vLocation))
	return self.vLocation
end

function Building:ToggleInvul()
	self.invul = not self.invul
end

function Building:Replace(sName)
	local tItems = {}
	local fAngle = self.fAngle
	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local hUnit = CreateUnitByName(sName, self.vLocation, false, self.hOwner, self.hOwner, self.hOwner:GetTeamNumber())
	hUnit:AddNewModifier(hUnit, nil, 'modifier_building', {duration = -1})
	self.hUnit = hUnit
	local startHealth = 1750 + ( self:GetClass() == 'guardian' and 1750 or 0)
	hUnit:SetBaseMaxHealth(startHealth)
	hUnit:SetMaxHealth(startHealth)
	hUnit:SetHealth(startHealth)
	self.MaxDamage = hUnit:GetBaseDamageMax()
	self.MinDamage = hUnit:GetBaseDamageMin()
	hUnit:SetControllableByPlayer(iPlayerID, false)
	hUnit:SetAngles(0, fAngle, 0)
	hUnit:SetHasInventory(true)
	self.bIsCreep = self:GetRariry() == 'uncommon'
	local particle = ParticleManager:CreateParticle('particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn_burst.vpcf', PATTACH_ABSORIGIN_FOLLOW, hUnit)
	ParticleManager:SetParticleControl(particle, 0, hUnit:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	hUnit.GetBuilding = function(hUnit)
		return self
	end
	return hUnit
end
function Building:ApplyDamage(attacker,damage)
	if self.invul then return end
	if self:GetHealth() - damage < 1 then
		BuildSystem:RemoveBuilding( self:GetUnitEntity() )
	else
		ApplyDamage({
			victim = self.hUnit,
			attacker = attacker,
			damage = math.max(damage - self.hUnit:GetPhysicalArmorValue(false),0) + self.hUnit:GetModifierOutGoingCustom(),
			damage_type = DAMAGE_TYPE_PURE,
		})
	end
end

-- remove unit
function Building:RemoveSelf()
	BuildSystem:RemoveBlocker(self.hBlocker)
	if self.hOwner:IsAlive() then 
		for i = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
			local item = self.hUnit:GetItemInSlot(i)
			if item and item:GetName() ~= 'item_rapier' then
				self.hUnit:DropItem(item:GetName())
			end
		end
	end
	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local __Player = GetPlayerCustom(iPlayerID)
	__Player:ModifyTowerAmount(-1)
	local nettables = CustomNetTables:GetTableValue('PlayerData', "player_" .. iPlayerID)
	nettables.BuildingsCardsindexID[tostring(self.hUnit:GetEntityIndex())] = nil
	self.hUnit:ForceKill(false)
	Timers:CreateTimer(0.1,function()
		self.hUnit:RemoveSelf()
		self.hUnit = nil
	end)
	Building.remove(self.iIndex)
	self.vLocation = nil
	self.fAngle = nil
	self.hOwner = nil
	self.iLevel = nil
	self.hBlocker = nil
	self.iIndex = nil
	self.allXp = nil
	BuildSystem:EachBuilding(iPlayerID,function(build)
		local hIsAssemblies = {}
		for k,v in pairs(card:GetDataCard(build:GetUnitEntityName()).Assemblies or {}) do
			hIsAssemblies[k] = card:IsAssemblyCard(build:GetUnitEntityName(),k,iPlayerID)
		end
		if nettables.BuildingsCardsindexID[tostring(build:GetUnitEntityIndex())] then
			nettables.BuildingsCardsindexID[tostring(build:GetUnitEntityIndex())].hIsAssemblies = hIsAssemblies
		end
	end)
	CustomNetTables:SetTableValue("PlayerData", "player_" .. iPlayerID, nettables)
	if self.particleMaxGrade then
		ParticleManager:ReleaseParticleIndex(self.particleMaxGrade)
		ParticleManager:DestroyParticle(self.particleMaxGrade, true)
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), 'RemoveAndCreateBuilding', {})
end

-- utility funcs
function Building:getIndex()
	return self.iIndex
end

function Building:GetUnitEntity()
	return self.hUnit
end
function Building:GetShieldCount()
	local shield = self:GetUnitEntity():FindModifierByName('modifier_shield')
	return (shield and shield:GetStackCount() or 0)
end
function Building:GetHealth()
	local hunit = self:GetUnitEntity()
	local shield = hunit:FindModifierByName('modifier_shield')
	return hunit:GetHealth() + self:GetShieldCount()
end

function Building:GetUnitEntityName()
	return self:GetUnitEntity():GetUnitName()
end

function Building:GetUnitEntityIndex()
	return self.hUnit:entindex()
end

function Building:GetBlockerEntity()
	return self.hBlocker
end
function Building:GetClass()
	local name = self:GetUnitEntityName()
	return card.AllCards[name] and card.AllCards[name].class or ''
end

function Building:GetRariry()
	return self.iRarity 
end

function Building:GetOwner()
	return self.hOwner
end

function Building:GetGrade()
	return self.iGrade
end

function Building:GetPlayerOwnerID()
	if self.hOwner == nil then return end
	return self.hOwner:GetPlayerOwnerID()
end

function Building:ModifyTotalDamage(fDamage)
	fDamage = math.floor(fDamage)
	if not self:GetOwner():IsAlive() then return end
	local __Player = GetPlayerCustom(self:GetPlayerOwnerID())
	__Player:ModifyDamageAll(fDamage)
	self.damage = self.damage + fDamage
	__Player:ModifyBuildingDamage(round:GetActualRound(),fDamage,self:GetUnitEntityName())
	-- card:ModifyDamageAll(self:GetPlayerOwnerID(),fDamage)
	-- local dataRound = round.DataAllRounds[round:GetActualRound()][self:GetPlayerOwnerID()].DamageBuildings[self:GetUnitEntityName()] or {
	-- 	fDamage = 0,
	-- }
	-- self.damage = self.damage + fDamage
	-- dataRound.fDamage = dataRound.fDamage + fDamage
	-- round.DataAllRounds[round:GetActualRound()][self:GetPlayerOwnerID()].DamageBuildings[self:GetUnitEntityName()] = dataRound
end

return Building