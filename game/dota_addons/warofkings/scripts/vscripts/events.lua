function GameMode:StartGameEvents()
  	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
  	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
  	ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)
  	ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameMode, 'OnEntityHurt'), self) 
  	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(GameMode, 'OnPurchasedItem'), self) 
  	ListenToGameEvent("modifier_event", Dynamic_Wrap(GameMode, 'OnModifierEvent'), self)

  	CustomGameEventManager:RegisterListener("OnUseAbility", Dynamic_Wrap(GameMode, 'OnUseAbility'))
  	CustomGameEventManager:RegisterListener("OnSelectionUnique", Dynamic_Wrap(GameMode, 'OnSelectionUnique'))
  	CustomGameEventManager:RegisterListener("OnCardAddPlayerSandBox", Dynamic_Wrap(GameMode, 'OnCardAddPlayerSandBox'))
  	CustomGameEventManager:RegisterListener("OnBuyShopItem", Dynamic_Wrap(GameMode, 'OnBuyShopItem'))
  	CustomGameEventManager:RegisterListener("OnSprayItem", Dynamic_Wrap(GameMode, 'OnPlayerSprayitem'))
  	CustomGameEventManager:RegisterListener("OnSelectCourier", Dynamic_Wrap(GameMode, 'OnPlayerSelectCourier')) 
  	CustomGameEventManager:RegisterListener("OnSelectDefaultTower", Dynamic_Wrap(GameMode, 'OnSelectDefaultTower'))
  	CustomGameEventManager:RegisterListener("custom_shop_buy_item", Dynamic_Wrap(CustomShop, 'OnBuyItem'))
  	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
  	--CustomGameEventManager:RegisterListener("OnUpgradeTalent", Dynamic_Wrap(Talents, 'OnUpgradeTalent'))
end
function GameMode:OnSelectDefaultTower(data)
	GetPlayerCustom(data.PlayerID):OnSelectDefaultTower(data.TowerName)
end

function GameMode:OnPlayerSprayitem(data)
	GetPlayerCustom(data.PlayerID):OnSprayItem(data.itemIndex)
end
function GameMode:OnPlayerSelectCourier(data)
	GetPlayerCustom(data.PlayerID):OnSelectCourierModel(data.itemIndex)
end

function GameMode:OnBuyShopItem(data)
	GetPlayerCustom(data.PlayerID):BuyItemShop(data.index,data.days)
end

function GameMode:OnDisconnect(keys)
  -- local name = keys.name
  -- local networkid = keys.networkid
  -- local reason = keys.reason
  -- local userid = keys.userid
  GetPlayerCustom(keys.PlayerID):ApplyDamage(true)

end

function GameMode:OnCardAddPlayerSandBox(data)
	local __Player = GetPlayerCustom(data.PlayerID)
	if data.typeEvent == 1 then 
		__Player:AddCardSandBox(data.card_name)
	end
	if data.typeEvent == 2 then 
		__Player:ModifyLevelAllTower()
	end
	if data.typeEvent == 3 then 
		__Player:ModifyGradeAllTower()
	end
	if data.typeEvent == 4 then 
		__Player:ModifyGradeAllTower(true)
	end
	if data.typeEvent == 5 then 
		__Player:ToggleInvulTowers()
	end
	if data.typeEvent == 6 then 
		__Player:StartRoundSandBox(tonumber(data.round))
	end
	if data.typeEvent == 7 then 
		__Player:KillAllCreepSandBox()
	end
	if data.typeEvent == 8 then 
		__Player:ToggleAllChampions()
	end
	if data.typeEvent == 9 then 
		__Player:SetSandBoxDifficulty(data.type)
	end
end

function GameMode:OnSelectionUnique(data)
	GetPlayerCustom(data.PlayerID):SetUnique(data.iUnique)
end

function GameMode:OnPurchasedItem(data)
	if not data then return end
	GetPlayerCustom(data.PlayerID):UpdateQuest(QUEST_FOR_BATTLE_SPEND_GOLD,data.itemcost)
end

