if not CustomShop then
	CustomShop = class({})
end
ModuleRequire(...,'data')
function CustomShop:Preload()
	CustomGameEventManager:RegisterListener("OnBuyGodness", Dynamic_Wrap(CustomShop, 'OnBuyCustomItem'))
end
-- crystal buy
function CustomShop:OnBuyCustomItem(data)
	local crystal = data.Crystal
	local CardName = data.CardName
	local PlayerID = data.PlayerID
	local __Player = GetPlayerCustom(PlayerID)
	if __Player:GetCrystal() >= crystal then
		--card:ModifyCrystalPlayer(PlayerID,-crystal)
		__Player:ModifyCrystal(-crystal)
		local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)
		hero:AddItemByName(CardName)
	end
end

function CustomShop:ItemRecipe(itemName)
	local itemKv = KeyValues.ItemKV
	local recipeItem  = itemName:gsub('item_','item_recipe_')
	if not itemKv[recipeItem] then 
		return {
			RecipeVisible = false,
			cost = itemKv[itemName].ItemCost,
			-- MainItemRecipe = itemName,
			itemUsed = {},
			-- ItemStock = {
			-- 	max = -1,
			-- 	value = -1,
			-- 	start_value = -1,
			-- 	cooldown = -1,
			-- },
		}
	end
	local data = {
		RecipeVisible = itemKv[recipeItem].ItemCost > 0,
		-- MainItemRecipe = itemName,
		RecipeCost = itemKv[recipeItem].ItemCost,
		items = {},
		itemUsed = {},
	}
	for k,v in pairs(itemKv[recipeItem].ItemRequirements) do
		data.items = {}
		local items = string.split(v,';')
		for _k,_v in pairs(items) do
			if itemKv[_v] ~= "REMOVE" then
				data.items[_k] = _v:lower()
			end
		end
	end
	if data.RecipeVisible then 
		table.insert(data.items,recipeItem:lower())
	end

	return data
end

function CDOTA_BaseNPC:GetEmptySlots(item)
	local amount = 0
	for i=0, self:IsCreature() and DOTA_ITEM_SLOT_9 + 1 or DOTA_STASH_SLOT_6 do
		local current_item = self:GetItemInSlot(i)
		if not current_item or (current_item:GetAbilityName() == item and current_item:IsStackable()) then
			amount = amount + 1
		end
	end
	return amount
end

function CustomShop:BuyItem(playerID,itemName,ent,itemsHasInventory,time)
	local __Player = GetPlayerCustom(playerID)
	local gold = __Player:GetGold()
	local itemData = CustomShop.data[itemName]
	if not itemData then 
		print('[Buy Item] itemData = nil ItemName = ' .. itemName)
		return
	end
	if itemsHasInventory[itemName] and itemsHasInventory[itemName].amount > 1  then
		if itemsHasInventory[itemName].IsStash and ent:FindItemInInventory(itemName) and ent:FindItemInInventory(itemName):IsCombinable() then
			itemsHasInventory[itemName].item:RemoveSelf()
		end
		return
	end
	if #(itemData.RecipeData.items or {}) < 1 and gold >= itemData.cost and ent:GetEmptySlots(itemName) > 0 then
		ent:AddItemByName(itemName)
		__Player:ModifyGold(-itemData.cost)
		return
	end
	local recipe = {} -- fixed ptr lua (copy data)
	for k,v in pairs(itemData.RecipeData.items or {}) do
		recipe[k] = v 
	end
	for k,v in pairs(recipe) do
		local item = ent:FindItemInInventory(v)
		if item and item:IsCombinable() and itemsHasInventory[v] and itemsHasInventory[v].amount > 0 then 
			recipe[k] = nil
			itemsHasInventory[v].amount = itemsHasInventory[v].amount - 1
		end
	end
	for i,v in pairs(recipe) do
		Timers:CreateTimer(time + 0.03*i,function()
			CustomShop:BuyItem(playerID,v,ent,itemsHasInventory,time + 0.03 * i)
		end)
	end

end

function CustomShop:GetAllItemsByNameInInventory(unit, bBackpack,itemBuy)
	local items = {}
	local length = 0
	for slot = 0, bBackpack and DOTA_STASH_SLOT_6 or DOTA_ITEM_SLOT_9 do
		local item = unit:GetItemInSlot(slot)
		if item  and item:IsCombinable() then
			local name = item:GetName()
			items[item:GetName()] = {
				item = item,
				IsStash = slot > DOTA_ITEM_SLOT_9,
				amount = (items[name]  and items[name].amount or 0) + 1,
			}
			if (item:IsStackable() and itemBuy ~= item:GetName()) then
				length = length + 1
			end
		end
	end
	return items,length
end



