
DATA_USABLE_MODIFEIRS = {
	modifier_unique_aura_physical = true,
	modifier_unique_aura_magical = true,
	modifier_bonus_life = true,
	modifier_unique_aura_all_damage = true,
}

UNIQUE_BONUS_CLOSE = 0
UNIQUE_BONUS_PHYSICAL = 1
UNIQUE_BONUS_MAGICAL = 2
UNIQUE_BONUS_HEALTH = 3
UNIQUE_BONUS_MIDAS = 4
UNIQUE_BONUS_GOLD_CREEP = 5
UNIQUE_BONUS_TOWER = 6
UNIQUE_BONUS_TOWER_LEVEL = 7
UNIQUE_BONUS_DROP_CHANCE = 8
UNIQUE_BONUS_CREEP_NOT_USE_ABILITY = 9

UNIQUE_ACCES_LVL = {
	[UNIQUE_BONUS_HEALTH] = 5,
	[UNIQUE_BONUS_MIDAS] = 10,
	[UNIQUE_BONUS_GOLD_CREEP] = 15,
	[UNIQUE_BONUS_TOWER] = 20,
	[UNIQUE_BONUS_TOWER_LEVEL] = 25,
	[UNIQUE_BONUS_DROP_CHANCE] = 30,
	[UNIQUE_BONUS_CREEP_NOT_USE_ABILITY] = 35,	
}

DROP_UNIQUE_BONUS_DROP_CHANCE = {
	[1] = { -- normal creep
		'item_ogre_axe_custom','item_staff_of_wizardry_custom','item_helm_of_iron_will','item_claymore',
		'item_broadsword','item_javelin','item_mithril_hammer','item_point_booster','item_platemail',
		'item_void_stone','item_clarity_custom','item_shield_buff','item_hyperstone','item_demon_edge',
		'item_blade_of_alacrity_custom','item_dragon_lance_custom',
	},

	[2] = { -- champions
		'item_reaver_custom','item_energy_booster','item_vitality_booster','item_ultimate_orb','item_dagon_custom_1',
		'item_dagon_custom_2','item_dagon_custom_3','item_aether_lens','item_fire_sword','item_veil_of_discord_1',
		'item_assault_shield','item_maelstrom','item_blades_of_attack','item_bracer','item_xp_book',
		'item_book_all_stats','item_book_agility','item_book_strength','item_book_intellect','item_hand_of_midas_custom',

	},

	[3] = { -- mini bosses and bosses (80 round)
		'item_kris_of_agony_2','item_book_of_soul_creep','item_xp_book','item_vortex_axe_2','item_desolator_3',
		'item_vortex_axe_1','item_octarine_core_2','item_magic_rapier','item_rapier','item_scythe_of_vyse_2',
		'item_desolator_2',
	},

}

if not Player then
	Player = class({})
	Player.PlayerHandles = {}
	Player.flagIsRequestion = false
end

function NewPlayer(...)
	Player(...)
end

function GetPlayerCustom(PlayerID)
	return Player.PlayerHandles[PlayerID]
end

function Player:constructor(PlayerID)
	self.iPlayerID = PlayerID
	self.tBuildingData = {}
	self.tCacheCard = {}
	self.tEndRound = {}
	self.tEndGame = {}
	self.tDataPerRound = {}
	self.tChampions = {}
	self.tDailyQuests = {}
	self.tQuests = {}
	self.tTowerBuy = {}
	self.tInventory = {}
	self.tFriendLeaderboard = {}
	self.hSelected = PlayerResource:GetSelectedHeroEntity(self.iPlayerID)
	self.iGold = 5200
	self.ExpAndOst = {
		Level = 1,
		Exp = 0,
	}
	self.model = 'models/items/courier/onibi_lvl_00/onibi_lvl_00.vmdl' -- default
	self.bSub = 0 
	self.iRuneUse = 0
	self.bIsDev = false
	self.bIsTester = false 
	self.bIsGameEnd = false
	self.tRunes = {
		physical_rune = 0, -- 1
		magical_rune = 0, -- 2
		life_rune = 0, -- 3
	}
	self.tSandbox = {
		health = 100,-- default 
		damage = 100,-- default 
		tCacheUnits = {},
		bIsAllChampions = false,
	}
	self.iGoldCostCache = 0
	self.iKillChest = 0
	self.fAllDamageGame = 0
	self.fChestSpawn = -1
	self.iCrystalCount = 0
	self.iCrystalAllGame = 0
	self.iGoldCountAllGame = 0
	self.fChestDamage = 0
	self.fChestDamageTotal = 0
	self.iRoundAlive = 0
	self.iRoundAlive_Endless = 0
	self.iAmountTower = 0
	self.iMaxTower = 8
	self.iRank = 0 -- TODO
	self.iCoins = 0
	self.iExp = 0
	self.iAmountGame = 0
	self.iGodnessSpawn = 1
	self.iGoldСhestDrop = 0
	self.iDifficulty = ROUND_DIFFICUILT_NORMAL
	self.iMode = ROUND_MODE_NORMAL
	self.iUnique = UNIQUE_BONUS_CLOSE
	self.hspawnerCreep = round.spawners[self.iPlayerID]
	self.sTowerDefault = 'npc_war_of_kings_default_silencer'
	--self.hPlayerSpawner = Entities:FindByName(nil, 'player_spawner_' .. SpawnedUnit:GetPlayerID() )
	self:UpdateClientData()
	Player.PlayerHandles[self:GetPlayerID()] = self

end