function GameMode:OnUseAbility(data)
	local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local ability = hero:FindAbilityByName(data.ability)
	local __Player = GetPlayerCustom(data.PlayerID)
	local key = data.ability == 'ability_bonus_physical_damage' and 'physical_rune' or
					data.ability == 'ability_bonus_magical_damage' and 'magical_rune' or 'life_rune'
	if ability and ability:IsCooldownReady() and __Player:GetRuneCount(key) > 0 and not __Player:IsGameEnd() then
		if ability:GetLevel() < 1 then
			ability:SetLevel(1)
		end
		ability:OnSpellStart()
		ability:StartCooldown(ability:GetCooldown(1))
		__Player.iRuneUse = __Player.iRuneUse + 1
		__Player:ModifyRune(key,-1)
	end
end

function GameMode:OnGameRulesStateChange(keys) 
	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		card:OnPreLoad()
		CustomShop:_ItemParsing()
	end
	  if newState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE  then 
		--[[for i = 0, 23 do
            local hPlayer = PlayerResource:GetPlayer(i)
            if PlayerResource:IsValidPlayerID(i) and hPlayer and not PlayerResource:HasSelectedHero(i) then
               hPlayer:MakeRandomHeroSelection()
           end
        end]]
    end
	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameMode:HeroSelection()
	end	
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		GameMode:PreGame()
	end 	
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameMode:OnGameInProgress()
	end 
end
function GameMode:OnEntityHurt(keys)
	local VictimUnit = EntIndexToHScript( keys.entindex_killed ) -- Victim
	local AttackerUnit
	local killerAbility
	local damage = keys.damage
	local damagebits = keys.damagebits
		if keys.entindex_attacker ~= nil then AttackerUnit = EntIndexToHScript( keys.entindex_attacker ) end
		if keys.entindex_inflictor ~= nil then killerAbility = EntIndexToHScript( keys.entindex_inflictor ) end
	local pID = UnitVarToPlayerID(AttackerUnit)
end 

function GameMode:OnFirstSpawnHero(keys)
	local SpawnedUnit = EntIndexToHScript(keys.entindex) 
	if not SpawnedUnit:HasModifier('modifier_war_of_kings_passive') then
		SpawnedUnit:AddNewModifier(SpawnedUnit, nil, 'modifier_war_of_kings_passive', {duration = -1}) 
	end
	SpawnedUnit:AddNewModifier(SpawnedUnit, nil, 'modifier_no_healthbar', {duration = -1})
	if SpawnedUnit:GetPlayerID() and not string.match(SpawnedUnit:GetUnitName(),'npc_war_of_kings') then
		local pid = SpawnedUnit:GetPlayerID()
		GetPlayerCustom(pid).hSelected = SpawnedUnit
		SpawnedUnit:Teleport(Entities:FindByName(nil, 'player_spawner_' .. pid ):GetAbsOrigin())
	end
	for k,v in pairs(ABILITY_START_LEVEL) do
		if SpawnedUnit:FindAbilityByName(k) then
			SpawnedUnit:FindAbilityByName(k):SetLevel(v)
		end
	end

end

function GameMode:OnNPCSpawned(keys)
local SpawnedUnit = EntIndexToHScript(keys.entindex)
	if not SpawnedUnit:IsNull() and SpawnedUnit:IsRealHero() then
		local pID = SpawnedUnit:GetPlayerID()
		if  SpawnedUnit.FirstSpawn == nil then
			SpawnedUnit.FirstSpawn = true
			self:OnFirstSpawnHero(keys)
		end
	end
end

function GameMode:OnItemPickedUp(keys)
end

