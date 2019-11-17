if not card then
	card = class({})
end

ModuleRequire(...,'data')

function card:OnPreLoad()
	CustomGameEventManager:RegisterListener("OnBuyCard", Dynamic_Wrap(card, 'OnBuyCard'))
	CustomGameEventManager:RegisterListener("OnDiscardCard", Dynamic_Wrap(card, 'OnDiscard'))
	card:PlayerDataLoad()
	card:LoadDataAllCard()
	BuildSystem:init()
	CustomNetTables:SetTableValue("PlayerData", "GLOBAL_SETTING", {
		NEED_CARD_UPGRADE = CARD_DATA.COUNT_CARD_BY_UPGRADE,
		GOLD_COST_REFRESHING = CARD_DATA.GOLD_COST_REFRESHING_CARD,
		MAX_CARD_PER_PLAYER = CARD_DATA.MAX_CARD,
		ROUND_DIFFICUILT_DATA = ROUND_DIFFICUILT_DATA,
		PickTime = -1,
		RoundNumber = 0,
		STATS_BONUS_PER_GRADE = CARD_DATA.DAMAGE_PER_LEVEL,
		MAX_GRADE = CARD_DATA.MAX_GRADE,
		CLASS_DATA = CLASS_DATA,
		CUSTOM_SHOP_DATA = CUSTOM_SHOP_DATA,
		CREEP_DATA = CREEP_DATA,
		SHOP_DATA = {},
		LeaderboardGlobal = {},
	})
end

function card:OnBuyCard(data)
	local mTable = GetPlayerCustom(data.PlayerID)
	mTable:OnBuyCard(data.CardID)

end
function card:GetPrototypeModelUnit(cardName)
	local model = GetKeyValueByHeroName(cardName, 'Model')
	for _,name in pairs(KeyValues.AllNameUnits) do
		if GetKeyValueByHeroName(name, 'Model') == model and name ~= cardName then
			return name
		end
	end
	return cardName
end 

function card:LoadDataAllCard()
	card.AllCards = {}
	for type,tables in pairs(CARD_DATA.CARDS) do
		for unit,tableUnit in pairs(tables) do
			card.AllCards[unit] = card:GetDataCard(unit)
			card.AllCards[unit].prototype_model = (GetKeyValueByHeroName(unit, 'PrototypeModel') or card:GetPrototypeModelUnit(unit)) 
			card.AllCards[unit].BaseStats =  {
					DamageMin = (GetKeyValueByHeroName(unit, 'AttackDamageMin') or 0),
					DamageMax = (GetKeyValueByHeroName(unit, 'AttackDamageMax') or 0),
					AttackRange = (GetKeyValueByHeroName(unit, 'AttackRange') or 100),
					AttackRate = (GetKeyValueByHeroName(unit, 'AttackRate') or 1),
					Ability = HeroAbility(unit),
					PrimaryStats = (GetKeyValueByHeroName(unit, 'AttributePrimary') or -1)
			}
			CustomNetTables:SetTableValue("CardInfoUnits", unit, card.AllCards[unit])
		end
	end
end 

function card:PlayerDataLoad()
	local dataAllPlayer = {}
	request.IsServerConnection = false
	PlayerResource:PlayerIterate(function(pID)

		NewPlayer(pID)
		dataAllPlayer[pID] = {
			SteamID = PlayerResource:GetRealSteamID(pID),
		}
	end)
	request:RequestData('GET','player',function(obj)
		request.IsServerConnection = true
		-- PrintTable(obj.PlayerData)
		for k,v in pairs(obj.PlayerData) do
			local pID = k - 1
			local __Player = GetPlayerCustom(pID)
			__Player.bIsTester = v.IsTester == '1' or v.IsDev == '1'
			__Player.bSub = v.IsDonate
			__Player.bIsDev = v.IsDev == '1'
			__Player.iCoins = v.Coins
			__Player.iExp = v.Exp
			__Player.tDailyQuests = v.DailyQuests
			__Player.tInventory = v.Inventory
			__Player.ExpAndOst = __Player:GetXpAndOst()
			__Player.tFriendLeaderboard = v.FriendList
			__Player.iAmountGame = v.CountGame
			-- print('count = ',v.CountGame)
			__Player:SetQuests(quest:GenerationAllQuest(pID))
			for keyData,data in pairs(v.Inventory or {}) do
				if data.selected  then 
					__Player.model = obj.DataShop[tonumber(keyData)+1].model
					break
				end
			end

			local runes = v['Runes']
			for key,value in pairs(runes) do 
				key = tonumber(key)
				__Player:SetRunes(key == 1 and 'physical_rune' or
					key == 2 and 'magical_rune' or 'life_rune',value)
			end
			__Player:UpdateClientData()
		end
		local globalData = CustomNetTables:GetTableValue("PlayerData", "GLOBAL_SETTING")
		globalData.SHOP_DATA = obj.DataShop
		globalData.LeaderboardGlobal = obj.DataGlobalLeader
		CustomNetTables:SetTableValue("PlayerData", "GLOBAL_SETTING",globalData)
		CustomGameEventManager:Send_ServerToAllClients('OnRequest', {})
	end,dataAllPlayer)
