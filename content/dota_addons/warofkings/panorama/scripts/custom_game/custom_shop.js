"use strict";
var localization = {
	consumables:'DOTA_Shop_Category_0',
	attributes:'DOTA_Shop_Category_1',
	weapons_armor:'DOTA_SUBSHOP_WEAPONS_ARMOR',
	secretshop:'Dota_shop_category_custom',
}
var panels = [];
var playerid = GetPlayerID()
var tooltip = null;
var allItems = CustomNetTables.GetAllTableValues('CustomShop')
var oldGold = 0
var sort_allItems = []
   
function FillItems(){
	var data = CustomNetTables.GetTableValue('CustomShop', 'ShopList')
	var number = 0;
	for (var i in data) { 
		$('#Grid' + i).RemoveAndDeleteChildren()
		for (var shop_tag in data[i]){ 
			var parent = $.CreatePanel('Panel',$('#Grid' + i),'ShopItem_' + shop_tag)
			parent.BLoadLayoutSnippet('ShopItemsLayout')
			parent.SetHasClass('LeftRow', number % 2 == 0)
			parent.SetDialogVariable('shop_row_title', $.Localize(localization[shop_tag] || shop_tag))
			var parent = parent.FindChildTraverse('ShopItemsContainer')
			number++
			for (var itemName in data[i][shop_tag]){
				var itemName = data[i][shop_tag][itemName]
				if (!CustomNetTables.GetTableValue('CustomShop', itemName)) continue;
				var panel = $.CreatePanel('Panel',parent,'')
				SnippetCreate_SmallItem(panel,itemName) 
				panels.push(panel);

			}
		}
	}  
}
   
function UpdateShopItems(){
	var gold = GetGold()
	_.each(panels,function(panel){
		var cost = CustomNetTables.GetTableValue('CustomShop', panel.itemName).cost
		panel.SetHasClass('CanPurchase', gold > cost)
	})

	_.each($("#ItemsContainer").Children(),function(child){
		_.each(child.Children(),function(children){
			var cost = CustomNetTables.GetTableValue('CustomShop', children.itemName).cost
			children.SetHasClass('CanPurchase', gold > cost)			
		})
	})
}

function TogglePageInventory(id){
	var arr = ['GridBasicItemsCategory','GridUpgradesCategory','GridUniqueCategory']
	_.each(arr,function(name){
		$('#' + name).SetHasClass('Visible', name == id)
	})
}
  
function ItemShowTooltip(panel) {
	tooltip = tooltip || GetDotaHud().FindChildTraverse('Tooltips').FindChildTraverse('DOTAAbilityTooltip')
	if (!tooltip)
		$.DispatchEvent('DOTAShowAbilityTooltipForEntityIndex', panel, panel.itemName, Players.GetLocalPlayerPortraitUnit());
	tooltip = tooltip || GetDotaHud().FindChildTraverse('Tooltips').FindChildTraverse('DOTAAbilityTooltip')
	var deficit = tooltip.FindChildTraverse('BuyCostDeficit')
	var itemInfo = CustomNetTables.GetTableValue('CustomShop', panel.itemName.toLowerCase())
	var gold = GetGold();
	if (itemInfo && itemInfo.cost){
		tooltip.SetHasClass('NotEnoughGold',itemInfo.cost > gold )
		deficit.text = "(" + (gold - itemInfo.cost) +")"
	}
	$.DispatchEvent('DOTAShowAbilityTooltipForEntityIndex', panel, panel.itemName, Players.GetLocalPlayerPortraitUnit());
}

function ItemHideTooltip(panel) {
	$.DispatchEvent('DOTAHideAbilityTooltip', panel);
	var deficit = tooltip.FindChildTraverse('BuyCostDeficit')
	tooltip.RemoveClass('NotEnoughGold')
	deficit.text = "( 0 )";
}

function SendItemBuyOrder(itemName) {
	var playerId = Game.GetLocalPlayerID();
	var unit = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsControllableByPlayer(unit, playerId))
		GameEvents.SendCustomGameEventToServer('custom_shop_buy_item', {
			itemName: itemName,
			unit: unit,
		});
}