function Player:OnSelectCourierModel(index)
	local data = CustomNetTables:GetTableValue("PlayerData", "GLOBAL_SETTING").SHOP_DATA
	if not data[tostring(index)] or not self.tInventory[tostring(index - 1)] then 
		print('Inventory not found item by index = '..index..' type = '..type(index))
		return 
	end
	for k,v in pairs(self.tInventory) do
		self.tInventory[k].selected = (k == tostring(index - 1))
	end
	self:UpdateClientData()
	self:SetModel(data[tostring(index)].model,true)
end

function Player:OnSelectDefaultTower(towerName)
	local startingData = CARD_DATA.CARDS.Starting_towers
	if startingData[towerName] and (startingData[towerName].lvl or 0) <= self.ExpAndOst.Level then 
		self.sTowerDefault = towerName
	end
end

function Player:RequestInfo(Towers)
	lastSelectedCourier = 0;
	for k,v in pairs(self.tInventory) do
		if v.selected then 
			lastSelectedCourier = k
		end
	end
	Player.flagIsRequestion = true
	request:RequestData('POST','player_save',function(obj)
	end,{
		MatchID = tostring(GameRules:GetMatchID()),
		SteamID = PlayerResource:GetRealSteamID(self.iPlayerID),
		TowersBuy = self.tTowerBuy,
		DamageAllGame = self.fAllDamageGame,
		ChestDamage = self.fChestDamageTotal,
		Towers = Towers or {},
		Mode = self.iDifficulty,
		UniqueBonus = self.iUnique,
		CrystalCount = self.iCrystalAllGame,
		ChestByGold = self.iGoldСhestDrop,
		GoldAllGame = self.iGoldCountAllGame,
		AliveRound = self.iRoundAlive,
		LastSelected = lastSelectedCourier,
		DailyQuests = self.tDailyQuests,
		Runes = request.IsServerConnection and {
			[1] = self.tRunes['physical_rune'],
			[2] = self.tRunes['magical_rune'],
			[3] = self.tRunes['life_rune'],
		} or nil,
	})
end

function Player:SpawnEndlessRound(iRound)
	if not self:IsAlive() then
		self.tDataPerRound[iRound] = {
			GameEnd = true,
		}
		return
	end
	local pID = self.iPlayerID
	local hero = self:GetSelectedHeroEntity()
	local roundNumber = iRound
	local spawner = self:GetRoundSpawner()
	local IsSandBox = self:IsSandBoxMode()
	local LocalData = {
		__CreepName = 'npc_war_of_kings_endless_creep',
		__Model = ENDLESS_MODEL_CREEP[RandomInt(1, #ENDLESS_MODEL_CREEP)],
		count = 35,
	}
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), 'OnStartRound', {
		round = roundNumber
	})
	self.tDataPerRound[roundNumber] = {
		count = LocalData.count,
		kills = 0,
		unitCreate = 0,
		unitSkip = 0,
		DamageBuildings = {},
		bFullKill = false,
		fTimeFullKill = -1,
	}
	Timers:CreateTimer(0.1,function()
		local unit = CreateUnitByName(LocalData.__CreepName, spawner:GetAbsOrigin(), true, nil,nil, DOTA_TEAM_NEUTRALS)
		unit:SetOriginalModel(LocalData.__Model)
		unit:SetModel(LocalData.__Model)
		unit:UpgradeRoundUnit(roundNumber,pID)
		unit.playerRound = pID
		unit.roundSpawn = roundNumber
		if unit:GetBaseDamageMin() > 0 then 
			unit.attackCount = 0
		end
		unit:AddNewModifier(unit, nil, 'modifier_war_of_kings_passive_unit', {duration = -1})
		unit:SetContextThink( "Think", function()
			return OnThinkNormalCreep(unit,true)
		end, 0.1 )
		self.tDataPerRound[roundNumber].unitCreate = self.tDataPerRound[roundNumber].unitCreate + 1
		return self.tDataPerRound[roundNumber].unitCreate < self.tDataPerRound[roundNumber].count and 0.8 or nil
	end)
end

function Player:IsValidIsland(pos)
	local trigger = Entities:FindByName(nil, 'island_player_' .. self.iPlayerID)
	local origin = trigger:GetAbsOrigin()
	local angles = trigger:GetAngles()
	local bounds = trigger:GetBounds()
	local vMin = RotatePosition(Vector(0, 0, 0), angles, bounds.Mins)+origin
	local vMax = RotatePosition(Vector(0, 0, 0), angles, bounds.Maxs)+origin
	return 	(pos.x >= vMin.x and pos.x <= vMax.x) and
			(pos.z >= vMin.z and pos.z <= vMax.z)

end