end

function card:GetDataCard(cardName)
	local data = CARD_DATA.CARDS
	for types,v in pairs(data) do
		if v[cardName] then
			local returnData = v[cardName]
			returnData.type = types
			return returnData
		end 
	end
end

function card:RefreshingCards(chances,pID,GoldCost)
	local mTable = GetPlayerCustom(pID)
	mTable:OnRefreshingCard(chances,GoldCost)
end

function card:OnDiscard(data)
	local pID = data.PlayerID
	local mTable = GetPlayerCustom(data.PlayerID)
	mTable:OnDiscardCard()
end

function card:GetRandomCards(chances,IsDonate)
	local dataAllDropCard = {}
	local chanceDropped = chances or {
		common = 45,
		uncommon = 50,
		rare = 25,
		mythical = 35,
		legendary = 25,
	}
	local max = 0
	local maxchanceBy = 'common'
	for k,v in pairs(chanceDropped) do
		if max < v then
			max = v
			maxchanceBy = k
		end
	end

	for i=1,CARD_DATA.CARD_RANDOM_DROP + (IsDonate and 1 or 0) do
		local typeCard = RollPercentage(chanceDropped.common)  and 'common' or
						RollPercentage(chanceDropped.uncommon) and 'uncommon' or
						RollPercentage(chanceDropped.rare)  and 'rare' or
						RollPercentage(chanceDropped.mythical)  and 'mythical' or
						RollPercentage(chanceDropped.legendary) and 'legendary'
		if not typeCard then
			typeCard = maxchanceBy
		end
		local tables = CARD_DATA.CARDS[typeCard]
		local countIterate = 0;
		-- for k,_ in pairs(tables) do
		-- 	countIterate = countIterate + 1
		-- 	if RollPercentage(100/table.length(tables)) then
		-- 		table.insert(dataAllDropCard,k)
		-- 		break
		-- 	end
		-- 	if table.length(tables) < countIterate + 1 then
		-- 		for k1,_1 in pairs(tables) do
		-- 				table.insert(dataAllDropCard,k1)
		-- 				break
		-- 		end
		-- 		break
		-- 	end
		-- end
		local tables2 = {}
		for k,v in pairs(tables) do
			table.insert(tables2,k)
		end
		local n = PickRandomValueTable(tables2)
		table.insert(dataAllDropCard,n)
	end
	return dataAllDropCard
end
function CDOTABaseAbility:GetSpecialValueFor_Custom(key,keyUpgrade,upgradeValueStr)
	local caster = self:GetCaster()
	local bonus = 0
	local upgradeValue = upgradeValueStr or 'value'
	if keyUpgrade and caster:GetOwner() then
		local isAssembly = caster:IsAssembly(keyUpgrade) --card:IsAssemblyCard(caster:GetUnitName(),keyUpgrade,caster:GetOwner():GetPlayerID())
		local dataCard = card:GetDataCard(caster:GetUnitName())
		bonus = isAssembly and 
		dataCard and 
		dataCard.Assemblies and 
		dataCard.Assemblies[keyUpgrade] and 
		dataCard.Assemblies[keyUpgrade].data and 
		dataCard.Assemblies[keyUpgrade].data[upgradeValue] or 0

	end
	return self:GetSpecialValueFor(key) + bonus
end

function card:GetSpecialValueFor_Upgrade(caster,upgrade)
	local dataCard = card:GetDataCard(caster:GetUnitName())
	return 	dataCard and 
		dataCard.Assemblies and 
		dataCard.Assemblies[upgrade] and 
		dataCard.Assemblies[upgrade].data
end
-- Is Combinate
function card:IsAssemblyCard(cardName,upgradeName,pID)
	local CardsCount = {}
	local result = false
	local dataUnit = card:GetDataCard(cardName)
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	if not dataUnit or not dataUnit.Assemblies or not dataUnit.Assemblies[upgradeName] then return false end
	BuildSystem:EachBuilding(pID, function(unit)
		local cardNameEach = unit.hUnit:GetUnitName()
		CardsCount[cardNameEach] = (CardsCount[cardNameEach] or 0) + 1
	end)
	
	local needCardByAssembly = string.split(dataUnit.Assemblies[upgradeName].assembliesNeed,' | ')
	for k,v in pairs(needCardByAssembly) do
		local AllIs = true 
		for _,name in pairs(string.split(v,"+ ")) do
			name = name:gsub(' ','')
			if not CardsCount[name] and not ( hero.assembliesSave and hero.assembliesSave[name] ) then
				AllIs = false
				break
			end
		end
		result = result or AllIs
	end
	return result
end



