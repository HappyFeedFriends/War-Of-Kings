if not round then
	round = class({})
end

ModuleRequire(...,'data')
function round:Preload()
		round.Round = 1
		CustomGameEventManager:RegisterListener("OnPickDiff", Dynamic_Wrap(round, 'OnPickDiff'))
		round.spawners = {
			[0] = Entities:FindByName(nil, "spawner_creep_0"),
			[1] = Entities:FindByName(nil, "spawner_creep_1"),
			[2] = Entities:FindByName(nil, "spawner_creep_2"),
			[3] = Entities:FindByName(nil, "spawner_creep_3"),
		}
end

function round:UpgradeDifficultyState(state)
	round.DifficultyState = state
	if round.DifficultyState == ROUND_DIFFICUILT_STATE_START then
		local nettables = CustomNetTables:GetTableValue('PlayerData', "GLOBAL_SETTING")
		nettables.PickTime = PICK_DIFFICULTY_TIME + GameRules:GetDOTATime(false,false)
		CustomNetTables:SetTableValue("PlayerData", "GLOBAL_SETTING", nettables)
		round:UpgradeDifficultyState(ROUND_DIFFICUILT_STATE_TICK)
		Timers:CreateTimer(PICK_DIFFICULTY_TIME,function()
			round:UpgradeDifficultyState(ROUND_DIFFICUILT_STATE_END)
		end)
	end
	if round.DifficultyState == ROUND_DIFFICUILT_STATE_END then
		PlayerResource:PlayerIterate(function(pID)
			local __Player = GetPlayerCustom(pID)
			__Player:SetQuests(quest:GenerationAllQuest(pID))
			local unique = __Player:GetUniqueBonus()
			local hero = __Player:GetSelectedHeroEntity()
			if unique == UNIQUE_BONUS_PHYSICAL then 
				hero:AddNewModifier(hero, nil, 'modifier_unique_aura_physical', {duration = -1})
			end
			if unique == UNIQUE_BONUS_MAGICAL then 
				hero:AddNewModifier(hero, nil, 'modifier_unique_aura_magical', {duration = -1})
			end
			if unique == UNIQUE_BONUS_MIDAS then 
				hero:AddNewModifier(hero, nil, 'modifier_unique_aura_midas', {duration = -1})
			end
			if unique == UNIQUE_BONUS_DROP_CHANCE then 
				hero:AddNewModifier(hero, nil, 'modifier_unique_aura_all_damage', {duration = -1})
			end
			if unique == UNIQUE_BONUS_HEALTH then 
				hero:SetBaseMaxHealth(150)
				hero:SetMaxHealth(150)
				hero:SetHealth(150)
			end

			local tower = __Player.sTowerDefault:gsub('npc_','item_card_')

			hero:AddItemByName(tower)

			PlayerResource:SetCameraTarget(pID, hero)
			Timers:CreateTimer(0.1,function()
				PlayerResource:SetCameraTarget(pID, nil)
			end)
			__Player:UpdateModel(hero)
		end)
		Timers:CreateTimer(20,function()
		 	round:StartRound()
		end)
	end
end

function round:OnPickDiff(data)
	local playerMt = GetPlayerCustom(data.PlayerID)
	if playerMt:GetDifficulty() ~= data.pickDiff then
		playerMt:SetDifficulty(data.pickDiff)
	end