function Player:SpawnRound(iRound,units,dataRound)
	local pID = self.iPlayerID
	local hero = self:GetSelectedHeroEntity()
	local roundNumber = iRound
	local spawner = self:GetRoundSpawner()
	local IsSandBox = self:IsSandBoxMode()
	local difficuiltyData = self:GetDifficultyData() 
	if ( roundNumber > 80 and not hero:IsAlive() )  then return end
	if self:IsGameEnd() then
		self.tDataPerRound[roundNumber] = {
			GameEnd = true,
		}
		return
	end
	self.tDataPerRound[roundNumber] = {
		count = round:IsSpecialRound(roundNumber) and 1 or dataRound.SpawnCount,
		kills = 0,
		unitCreate = 0,
		unitSkip = 0,
		DamageBuildings = {},
		bFullKill = false,
		fTimeFullKill = -1,
	}
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), 'OnStartRound', {
		round = roundNumber
	})
	if roundNumber % 80 == 0 then
		local unitName = 'npc_war_of_kings_wave_boss_end'
		local unit = CreateUnitByName(unitName, spawner:GetOrigin(), true, nil,nil, DOTA_TEAM_NEUTRALS)
		if IsSandBox then
			self.tSandbox.tCacheUnits[unit:GetEntityIndex()] = unit
		end
		unit.playerRound = pID
		unit.roundSpawn = roundNumber
		unit.attackCount = 0
		unit.IsBosses = true
		unit.crystalDrop = CREEP_DATA[BOSS_CREEP].crystal
		unit:SetMaximumGoldBounty(CREEP_DATA[BOSS_CREEP].gold)
		unit:SetMinimumGoldBounty(CREEP_DATA[BOSS_CREEP].gold)
		unit:SetBaseDamageMin(CREEP_DATA[BOSS_CREEP].damage)
		unit:SetBaseDamageMax(CREEP_DATA[BOSS_CREEP].damage)
		local startHealth = unit:GetMaxHealth() * (difficuiltyData.health/100)
		unit:SetBaseMaxHealth(startHealth)
		unit:SetMaxHealth(startHealth)
		unit:SetHealth(startHealth)
		unit:AddNewModifier(unit, nil, 'modifier_war_of_kings_passive_unit', {duration = -1})
		unit:AddNewModifier(unit, nil, 'modifier_no_healthbar', {duration = -1})
		local modif = unit:AddNewModifier(unit, nil, 'modifier_shield', {duration = -1})
		modif:SetStackCount(startHealth)
		unit:SetContextThink( "Think",  function()
			return OnThinkLastBoss(unit)
		end, 0.1 )
	elseif roundNumber % CREEP_DATA[MINI_BOSS_CREEP].interval == 0 then
		local UnitName = self:GetRandomGodnessSpecial()
		local unit = CreateUnitByName(UnitName, spawner:GetOrigin(), true, nil,nil, DOTA_TEAM_NEUTRALS)
		unit:AddNewModifier(unit, nil, 'modifier_no_healthbar', {duration = -1})
		unit:AddNewModifier(unit, nil, 'modifier_war_of_kings_passive_unit', {duration = -1})
		if IsSandBox then
			self.tSandbox.tCacheUnits[unit:GetEntityIndex()] = unit
		end
		unit.playerRound = pID
		unit.roundSpawn = roundNumber
		unit.bIsGodness = true
		unit.IsBosses = true
		unit.IsMiniBoss = true
		local startHealth = 55000 * self.iGodnessSpawn * (difficuiltyData.health/100)
		self.iGodnessSpawn = self.iGodnessSpawn + 1
		unit:SetBaseMaxHealth(startHealth)
		unit:SetMaxHealth(startHealth)
		unit:SetHealth(startHealth)
		unit.crystalDrop = CREEP_DATA[MINI_BOSS_CREEP].crystal
		unit:SetMaximumGoldBounty(CREEP_DATA[MINI_BOSS_CREEP].gold)
		unit:SetMinimumGoldBounty(CREEP_DATA[MINI_BOSS_CREEP].gold)
		unit:SetBaseDamageMin(CREEP_DATA[MINI_BOSS_CREEP].damage)
		unit:SetBaseDamageMax(CREEP_DATA[MINI_BOSS_CREEP].damage)
		unit.attackCount = 0
		if unit.attackCount < 8 then
			local attack = nil
			BuildSystem:EachBuilding(unit.playerRound,function(build)
				attack = build
				return true
			end)
			if attack then
				unit.attackCount = unit.attackCount + 1
				unit:AttackTowerPlayer(unit.playerRound,attack)
			end
		end
		unit:SetContextThink( "Think", function()
			return OnThinkMiniBoss(unit)
		end, 0.1 )
	elseif roundNumber % 5 == 0 then
		local chest = ROUND_DATA.ROUNDS.Special[1]
		local startHealth = 100 / (difficuiltyData.health/100)
		local unit = CreateUnitByName(chest, spawner:GetOrigin(), true, nil,nil, DOTA_TEAM_NEUTRALS)
		if IsSandBox then
			self.tSandbox.tCacheUnits[unit:GetEntityIndex()] = unit
		end
		self.fChestDamage = 0
		self:UpdateQuest(QUEST_FOR_BATTLE_DAMAGE_CHEST)
		unit:AddNewModifier(unit, nil, 'modifier_no_healthbar', {duration = -1})
		unit.playerRound = pID
		unit.roundSpawn = roundNumber
		unit.IsBosses = true
		-- damage transform gold (yeee)
		unit.GoldDropPercentage = 0.08 - (self:GetUniqueBonus() == UNIQUE_BONUS_GOLD_CREEP and 0.01 or 0)
		unit:SetBaseMaxHealth(startHealth)
		unit:SetMaxHealth(startHealth)
		unit:SetHealth(startHealth)
		unit:AddNewModifier(unit, nil, 'modifier_war_of_kings_passive_unit', {duration = -1})
		unit.DeathTime = GameRules:GetDOTATime(false,false) + 35
		self.fChestSpawn = unit.DeathTime
		self:UpdateClientData()
		unit:SetContextThink( "Think", function()
			return OnThinkChest(unit)
		end, 0.1 )
	else
		Timers:CreateTimer(dataRound.SpawnTick,function()
			local unit = CreateUnitByName(units[RandomInt(1,#units)], spawner:GetAbsOrigin(), true, nil,nil, DOTA_TEAM_NEUTRALS)
			if IsSandBox then
				self.tSandbox.tCacheUnits[unit:GetEntityIndex()] = unit
			end
			unit:UpgradeRoundUnit(roundNumber,pID)
			unit.playerRound = pID
			unit.roundSpawn = roundNumber
			if unit:GetBaseDamageMin() > 0 then 
				unit.attackCount = 0
			end
			unit:AddNewModifier(unit, nil, 'modifier_war_of_kings_passive_unit', {duration = -1})
			unit:SetContextThink( "Think", function()
				return OnThinkNormalCreep(unit)
			end, 0.1 )
			self.tDataPerRound[roundNumber].unitCreate = self.tDataPerRound[roundNumber].unitCreate + 1
			return self.tDataPerRound[roundNumber].unitCreate < self.tDataPerRound[roundNumber].count and dataRound.SpawnTick or nil
		end)
	end
end

function Player:ModifyBuildingDamage(iRound,amount,name)
	if not self.bIsGameEnd and self.tDataPerRound[iRound] and self.tDataPerRound[iRound].DamageBuildings then
		self.tDataPerRound[iRound].DamageBuildings[name] = (self.tDataPerRound[iRound].DamageBuildings[name] or 0) + amount
	end
end

function Player:IsAlive() 
	return not self.bIsGameEnd
end

function Player:IsAllCreepChampions()
	return self:IsSandBoxMode() and self.tSandbox.bIsAllChampions
end

function Player:IsSandBoxMode()
	return self.iDifficulty == ROUND_DIFFICUILT_SANDBOX
end

function Player:EndRound(iRound)
	if not self:IsAlive() then return end
	self.tEndRound = self:GetDamageBuildings(iRound)
	self:UpdateQuest(QUEST_FOR_BATTLE_ALIVE_ROUND,1)
	self:UpdateQuest(QUEST_FOR_BATTLE_ROUND_PER_NO_DAMAGE,1)
	self:UpdateClientData()
	self.iRoundAlive = self.iRoundAlive + 1
	if self:GetUniqueBonus() == UNIQUE_BONUS_TOWER and self.iRoundAlive % 3 == 0 and iRound < 80 then 
		local itemName,__gsub___ = string.gsub(PickRandomShuffle(ALL_CARD_NAME,{}),'npc_','item_card_')
		local hero = self:GetSelectedHeroEntity()
		hero:AddItemByName(itemName)
		local particle = ParticleManager:CreateParticle('particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death_v2_beam.vpcf', PATTACH_ABSORIGIN_FOLLOW, hero)
		ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end
	if iRound > 80 then
		self.iRoundAlive_Endless = self.iRoundAlive_Endless + 1
		self:UpdateQuest('2',1,false,true)
	end
end

function Player:EqualTargetGodness(questEnum,unitName)
	return self.tQuests[questEnum] and self.tQuests[questEnum].sTarget == unitName
end

function Player:UpdateClientData()
	local nettables = self:GetNettablesData()
	local BuildingsCardsindexID = nettables and nettables.BuildingsCardsindexID or {}
	CustomNetTables:SetTableValue("PlayerData", "player_" .. self.iPlayerID, {
		CacheRandomCards = self.tCacheCard,
		BuildingsCardsindexID = BuildingsCardsindexID,-- Updating building.lua
		BuildingCardsEndRoundData = self.tEndRound,
		Quests = self.tQuests,
		inventory = self.tInventory,
		runes = self.tRunes,
		FriendLeaderboard = self.tFriendLeaderboard,
		DataEndGame	= self.tEndGame,	
		-- Champions = self.tChampions, 
		Chest = self.fChestDamage,
		AllDamageGame = self.fAllDamageGame,
		Crystal = self.iCrystalCount,
		Difficulty = self.iDifficulty,
		mode = self.iMode,
		amountTower = (self.iAmountTower .. "/" .. self.iMaxTower), -- string
		DailyQuests = self.tDailyQuests, 
		IsDonator = self.bSub,
		IsDev =  self.bIsDev,
		IsTester = self.bIsTester,
		Coins = self.iCoins,
		Experience = self.iExp,
		CountGame = self.iAmountGame,
		ChestSpawnTime = self.fChestSpawn,
		Gold = self.iGold,
	})
end
-- Events

function Player:SetSandBoxDifficulty(enum)
	if not self:IsSandBoxMode() then return end
	local dataEnum = ROUND_DIFFICUILT_DATA[enum]
	self.tSandbox.health = dataEnum.health
	self.tSandbox.damage = dataEnum.damage
end

function Player:SetLoseQuest(questEnum)
	if self:IsSandBoxMode() then return end
	if self.tQuests[questEnum] and QUEST_DATA[questEnum].IsFailing and not self.tQuests[questEnum].tQuestProgress.bLose and  not self.tQuests[questEnum].tQuestProgress.bSucces  then
		self.tQuests[questEnum].tQuestProgress.bLose = true
		self.tQuests[questEnum].tQuestProgress.bSucces = false
		self.tQuests[questEnum].tQuestProgress.iValue = 0
		self:UpdateClientData()
	end
end

function Player:UpdateQuest(questEnum,value,NotUpdateClient,IsDaily)
	if self:IsSandBoxMode() then return end
	if IsDaily then
		if self.tDailyQuests[questEnum] and not self.tDailyQuests[questEnum].Progress.succes and not self.tDailyQuests[questEnum].Progress.lose then 
			local value1 = self.tDailyQuests[questEnum].Progress.value
			self.tDailyQuests[questEnum].Progress.value = math.min(value1 + value,self.tDailyQuests[questEnum].Progress.max)
			self.tDailyQuests[questEnum].Progress.succes = self.tDailyQuests[questEnum].Progress.value == self.tDailyQuests[questEnum].Progress.max
			if self.tDailyQuests[questEnum].Progress.succes then
				self:QuestSucces(questEnum,true)
			end
			if not NotUpdateClient then
				self:UpdateClientData()
			end
		end
		return 
	end
	if self.tQuests[questEnum] and not self.tQuests[questEnum].tQuestProgress.bSucces and not self.tQuests[questEnum].tQuestProgress.bLose  then
		if not value then 
			self.tQuests[questEnum].tQuestProgress.iValue = 0
		else
			self.tQuests[questEnum].tQuestProgress.iValue = math.min(self.tQuests[questEnum].tQuestProgress.iValue + value,self.tQuests[questEnum].tQuestProgress.iMaxValue)
		end
		self.tQuests[questEnum].tQuestProgress.bSucces = self.tQuests[questEnum].tQuestProgress.iValue == self.tQuests[questEnum].tQuestProgress.iMaxValue
		if self.tQuests[questEnum].tQuestProgress.bSucces then
			self:QuestSucces(questEnum)
		end
		if not NotUpdateClient then
			self:UpdateClientData()
		end
	end
end

function Player:SetValueQuest(questEnum,value,IsDaily)
	if self:IsSandBoxMode() then return end
	if IsDaily then
		if self.tDailyQuests[questEnum] and not self.tDailyQuests[questEnum].Progress.succes and not self.tDailyQuests[questEnum].Progress.lose then 
			self.tDailyQuests[questEnum].Progress.value = value
			self.tDailyQuests[questEnum].Progress.succes = self.tDailyQuests[questEnum].Progress.value >= self.tDailyQuests[questEnum].Progress.max
			self:UpdateClientData()
		end
		return
	end
	if self.tQuests[questEnum] and not self.tQuests[questEnum].tQuestProgress.bSucces and not self.tQuests[questEnum].tQuestProgress.bLose then 
		self.tQuests[questEnum].tQuestProgress.iValue = value
		self.tQuests[questEnum].tQuestProgress.bSucces = self.tQuests[questEnum].tQuestProgress.iValue >= self.tQuests[questEnum].tQuestProgress.iMaxValue
		self:UpdateClientData()
	end
end

function Player:QuestSucces(questEnum,IsDaily)
	if self:IsSandBoxMode() then return end
	local particle = ParticleManager:CreateParticle('particles/items_fx/aegis_respawn.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetSelectedHeroEntity())
	ParticleManager:SetParticleControl(particle, 0, self:GetSelectedHeroEntity():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	if IsDaily then
		request:RequestData('GET','quest_daily',function(obj)
			if obj.__inventory then
				self.tInventory = obj.__inventory
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnSuccesQuest', {})
			end
			if obj.Coins then
				self.iCoins = obj.Coins
			end
		end,{
			SteamID = PlayerResource:GetRealSteamID(self.iPlayerID),
			Type = self.tDailyQuests[questEnum].dropType,
			ItemIndex = self.tDailyQuests[questEnum].drop,
			enum = questEnum,
		})
		return
	end
	local data = self.tQuests[questEnum]
	local add = data.aValueDropSucces
	local valute = data.sDropType
	if (valute == 'card') then
		self:GetSelectedHeroEntity():AddItemByName(add)
		return
	end
	if valute == 'crystal' then 
		self:ModifyCrystal(add)
		return 
	end
	self:ModifyGold(add)
end

function Player:OnRefreshingCard(chances,GoldCost)
	local cards = card:GetRandomCards(chances,tonumber(self.bSub) > 0)
	if table.length(self.tCacheCard) > 0 and self.iGoldCostCache then
		self:ModifyGold(self.iGoldCostCache * 0.5)
	end 
	self.tCacheCard  = cards
	self.iGoldCostCache = GoldCost
	self:ModifyGold(-self.iGoldCostCache)
	self:UpdateClientData()
	-- Timers:CreateTimer(0.01,function()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnUpdateCards', {
		data = self.tCacheCard
	})
	-- end)
	self:UpdateQuest(QUEST_FOR_BATTLE_SPEND_GOLD,GoldCost,true)
end

function Player:ApplyDamage(unit)
	local hero = self:GetSelectedHeroEntity()
	if not hero:IsAlive() then return end
	self:SetLoseQuest(QUEST_FOR_BATTLE_ROUND_PER_NO_DAMAGE)
	if type(unit) == 'boolean' then
		ApplyDamage({
			victim = hero,
			attacker = hero,
			damage = 1000,
			damage_type = DAMAGE_TYPE_PURE,
		})
	else
		local damage = unit:GetUnitName() == 'npc_war_of_kings_wave_boss_end' and 100 or 
		unit.IsChampion == true and 3 or 1
		if hero:HasModifier('modifier_bonus_life') and hero:GetHealth() - damage < 1 then
			hero:RemoveModifierByName('modifier_bonus_life')
			hero:SetHealth(100)
		else
			ApplyDamage({
				victim = hero,
				attacker = hero,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
			})
		end
	end
	if not hero:IsAlive() then
		self:GameEnd()
	end
end

function Player:GameEnd()
	self.bIsGameEnd = true
	local pID = self.iPlayerID
	local cardsData = {}
	BuildSystem:EachBuilding(pID,function(build)
		local hItemData = {}
		for i=0, 5 do
			local current_item = build.hUnit:GetItemInSlot(i)
			if current_item  then
				hItemData[i] = current_item:GetAbilityName()
			end
		end
		local data = {
			cardName = build:GetUnitEntityName(),
			rarity = build:GetRariry(),
			class = build:GetClass(),
			Grade = build.iGrade,
			Level = build.iLevel,
			iXp =  build:GetCurrentXp(),
			iMaxXp = build:GetTotalEarnedXP(),
			iMaxGrade = self:GetNettablesData().BuildingsCardsindexID[tostring(build.hUnit:GetEntityIndex())].iMaxGrade,
			items = hItemData,
			fTotalDamage = build.damage,
		}
		table.insert(cardsData,data)
		build:RemoveSelf()
	end)
	local hero = self:GetSelectedHeroEntity()
	local unit = FindUnitsInRadius(hero:GetTeam(),hero:GetAbsOrigin(), nil, -1,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
	for k,v in pairs(unit) do
		if v.playerRound == self.iPlayerID then 
			v:ForceKill(false)
		end
	end
	self.tEndGame = {
		round = self.iRoundAlive,
		endlessRound = self.iRoundAlive_Endless,
		gold = self.iGoldCountAllGame,
		crystal = self.iCrystalAllGame,
		CardsData = cardsData,
		allDamage = self.fAllDamageGame,
		rank = self.iRank,
		ExpBonus = self.iRoundAlive * (tonumber(self.bSub) > 0 and 2 or 1) * (self.iUnique == UNIQUE_BONUS_CLOSE and 2 or 1)
	}
	self.iExp = self.iExp + (self.tEndGame.ExpBonus)
	self:RequestInfo(cardsData)
	for k,v in pairs(cardsData) do
		cardsData[k].class = nil
		cardsData[k].rarity = nil
	end
	self:UpdateClientData()
	CustomGameEventManager:Send_ServerToAllClients('OnDeathPlayer', {
	[self.iPlayerID] = {
		DataEndGame = self.tEndGame
	}})
end

function Player:OnSprayItem(index)
	local data = CustomNetTables:GetTableValue("PlayerData", "GLOBAL_SETTING").SHOP_DATA
	if not data[tostring(index)] or not self.tInventory[tostring(index - 1)] then 
		print('Inventory not found item by index = '..index..' type = '..type(index))
		return 
	end
	request:RequestData('POST','spray',function(obj)
		-- PrintTable(obj)
		if obj.error then 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnBuyReturnInfo', {
				error = obj.error 
			})
			return 0
		end
		self.tInventory = obj.NewInventory
		self.iCoins = obj.NewCoins
		self:UpdateClientData()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnBuyReturnInfo', {
			IsShopUpdate = true,
		})
	end,{
		SteamID = PlayerResource:GetRealSteamID(self.iPlayerID),
		ItemIndex = index,
	})