function SnippetCreate_SmallItem(panel,itemName,noneSetEvent){
	panel.BLoadLayoutSnippet('SmallItem');
	panel.itemName = itemName
	panel.FindChildTraverse('SmallItemImage').itemname = itemName
	panel.SetPanelEvent('onmouseover', function() {
		ItemShowTooltip(panel);
	});
	panel.SetPanelEvent('onmouseout', function() {
		ItemHideTooltip(panel);
	});
	panel.OnContextClick = function() {
		if (panel.BHasClass('CanPurchase')) {
			SendItemBuyOrder(itemName);
		} else {
			GameEvents.SendEventClientSide('dota_hud_error_message', {
				'splitscreenplayer': 0,
				'reason': 80,
				'message': '#dota_hud_error_not_enough_gold'
			});
			Game.EmitSound('General.NoGold');
		}
	}
	panel.OnActivate = function() {
		var parentRecipe = $('#ItemCombines').FindChildTraverse('ItemsContainer')
		var gold = GetGold();
		var childrens = parentRecipe.Children()
		_.each(childrens,function(child){
			child.RemoveAndDeleteChildren()
		})
		var itemInfo = CustomNetTables.GetTableValue('CustomShop', itemName).RecipeData
		var recipe_to = itemInfo.itemUsed
		var recipe_from = itemInfo.items
		for (var i in recipe_to){	
			var panelSmall = $.CreatePanel('Panel',childrens[0],'')
			SnippetCreate_SmallItem(panelSmall,i)		
		}
		for (var i in recipe_from || {}){	
			var panelSmall = $.CreatePanel('Panel',childrens[2],'')
			panelSmall.IsRecipe = true
			SnippetCreate_SmallItem(panelSmall,recipe_from[i])		
		}
		// var connectors = $('#ConnectorsContainer')	
		// connectors.RemoveAndDeleteChildren()
		var panelSmall = $.CreatePanel('Panel',childrens[1],'')
		SnippetCreate_SmallItem(panelSmall,itemName)
		childrens[1].AddClass('Visible')
		var cost = CustomNetTables.GetTableValue('CustomShop', panelSmall.itemName).cost
		panelSmall.SetHasClass('CanPurchase', gold > cost)
		panelSmall.FindChildTraverse('OwnedTick').SetHasClass('Visible',Entities.HasItemInInventory( Players.GetLocalPlayerPortraitUnit(), itemName ))
		var SortRecipe = function(data,parent){
			parent.RemoveClass('Visible')
			var length = LengthTable(data)
			if (length < 1){
				return 
			}
			parent.AddClass('Visible')
			var widthContainer = 400
			var sumWidth = length * 40
			widthContainer -= sumWidth
			widthContainer /= (length)
			var widthNew = 0
			_.each(parent.Children(),function(childs){
				childs.style.marginLeft = (widthNew) + "px";
				widthNew = widthContainer
				var cost = CustomNetTables.GetTableValue('CustomShop', childs.itemName).cost
				childs.SetHasClass('CanPurchase', gold > cost)	
			})	

		}
		SortRecipe(recipe_to,childrens[0])
		SortRecipe(recipe_from,childrens[2])
	}
	if (!noneSetEvent){
		panel.SetPanelEvent('oncontextmenu', panel.OnContextClick);
		panel.SetPanelEvent('onactivate',panel.OnActivate);		
	}
}
function PanelSearchSetEvent(panel,panelLoad){
	panel.SetPanelEvent('onactivate',function(){
		panelLoad.OnActivate()
		_.each(panel.GetParent().Children(),function(child){
			child.SetHasClass('focus', child == panel)
		})
	});
}
function OnInputSearchShop(){
	var count = 0;
	var parent = $("#SearchResultDotaShop").FindChildTraverse('SearchResultsContents')
	var text = $("#SearchTextEntryShop").text.toLowerCase()
	parent.RemoveAndDeleteChildren()
	for (var _i in sort_allItems){
		var d = sort_allItems[_i]
		var __i = d.index
		var key = d.name.toLowerCase()
		var value = allItems[__i].value
		if (key == 'shoplist') continue;
		if (12 < count) break
		var IsSearch = false;
		for (var i in value.names) IsSearch = IsSearch || value.names[i].toLowerCase() == text
		if (IsSearch || ($.Localize('Dota_tooltip_ability_' + key).toLowerCase().match(text) && !key.match('recipe') && value.IsPurchasable == "1")){
			var data = CustomNetTables.GetTableValue('CustomShop',key)
			var panel_search = $.CreatePanel('Button',parent,'')
			panel_search.BLoadLayoutSnippet('SearchResult')
			var panelLoad = panel_search.FindChildTraverse('ShopItemContainer')
			SnippetCreate_SmallItem(panelLoad,key,true) 
			panel_search.SetDialogVariable('item_name', $.Localize('Dota_tooltip_ability_' + key))
			panel_search.SetDialogVariable('item_cost', data.cost)
			count++;
			panel_search.SetPanelEvent('oncontextmenu', panelLoad.OnContextClick);
			// panel_search.SetPanelEvent('onactivate',panelLoad.OnActivate);
			PanelSearchSetEvent(panel_search,panelLoad)
		}		
	}
	$('#SearchResultDotaShop').SetHasClass('Visible', text.length > 0)
}

function ShopAutoUpdate(){
	$.Schedule(1/30,ShopAutoUpdate)
	var gold = GetGold();
	if (oldGold != gold){
		oldGold = gold
		UpdateShopItems();
	} 
}

function OpenCloseShop(){
	$('#shop').ToggleClass('Visible')
	var isVisible = $('#shop').BHasClass('Visible')
	var children = GetDotaHud().FindChildTraverse('shop_launcher_block').FindChildTraverse('stash')
	_.each(children.Children(),function(child){
		child.visible = isVisible
	})
}

(function(){
	GetDotaHud().FindChildTraverse('ShopButton').SetPanelEvent('onactivate', function(){
		OpenCloseShop()
	}) 

	for (var i in allItems){
		var data = allItems[i]
		sort_allItems.push({
			name:data.key,
			index: i,
		})
	}
	sort_allItems.sort(function(a,b){
		a = a.name; b = b.name;
		return a > b ? 1 : a < b ? -1 : 0
	})
	FillItems();
	ShopAutoUpdate();
	RegisterKeyBind('ShopToggle', OpenCloseShop); 
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false );
	GetDotaHud().FindChildTraverse('shop').visible = false;
})();