end
-- Code......
function round:GetPathCornerUnit(unit,isGodness,isBossEnd)
	if not unit.PathCorner then
		unit.PathCorner = string.gsub('path_corner_{pID}_start','{pID}',unit.playerRound)
		return unit.PathCorner
	end
	local bIsFear = unit:HasModifier('modifier_fear_creep_custom')
	local abs = Entities:FindByName(nil, unit.PathCorner):GetOrigin()
	if bIsFear and unit.PathCorner == string.gsub('path_corner_{pID}_start','{pID}',unit.playerRound) then 
		return unit.PathCorner
	end
	if unit.IsFear then 
		unit.IsFear = nil
		local str = string.gsub(unit.PathCorner,string.gsub('path_corner_{pID}_','{pID}',unit.playerRound),'')
		if str == 'start' then 
			return unit.PathCorner
		end
		if str == '1' then 
			unit.PathCorner = string.gsub('path_corner_{pID}_start','{pID}',unit.playerRound)
			return unit.PathCorner
		end
        local back_to = string.gsub('path_corner_{pID}_','{pID}',unit.playerRound) .. tostring(math.max(math.min(tonumber(str) - 1,9),1))
        unit.PathCorner = back_to
        return unit.PathCorner
	end

	if unit.IsFearRemove then 
		unit.IsFearRemove = nil
		local str = string.gsub(unit.PathCorner,string.gsub('path_corner_{pID}_','{pID}',unit.playerRound),'')
		if str == 'start' then 
			unit.PathCorner = string.gsub('path_corner_{pID}_1','{pID}',unit.playerRound)
			return unit.PathCorner
		end
        local back_to = string.gsub('path_corner_{pID}_','{pID}',unit.playerRound) .. tostring(math.max(math.min(tonumber(str) + 1,9),1))
        unit.PathCorner = back_to
        return unit.PathCorner
	end
	abs.z = unit:GetOrigin().z
	if (unit:GetOrigin() == abs or #(unit:GetOrigin() - abs) < 20)  then
		local start = string.gsub('path_corner_{pID}_start','{pID}',unit.playerRound)
		if unit.PathCorner == start then
			unit.PathCorner = string.gsub(start,'start','1')
			return unit.PathCorner
		end
		local str = string.gsub(unit.PathCorner,string.gsub('path_corner_{pID}_','{pID}',unit.playerRound),'')
		local bonusNumber = bIsFear and -1 or 1
		local number = math.max(math.min(tonumber(str) + bonusNumber,9),1)
		if bIsFear and tonumber(str) == 1 then 
			unit.PathCorner = start
			return unit.PathCorner
		end
		if isGodness and not unit.AllStop and tonumber(str) == 1 and unit.Corner1 and (not unit.Corner2 or unit.Corner2 < 2 ) then
			unit.Corner2 = (unit.Corner2 or 0) + 1
			number = 'start'
		end
		if isGodness and not unit.AllStop and tonumber(str) == 2 and (not unit.Corner1 or unit.Corner1 < 2 ) then
			unit.Corner1 = (unit.Corner1 or 0) + 1
			number = 1
		end

		if isBossEnd and  tonumber(str) == 1 and unit.Corner1 and (not unit.Corner2 or unit.Corner2 < 4 ) then
			unit.Corner2 = (unit.Corner2 or 0) + 1
			number = 'start'
		end
		if isBossEnd and tonumber(str) == 2 and (not unit.Corner1 or unit.Corner1 < 4 ) then
			unit.Corner1 = (unit.Corner1 or 0) + 1
			number = 1
		end
		unit.PathCorner = string.gsub('path_corner_{pID}_','{pID}',unit.playerRound) .. number
	end

	return unit.PathCorner
end

function round:GetDataRound(roundCount)
	local data = ROUND_DATA.ROUNDS[roundCount] or {}
	data.UnitList = data.UnitList or ("npc_war_of_kings_wave_" .. roundCount)
	return data
end
function round:IsSpecialRound(roundNumber)
	return roundNumber % 5 == 0 or roundNumber % CREEP_DATA[MINI_BOSS_CREEP].interval == 0 or roundNumber % 80 == 0
end

function round:UnitLose(unit)
	GetPlayerCustom(unit.playerRound):OnCreepPassed(unit)
end

function round:GetActualRound()
	return math.max(self.Round - 1,1)
end

function round:EndRound(roundNumber)
	local originalRound = roundNumber
	PlayerResource:PlayerIterate(function(pID)
		local __Player = GetPlayerCustom(pID)
		if __Player:IsSandBoxMode() or not __Player:IsAlive() then return end
		__Player:EndRound(roundNumber)
		local difficulty = __Player:GetDifficulty()
		if roundNumber == 80 then
			if __Player:GetDifficulty() == ROUND_DIFFICUILT_HELL then
				__Player:UpdateQuest('4',1,false,true)
			end
			if __Player:GetDifficulty() == ROUND_DIFFICUILT_IMPOSSIBLE then
				__Player:UpdateQuest('5',1,false,true)
			end
			if __Player:GetUniqueBonus() == UNIQUE_BONUS_CLOSE then
				__Player:UpdateQuest('3',1,false,true)
			end
			if __Player.iRuneUse == 0 then 
				__Player:UpdateQuest('0',1,false,true)
			end
			local selected = __Player:GetSelectedHeroEntity()
			if selected:GetHealth() == selected:GetMaxHealth() then 
				__Player:UpdateQuest('1',1,false,true)
			end
			if difficulty == ROUND_DIFFICUILT_SIMPLE then 
				__Player:ApplyDamage(true)
			else
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), 'OnEndlessMode', {})
			end
		end
	end)
	local playerCount = PlayerResource:GetAllPlayerCount(function(pID)
		local __Player = GetPlayerCustom(pID)
		return  not __Player:IsSandBoxMode() and __Player:IsAlive()
	end)
	if playerCount > 0 then
		Timers:CreateTimer(originalRound < 80 and 0.5 or 0.1,function()
			round:StartRound()
		end)
	end
	CustomGameEventManager:Send_ServerToAllClients('OnRoundEnd', {})