end

function Player:BuyItemShop(index,days)
	local data = CustomNetTables:GetTableValue("PlayerData", "GLOBAL_SETTING").SHOP_DATA
	if not data[index] then return end
	request:RequestData('GET','shop',function(obj)
		local updateShop = false
		-- PrintTable(obj)
		if (obj.error) then 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnBuyReturnInfo', {
				error = obj.error,
			})
			return
		end
		local update = obj.newData
		self.iCoins = update.Coins
		if update.Runes then 
			self.tRunes = {
				physical_rune = update.Runes['1'], -- 1
				magical_rune = update.Runes['2'], -- 2
				life_rune = update.Runes['3'], -- 3
			}
		end
		if update.Premium then 
			self.bSub = update.Premium.Level
		end
		if update.Inventory then 
			self.tInventory = update.Inventory
			updateShop = true
		end
		self:UpdateClientData();
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.iPlayerID), 'OnBuyReturnInfo', {
			IsShopUpdate = updateShop,
		})
	end,{
		SteamID = PlayerResource:GetRealSteamID(self.iPlayerID),
		ItemIndex = index,
		days = days,
		Runes = self.tRunes,
	})
end

function Player:OnCreepPassed(unit)
	self:ModifyUnitSkip(unit.roundSpawn)
	self:ApplyDamage(unit)