function CustomShop:OnBuyItem(data)
	if data and data.itemName and data.unit then
		local ent = EntIndexToHScript(data.unit)
		if CustomShop.data[data.itemName] and ent and ent.entindex and ent:GetPlayerOwner() == PlayerResource:GetPlayer(data.PlayerID) then
			local __Player = GetPlayerCustom(data.PlayerID)
			local hero = __Player:GetSelectedHeroEntity()
			if GameRules:IsGamePaused() then
				DisplayError(data.PlayerID, "#dota_hud_error_game_is_paused")
				return
			end	
			if __Player:GetGold() < CustomShop.data[data.itemName].cost then 
				DisplayError(data.PlayerID,'#dota_hud_error_not_enough_gold')
				return
			end
			local itemsHasInventory,length = CustomShop:GetAllItemsByNameInInventory(ent,true,data.itemName)
			if length >= 9 then
				DisplayError(data.PlayerID, "#dota_hud_error_max_items")
				return
			end	
			if ent:IsIllusion() or ent:IsTempestDouble() or not ent:HasInventory() then
				ent = hero
			end
			if not ent:HasInventory() then 
				DisplayError(data.PlayerID, "#dota_hud_error_not_has_inventory")
				return 
			end
			local IsItemUniqueClass = hero == ent
			if not IsItemUniqueClass and ent.GetBuilding then 
				IsItemUniqueClass = CustomShop:IsAccesitemByUnit(data.PlayerID,data.itemName,ent)
				-- local IsGodnessItem  = false
				-- for k,v in pairs(SHOP_ITEMS['UniqueItems']) do
				-- 	for _,_v in pairs(v) do
				-- 		if _v:lower() == data.itemName:lower() then 
				-- 			IsGodnessItem = true
				-- 			break
				-- 		end
				-- 	end		
				-- 	if IsGodnessItem then break end
				-- end
				-- if IsGodnessItem then 
				-- 	local __k = 'tag_' .. ent:GetBuilding():GetClass()
				-- 	for k,v in pairs(SHOP_ITEMS['UniqueItems'][__k] or {}) do
				-- 		if v:lower() == data.itemName:lower() then 
				-- 			IsItemUniqueClass = true
				-- 			break
				-- 		end				
				-- 	end
				-- else
				-- 	IsItemUniqueClass = not IsGodnessItem
				-- end		
				if not IsItemUniqueClass then 
					DisplayError(data.PlayerID, "#dota_hud_error_item_not_available")
					return 
				end
			end
			itemsHasInventory[data.itemName] = nil
			CustomShop:BuyItem(data.PlayerID,data.itemName,ent,itemsHasInventory,0)
		end
	end
end

function CustomShop:IsAccesitemByUnit(playerID,itemName,ent)
	itemName = itemName:gsub('item_recipe_','item_'):lower()
	local hero = GetPlayerCustom(playerID):GetSelectedHeroEntity()
	local IsItemUniqueClass = hero == ent
	local IsGodnessItem = false
	for k,v in pairs(SHOP_ITEMS['UniqueItems']) do
		for _,_v in pairs(v) do
			if _v:lower() == itemName then 
				IsGodnessItem = true
				break
			end
		end		
		if IsGodnessItem then break end
	end
	if IsGodnessItem and ent.GetBuilding then 
		local __k = 'tag_' .. ent:GetBuilding():GetClass()
		for k,v in pairs(SHOP_ITEMS['UniqueItems'][__k] or {}) do
			if v:lower() == itemName then 
				IsItemUniqueClass = true
				break
			end				
		end
	else
		IsItemUniqueClass = not IsGodnessItem
	end	
	return IsItemUniqueClass	
end

function CustomShop:_ItemParsing()
	CustomShop.data = {}
	local itemKv = KeyValues.ItemKV
	for ItemName,dataItem in pairs(itemKv) do
		if type(dataItem) == "table" and not string.match(ItemName,'_class')  then
			CustomShop.data[ItemName] = {
				cost = GetTrueItemCost(ItemName),
				RecipeData = CustomShop:ItemRecipe(ItemName),
				names = {ItemName:lower()},
				IsPurchasable = dataItem.IsObsolete ~= 1 and dataItem.ItemPurchasable ~= 0
			}
			local ItemAliases = dataItem.ItemAliases and string.split(dataItem.ItemAliases, ";") or {}
			for k,v in pairs(ItemAliases) do
				if not table.includes(CustomShop.data[ItemName].names, v:lower())  then
					table.insert(CustomShop.data[ItemName].names, v:lower())
				end
			end
		end
	end
	for ItemName,_ in pairs(CustomShop.data) do
		CustomShop.data[ItemName].RecipeData.itemUsed = CustomShop:GetUsedRecipeItem(ItemName)
		CustomNetTables:SetTableValue('CustomShop', ItemName:lower(), CustomShop.data[ItemName])
	end

	CustomNetTables:SetTableValue('CustomShop', 'ShopList', SHOP_ITEMS)
	return CustomShop.data
end

function CustomShop:GetUsedRecipeItem(itemName)
	local data = {}
	local itemKv = CustomShop.data
	for ItemName,dataItem in pairs(itemKv) do
		if dataItem.RecipeData.items then
			for _,v in pairs(dataItem.RecipeData.items) do
				if v == itemName then
					data[ItemName] = 1
					break
				end
			end
		end
	end
	return data
end

function CustomShop:SellItem(playerId, unit, item)
	local itemname = item:GetAbilityName()
	local cost = item:GetCost()
	if unit:IsIllusion() or
		unit:IsTempestDouble() or
		unit:IsStunned() then
		return
	end
	if GameRules:IsGamePaused() then
		Containers:DisplayError(playerId, "#dota_hud_error_game_is_paused")
		return
	end
	if not item:IsSellable() then
		Containers:DisplayError(playerId, "dota_hud_error_cant_sell_item")
		return
	end
	if item:IsStackable() then
		local chargesRate = item:GetCurrentCharges() / item:GetInitialCharges()
		cost = cost * chargesRate
	end
	if GameRules:GetGameTime() - item:GetPurchaseTime() > 10 then
		cost = cost / 2
	end
	GetPlayerCustom(playerId):ModifyGold(cost)
end

-- PrintTable(CustomShop)