end

function CDOTA_BaseNPC:UpgradeRoundUnit(roundNumber,pID)
	local unit = self
	unit.__health__ = unit:GetMaxHealth() -- original health by doom
	local __Player = GetPlayerCustom(pID)
	if roundNumber > 80 then 
		roundNumber = roundNumber - 80
		local startHealth = unit:GetMaxHealth()  + (unit:GetMaxHealth() * roundNumber * 0.7)
		local damage = 0
		unit:SetBaseMaxHealth(startHealth)
		unit:SetMaxHealth(startHealth)
		unit:SetHealth(startHealth)
		-- unit:SetBaseDamageMin(damage)
		-- unit:SetBaseDamageMax(damage)
		unit:SetPhysicalArmorBaseValue(math.min(160 + math.floor(roundNumber/1),260))
		unit:SetBaseMagicalResistanceValue(math.min(55 + math.floor(roundNumber/3),95))
		return 
	end
	if roundNumber > 1 and ((roundNumber + 1) % 80 == 0 
		or (roundNumber - 1) % 80 == 0 
		or (roundNumber + 1) % CREEP_DATA[MINI_BOSS_CREEP].interval == 0
		or (roundNumber - 1) % CREEP_DATA[MINI_BOSS_CREEP].interval == 0) then
		unit:SetRenderColor(78,194,92)
		unit.IsMutant = true
	end
	local difficuiltyData = __Player:GetDifficultyData() 
	local IsMutant = unit.IsMutant
	local startHealth = (unit:GetMaxHealth() * (roundNumber >= 50 and 6.5 or roundNumber >= 40 and 4.6 or roundNumber >= 20 and 2.1 or 1 ))  * (difficuiltyData.health/100)
	local crystalDrop = 1
	local damage = 0
	local goldDrop = self:GetGoldBounty()-- + (self:GetGoldBounty()/100 * 25)
	if IsMutant and RollPercentage(CREEP_DATA[ANCIENT_CREEP].chance) then
		startHealth = startHealth + (startHealth/100 * CREEP_DATA[ANCIENT_CREEP].health)
		crystalDrop = crystalDrop + CREEP_DATA[ANCIENT_CREEP].crystal
		self:AddNewModifier(self, nil, 'modifier_base_movespeed_ancient', {duration = -1})
		goldDrop = goldDrop + (goldDrop/100 * CREEP_DATA[ANCIENT_CREEP].gold)
		damage = CREEP_DATA[ANCIENT_CREEP].damage
	end

	if RollPercentage(CREEP_DATA[CHAMPION_CREEP].chance) or __Player:IsAllCreepChampions() then
		unit:SetModelScale(unit:GetModelScale() + 1)
		startHealth = startHealth + (startHealth/100 * CREEP_DATA[CHAMPION_CREEP].health_bonus)
		crystalDrop = crystalDrop + CREEP_DATA[CHAMPION_CREEP].crystal
		if goldDrop > 0 then
			goldDrop = goldDrop + (goldDrop/100 * CREEP_DATA[CHAMPION_CREEP].gold)
		end
		damage = damage + CREEP_DATA[CHAMPION_CREEP].bonus_damage_tower
		unit.IsChampion = true
		local modif = unit:AddNewModifier(unit, nil, 'modifier_shield', {duration = -1})
		modif:SetStackCount(startHealth/100*CREEP_DATA[CHAMPION_CREEP].shield)
		__Player:ModifyChampions(unit:GetEntityIndex(),true)
		unit:AddNewModifier(unit, nil, 'modifier_bonus_movespeed_creep', {duration = -1})
	end
	if __Player:GetUniqueBonus() == UNIQUE_BONUS_GOLD_CREEP then
		goldDrop = goldDrop + (goldDrop * 0.35)
	end
	damage = damage * (difficuiltyData.damage/100)
	unit.crystalDrop = crystalDrop
	unit:SetMaximumGoldBounty(goldDrop)
	unit:SetMinimumGoldBounty(goldDrop)
	unit:SetBaseMaxHealth(startHealth)
	unit:SetMaxHealth(startHealth)
	unit:SetHealth(startHealth)
	unit:SetBaseDamageMin(damage)
	unit:SetBaseDamageMax(damage)
	unit:SetBaseMagicalResistanceValue(roundNumber < 25 and -20 or
	roundNumber < 45 and 0 or
	roundNumber < 60 and 15 or 30)