end

function Player:SetModel(str,reModel)
	if not str then 
		print('str set model not found, str = '..tostring(str))
		return 
	end
	self.model = str
	if (reModel) then 
		self:UpdateModel()
	end
end

function Player:UpdateModel(unit)
	unit = unit or self:GetSelectedHeroEntity()
	unit:SetOriginalModel(self.model)
	unit:SetModel(self.model)
end

function Player:OnDiscardCard()
	local pID = self.iPlayerID
	local nettables = CustomNetTables:GetTableValue("PlayerData", "player_" .. pID)
	local player = PlayerResource:GetPlayer(pID)
	local hero = self:GetSelectedHeroEntity()
	self.tCacheCard  = {}
	self:ModifyGold(self.iGoldCostCache * 0.5)
	self:UpdateClientData()
	CustomGameEventManager:Send_ServerToPlayer(player, 'OnDiscard', {})
end

function Player:OnBuyCard(cardID)
	local hero = self:GetSelectedHeroEntity()
	local cardName = self.tCacheCard[cardID]
	self.tTowerBuy[cardName] = (self.tTowerBuy[cardName] or 0) + 1
	local name,_ = string.gsub(cardName,'npc_','item_card_')
	hero:AddItemByName(name).cost = self.iGoldCostCache or 0
	self.tCacheCard  = {}
	self:UpdateClientData()
	local player = PlayerResource:GetPlayer(self.iPlayerID)
	CustomGameEventManager:Send_ServerToPlayer(player, 'OnDiscard', {})