function GameMode:OnEntityKilled( keys )
local killedUnit = EntIndexToHScript( keys.entindex_killed )
local killerEntity
local killerAbility
local damagebits = keys.damagebits
	if keys.entindex_attacker ~= nil then killerEntity = EntIndexToHScript( keys.entindex_attacker ) end
	if keys.entindex_inflictor ~= nil then killerAbility = EntIndexToHScript( keys.entindex_inflictor ) end
	if killedUnit:IsRealHero() then

	end 
	local pID = UnitVarToPlayerID(killerEntity)
	local unitName = killedUnit:GetUnitName()
	if killedUnit.playerRound and not killedUnit.IsSkip then
		local playerID = killedUnit.playerRound
		local __Player = GetPlayerCustom(playerID)
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local roundNumber = round:GetActualRound()
		__Player:IncrementKills(roundNumber)
		if killedUnit:GetGoldBounty() > 0  then 
			__Player:ModifyGold(killedUnit:GetGoldBounty())
		end
		if killerEntity:IsAssembly('silencer_4') then 
			local value = killerEntity:GetSpecialValueForBuilding('silencer_4')
			killerEntity:ModifyIntellect(value)
			killerEntity.fIntellect_bonus = killerEntity.fIntellect_bonus + value
		end
		local xpDrop = killedUnit:GetDeathXP()
		if xpDrop > 0 and (BuildSystem:IsBuilding(killerEntity) or (killerEntity.custom_owner and BuildSystem:IsBuilding(killerEntity.custom_owner))) then
			local tower = BuildSystem:IsBuilding(killerEntity) and killerEntity or killerEntity.custom_owner
			
			tower:GetBuilding():AddExperience(xpDrop/2)
			xpDrop = (xpDrop / 2) / math.max(BuildSystem:GetCountBuild(playerID) - 1,1)

			BuildSystem:EachBuilding(playerID,function(build)
				if build:GetUnitEntity() ~= tower:GetBuilding():GetUnitEntity() then
					build:AddExperience(xpDrop)
				end
			end)
		end
		if killedUnit.bIsGodness then
			hero:AddItemByName('item_hero_essence')
			if __Player:EqualTargetGodness(QUEST_FOR_BATTLE_KILL_GODNESS_BY_NAME,unitName) then 
				__Player:UpdateQuest(QUEST_FOR_BATTLE_KILL_GODNESS_BY_NAME,1)
			end
		end
		if killedUnit.IsChampion == true then
			__Player:ModifyChampions(killedUnit:GetEntityIndex(),nil)
		end
		if killedUnit.crystalDrop then
			__Player:ModifyCrystal(killedUnit.crystalDrop)
		end
		if killedUnit.IsMiniBoss then
			__Player:UpdateQuest(QUEST_FOR_BATTLE_KILL_MINI_BOSS_COUNT,1)
			if RollPercentage(CREEP_DATA[MINI_BOSS_CREEP].chance_drop_card) then
				local randomCard = string.gsub(PickRandomShuffle(ALL_CARD_NAME,{}),'npc_','item_card_')
				hero:AddItemByName(randomCard)
			end
		end
		__Player:UpdateQuest(QUEST_FOR_BATTLE_KILL_COUNT,1)
		if RollPercentage(2) then 
			local index = (killedUnit:IsBoss() or killedUnit.IsMiniBoss) and 3 or killedUnit.IsChampion == true and 2 or 1
			local item,drop = killedUnit:DropItem(PickRandomShuffle(DROP_UNIQUE_BONUS_DROP_CHANCE[index],{}),killedUnit:GetAbsOrigin())
			if drop then 
			local nfx = ParticleManager:CreateParticle("particles/neutral_item_drop_lvl" .. index.. ".vpcf" , PATTACH_CUSTOMORIGIN, nil );
				ParticleManager:SetParticleControl(nfx, 0, drop:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex( nfx );
			end
		end
		if __Player:IsSandBoxMode() then 
			__Player.tSandbox.tCacheUnits[killedUnit:GetEntityIndex()] = nil
		end
	end
end

function GameMode:OnPlayerChat(keys)
	local text = keys.text
	local ID = keys.userid
	local PlayerId = keys.playerid
	if PlayerId and PlayerId >= 0 then
		local player = PlayerResource:GetPlayer(PlayerId)
		local commands = {}
		for v in string.gmatch(string.sub(text, 2), "%S+") do 
			table.insert(commands, v) 
		end		
		local command = table.remove(commands, 1)
		if command == "-" or not command then return end
		local prob =  text:find(" ") or 0
		local numbers = string.sub(text, prob+1)
		local cmd = CHAT_COMMANDS[command:upper()]	
		if cmd and cmd.ACCESS <= GetAccesCheatsPlayer(PlayerId) then
			cmd.funcs(numbers,PlayerId)
		end 
	end
end