end

function round:StartRound()
	local roundNumber = self.Round
	local fTimeStart = GameRules:GetDOTATime(false, false)
	local playerCount
	local GS = CustomNetTables:GetTableValue('PlayerData', 'GLOBAL_SETTING')
	GS.RoundNumber = roundNumber
	CustomNetTables:SetTableValue("PlayerData", "GLOBAL_SETTING", GS)
	Timers:CreateTimer(function()
		playerCount = PlayerResource:GetAllPlayerCount(function(pID)
			local __Player = GetPlayerCustom(pID)
			return  not __Player:IsSandBoxMode() and __Player:IsAlive()
		end)
		local IsSoloRoundWin = false
		local tIsFullKill = {}
		local time = GameRules:GetDOTATime(false, false)
		PlayerResource:PlayerIterate(function(pID)
			local __Player = GetPlayerCustom(pID)
			if __Player:IsSandBoxMode() or not __Player:IsAlive() then return end
			local difficulty = __Player:GetDifficulty()
			local hero = PlayerResource:GetSelectedHeroEntity(pID)
			local killsCount = __Player:GetKillsRound(roundNumber)
			local skipCount = __Player:GetSkipCreepRound(roundNumber)
			local spawnCount = __Player:GetSpawnCreepCount(roundNumber)
			local IsFullKill = __Player:IsFullKill(roundNumber)

			tIsFullKill[pID] = IsFullKill or nil
			if  not hero:IsAlive() or difficulty == ROUND_DIFFICUILT_SANDBOX then 
				tIsFullKill[pID] = true
			elseif not IsFullKill and killsCount + skipCount >= spawnCount then
				tIsFullKill[pID] = true
				__Player:SetIsFullKillCreep(killsCount == spawnCount)
				if killsCount == spawnCount then
					__Player:SetTimeAllKillCreep(roundNumber,time - fTimeStart)
				end
			end
			IsSoloRoundWin = (playerCount == 1 and __Player:IsFullKill(roundNumber))
		end)

		if IsSoloRoundWin or table.length(tIsFullKill) >= playerCount then
			round:EndRound(roundNumber)
			return nil
		end
		return 0.1
	end)
	local dataRound = round:IsSpecialRound(roundNumber) and {} or round:GetDataRound(roundNumber)
	local units = round:IsSpecialRound(roundNumber) and {} or string.split(dataRound.UnitList,' | ')
	PlayerResource:PlayerIterate(function(pID) 
		local __Player = GetPlayerCustom(pID)
		if __Player:IsSandBoxMode() then return end
		if roundNumber > 80 then
			__Player:SpawnEndlessRound(roundNumber) 
			return 
		end
		__Player:SpawnRound(roundNumber,units,dataRound)
	end)
	self.Round = self.Round + 1
end