end

-- Modify Methods

function Player:SetDifficulty(diff)
	if diff then
		self.iDifficulty = diff
		self:UpdateClientData()
	end
end

function Player:SetQuests(data)
	self.tQuests = data
	self:UpdateClientData()
	local player = PlayerResource:GetPlayer(self.iPlayerID)
	CustomGameEventManager:Send_ServerToPlayer(player, 'OnCreateNewQuests', {})
end

function Player:ModifyDamageAll(amount)
	self.fAllDamageGame = self.fAllDamageGame + amount
	self:UpdateClientData()
end

function Player:ModifyDamageChest(fdamage)
	self.fChestDamage = self.fChestDamage + fdamage
	self.fChestDamageTotal = self.fChestDamageTotal + fdamage
	self:UpdateClientData()
	self:UpdateQuest(QUEST_FOR_BATTLE_DAMAGE_CHEST,math.floor(fdamage))
end

function Player:SetDataByRound(round,data)
	self.tDataPerRound[round] = data
end

function Player:AddBuildingData(entityId)
	table.insert(self.tBuildingData,entityId)
	self:UpdateClientData()
end

function Player:ModifyAllGold(amount)
	self.iGoldCountAllGame = self.iGoldCountAllGame + amount
	if amount < 0 then
		self:UpdateQuest(QUEST_FOR_BATTLE_SPEND_GOLD,-amount)
	end
end

function Player:ModifyCrystal(amount)
	if amount > 0 then
		self.iCrystalAllGame = self.iCrystalAllGame + amount
	end
	if amount < 0 then
		self:UpdateQuest(QUEST_FOR_BATTLE_SPEND_CRYSTAL,-amount)
	end
	self.iCrystalCount = self.iCrystalCount + amount
	self:UpdateClientData()
end

function Player:IncrementKills(iRound)
	if not self.bIsGameEnd and self.tDataPerRound[iRound] and self.tDataPerRound[iRound] then
		self.tDataPerRound[iRound].kills = self.tDataPerRound[iRound].kills + 1
	end
end
-- Sand Box Setting
function Player:AddCardSandBox(cardName)
	if not self:IsSandBoxMode() then return end
	if cardName and self:IsSandBoxMode() then 
		cardName,__gsub__ = string.gsub(cardName,'npc_','item_card_')
		self:GetSelectedHeroEntity():AddItemByName(cardName)
	end
end
-- 10 lvlup
function Player:ModifyLevelAllTower()
	if not self:IsSandBoxMode() then return end
	BuildSystem:EachBuilding(self.iPlayerID,function(building)
		local lvl = building:GetLevel()
		if lvl < 1000 then
			building:AddExperience(building:GetNeedXpByLevelUp(math.min(lvl + 9,998)))
		end
	end)
end

function Player:ModifyGradeAllTower(IsMax)
	if not self:IsSandBoxMode() then return end
	BuildSystem:EachBuilding(self.iPlayerID,function(building)
		building:UpgradeBuilding(IsMax and CARD_DATA.MAX_GRADE[building:GetRariry()])
	end)
end

function Player:ToggleInvulTowers()
	if not self:IsSandBoxMode() then return end
	BuildSystem:EachBuilding(self.iPlayerID,function(building)
		building:ToggleInvul()
	end)
end

function Player:ToggleAllChampions()
	if not self:IsSandBoxMode() then return end
	self.tSandbox.bIsAllChampions = not self.tSandbox.bIsAllChampions
end

function Player:StartRoundSandBox(iRound)
	if not self:IsSandBoxMode() then return end
	local pID = self.iPlayerID
	local hero = self:GetSelectedHeroEntity()
	local spawner = self:GetRoundSpawner()
	local dataRound = round:IsSpecialRound(iRound) and {} or round:GetDataRound(iRound)
	local units = round:IsSpecialRound(iRound) and {} or string.split(dataRound.UnitList,' | ')
	self:SpawnRound(iRound,units,dataRound)
end

function Player:KillAllCreepSandBox()
	if not self:IsSandBoxMode() then return end
	local hero = self:GetSelectedHeroEntity()
	for index,unit in pairs(self.tSandbox.tCacheUnits) do
		unit:Kill(nil,hero)
		if unit:IsAlive() then
			unit:Kill(nil,hero)
		end
		self.tSandbox.tCacheUnits[index] = nil
	end

end

function Player:GetXpAndOst()
	local xp = tonumber(self.iExp);
	local lvl = 1;
	while xp > 35 do
		xp = xp - 35;
		lvl = lvl + 1;
	end
	return {
		Level = lvl,
		Exp = xp,
	}
end

function Player:SetUnique(index)
	if not index then print('unique id not found') return end
	if UNIQUE_ACCES_LVL[index] and self.ExpAndOst.Level < UNIQUE_ACCES_LVL[index] then return end
	self.iUnique = index