function OnThinkLastBoss(unit)
	local corner = unit.PathCorner
	if unit:IsNull() or not unit:IsAlive() then return nil end
	if corner ~= round:GetPathCornerUnit(unit,false,true) then
		if not unit:IsDisarmed() then 
			local attack = nil
			BuildSystem:EachBuilding(unit.playerRound,function(build)
				attack = build
				return true
			end)
			if attack and unit.attackCount < 8 then
				unit.attackCount = unit.attackCount + 1
				unit:AttackTowerPlayer(unit.playerRound,attack)
			end
		end
		unit:MoveToPosition(Entities:FindByName(nil, unit.PathCorner):GetOrigin())
	end
	local unitabs = unit:GetAbsOrigin()
	local cornerabs = Entities:FindByName(nil, unit.PathCorner):GetAbsOrigin()
	cornerabs.z = unitabs.z
	if string.find(unit.PathCorner,'_9') and (unitabs == cornerabs or #(unitabs - cornerabs) < 10) then
		round:UnitLose(unit)
		unit.IsSkip = true
		unit:ForceKill(false)
		return nil
	end
	return 0.1
end

function OnThinkMiniBoss(unit)
	local corner = unit.PathCorner
	if unit:IsNull() or not unit:IsAlive() then return nil end
	if corner ~= round:GetPathCornerUnit(unit,true) then
		if unit.PathCorner == 'path_corner_' ..unit.playerRound .. '_4'  then 
			unit.IsSkip = true
			unit:ForceKill(false)
			local __Player = GetPlayerCustom(unit.playerRound)
			return nil
		end
		unit:MoveToPosition(Entities:FindByName(nil, unit.PathCorner):GetOrigin())
	end
	return 0.1
end

function OnThinkChest(unit)
	local corner = unit.PathCorner
	if unit:IsNull() or not unit:IsAlive() then return nil end
	if  unit.DeathTime < GameRules:GetDOTATime(false,false) or corner ~= round:GetPathCornerUnit(unit) then
		if  unit.DeathTime < GameRules:GetDOTATime(false,false) then 
			unit.IsSkip = true
			local __Player = GetPlayerCustom(unit.playerRound)
			__Player.fChestSpawn = -1
			kills:CreateCustomToast({
				type = "generic",
				text = "#UI_toast_chest_win",
				gold = unit:GetMaxHealth(),
				player = unit.playerRound,
				variables = {
					['{damage}'] = __Player:GetDamageChest(),
				}
			})
			__Player:ModifyAllGold(unit:GetMaxHealth())
			__Player:IncrementKills(unit.roundSpawn)
			__Player:ModifyGold(unit:GetMaxHealth(),true)
			__Player.iGoldСhestDrop = __Player.iGoldСhestDrop + unit:GetMaxHealth()
			__Player:IncrementKillChest()
			__Player:SetValueQuest('6',unit:GetMaxHealth(),true)
			unit:ForceKill(false)
			return nil
		end
		unit:MoveToPosition(Entities:FindByName(nil, unit.PathCorner):GetOrigin())
	end
	return 0.1
end

function OnThinkNormalCreep(unit,IsEndless)
	local corner = unit.PathCorner
	if unit:IsNull() or not unit:IsAlive() then return nil end
	if corner ~= round:GetPathCornerUnit(unit) then
		local __Player = GetPlayerCustom(unit.playerRound)
		if __Player:GetUniqueBonus() ~= UNIQUE_BONUS_CREEP_NOT_USE_ABILITY then
			local lastSymbol = unit.PathCorner:sub(#unit.PathCorner,#unit.PathCorner)
			local nextPath = unit.PathCorner:match('start') and unit.PathCorner:gsub('start','1') or unit.PathCorner:gsub(lastSymbol,tonumber(lastSymbol) + 1)
			if not unit.PathCorner:match('start') and not unit:IsSilenced() then
				for i = 0,5 do 
					local ability = unit:GetAbilityByIndex(i)
					if ability and ability.OnSwapPathCorner then 
						ability.OnSwapPathCorner(ability,{
							newPathCorner = unit.PathCorner,
							nextPathCorner = nextPath,
						})
					end
				end
			end
		end
		if unit.attackCount and unit.attackCount < (IsEndless and 2 or 5) and not unit:IsDisarmed() then
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
		unit:MoveToPosition(Entities:FindByName(nil, unit.PathCorner):GetOrigin())
	end
	local unitabs = unit:GetAbsOrigin()
	local cornerabs = Entities:FindByName(nil, unit.PathCorner):GetAbsOrigin()
	cornerabs.z = unitabs.z
	if string.find(unit.PathCorner,'_9') and (unitabs == cornerabs or #(unitabs - cornerabs) < 10) then
		round:UnitLose(unit)
		unit.IsSkip = true
		unit:ForceKill(false)
		return nil
	end
	return 0.1
end