end
function Player:ModifyGold(amount,fx)
	if not amount or (type(amount) ~= 'string' and type(amount) ~= 'number') then 
		error("[Modify Gold] Gold = `" .. amount .. "` Type = `" .. type(amount) .. '`')
		return
	end
	amount = tonumber(amount)
	-- PlayerResource:ModifyGold(self.iPlayerID, amount, false, DOTA_ModifyGold_Unspecified)
	self:SetGold(self:GetGold() + amount)
	if fx and amount > 0 then
		local hero = self:GetSelectedHeroEntity()
		local player  = hero:GetPlayerOwner()
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, hero, math.floor(amount), player)
	end
	if amount < 0 then
		self:UpdateQuest(QUEST_FOR_BATTLE_SPEND_GOLD,-amount)
	end
end

function Player:GetGold()
	return self.iGold
end

function Player:SetGold(gold)
	if gold then
		self.iGold = math.max(gold,0)
		self:UpdateClientData()
	end
end

function Player:ModifyTowerAmount(amount,typeModify,set)
	if typeModify == 'max' then
		self.iMaxTower = set and amount or (self.iMaxTower + amount ) 
		self:UpdateClientData()
		return
	end
	self.iAmountTower = set and amount or (self.iAmountTower + amount ) 
	self:UpdateClientData()
end

function Player:ModifyChampions(entityID,value)
	-- self.tChampions[tostring(entityID)] = value or nil
	-- self:UpdateClientData()
end

function Player:ModifyUnitSkip(iRound)
	if not self.bIsGameEnd and self.tDataPerRound[iRound] and self.tDataPerRound[iRound] then
		self.tDataPerRound[iRound].unitSkip = self.tDataPerRound[iRound].unitSkip + 1
	end
end

function Player:SetRunes(rune,amount)
	self.tRunes[rune] = math.max(amount,0)
	self:UpdateClientData()
end

function Player:ModifyRune(rune,amount)
	self:SetRunes(rune,self:GetRuneCount(rune) + amount)
end

function Player:IncrementKillChest()
	self.iKillChest = self.iKillChest + 1
end

function Player:SetTimeAllKillCreep(iRound,fTime)
	if self.tDataPerRound[iRound] and not self.bIsGameEnd then
		self.tDataPerRound[iRound].fTimeFullKill = fTime
	end
end

function Player:SetIsFullKillCreep(iRound,bFullKill)
	if self.tDataPerRound[iRound] and not self.bIsGameEnd then
		self.tDataPerRound[iRound].bFullKill = bFullKill
	end
end

-- Get Methods

function Player:GetSelectedHeroEntity()
	return self.hSelected
end

function Player:IsGameEnd()
	return self.bIsGameEnd
end

function Player:IsFullKill(iRound)
	if self.tDataPerRound[iRound] then
		return self.tDataPerRound[iRound].bFullKill
	end
	return nil
end

function Player:GetDifficultyData()
	local diff = self:GetDifficulty()
	if self:IsSandBoxMode() then
		return self.tSandbox
	end
	return ROUND_DIFFICUILT_DATA[diff]
end

function Player:GetRuneCount(rune)
	if not self.tRunes[rune] then 
		print('Error player by id = ' .. self:GetPlayerID() .. ' not found rune by name = ' .. rune .. ' default return 0')
	end
	return self.tRunes[rune] or 0
end

function Player:GetDamageChest()
	return self.fChestDamage
end

function Player:GetUniqueBonus()
	return self.iUnique
end

function Player:GetPlayerID()
	return self.iPlayerID
end

function Player:GetSpawnCreepCount(iRound)
	return self.tDataPerRound[iRound] and self.tDataPerRound[iRound].count or nil
end

function Player:GetKillsRound(iRound)
	return self.tDataPerRound[iRound] and self.tDataPerRound[iRound].kills or nil
end

function Player:GetSkipCreepRound(iRound)
	return self.tDataPerRound[iRound] and self.tDataPerRound[iRound].unitSkip or nil
end

function Player:GetCrystal()
	return self.iCrystalCount
end

function Player:GetBuildings()
	return self.tBuildingData
end

function Player:GetKillChest()
	return self.iKillChest
end

function Player:GetDifficulty()
	return self.iDifficulty
end

function Player:GetMode()
	return self.iMode
end

function Player:GetNettablesData()
	return CustomNetTables:GetTableValue('PlayerData', "player_" .. self.iPlayerID)
end

function Player:GetRoundSpawner()
	return self.hspawnerCreep
end

function Player:IsSubscriber()
	return self.bSub > 0
end


function Player:GetDamageBuildings(iRound)
	if self.tDataPerRound[iRound] and self.tDataPerRound[iRound].DamageBuildings and not self.bIsGameEnd then
		return self.tDataPerRound[iRound].DamageBuildings
	end
	return {}
end

function Player:GetRandomGodnessSpecial()
	local dataCountBuilds = {}
	local units = ROUND_DATA.ROUNDS.Special[2]
	BuildSystem:EachBuilding(self.iPlayerID,function(building)
		dataCountBuilds[building:GetClass()] = (dataCountBuilds[building:GetClass()] or 0 ) + 1
	end)
	local chanceDrop = {}
	local MaxCount = 0
	for class,count in pairs(dataCountBuilds) do
		MaxCount = math.max(MaxCount,count)
	end
	for class,count in pairs(dataCountBuilds) do
		chanceDrop[class] = 100*(count/MaxCount)
	end
	for class,chance in pairs(chanceDrop) do
		if RollPercentage(chance) then
			return units[class]
		end
	end
	local maxChance = 0
	local classMaxChance = 0
	for class,chance in pairs(chanceDrop) do
		if maxChance < chance then
			maxChance = chance
			classMaxChance = class
		end
	end
	return units[classMaxChance] or 'npc_war_of_Kings_special_boss_warrior'
end
