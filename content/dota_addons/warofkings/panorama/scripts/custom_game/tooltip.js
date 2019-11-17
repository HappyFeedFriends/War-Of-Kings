function OnLoadCardTooltip(){
	var CardName = $.GetContextPanel().GetAttributeString("CardName", "-1")
	var data = CustomNetTables.GetTableValue("CardInfoUnits", CardName);
	var rarity = data.type
	var classUnit = data.class
	if (classUnit.match('|')){
		var array = classUnit.split(' | ')
		classUnit = '';
		for (i in array)
			classUnit += $.Localize(array[i]) + ' ';
	}else{
		classUnit = $.Localize(classUnit)
	}
	var racial = data.racial
	var lvl = 2;
	var maxMana = data.BaseStats.Mana
	var maxHealth = data.BaseStats.Health
	var magicResistance = data.BaseStats.Magic_resistance
	var range = data.BaseStats.AttackRange
	var armor = data.BaseStats.Armor
	var damage_max = data.BaseStats.DamageMax
	var damage_min = data.BaseStats.DamageMin
	var panelUnitIcon = $('#BorderAnim')
	panelUnitIcon.RemoveClass('rare')
	panelUnitIcon.RemoveClass('legendary')
	panelUnitIcon.RemoveClass('mythical')
	panelUnitIcon.AddClass(rarity)
	$('#Tooltip').SetDialogVariable('rarity', $.Localize(rarity))
	$('#Tooltip').SetDialogVariable('CardName', $.Localize(CardName))
	$('#Tooltip').SetDialogVariable('classUnit', classUnit)
	$('#Tooltip').SetDialogVariable('racial', $.Localize(racial))

	$('#Tooltip').SetDialogVariable('damage_min', damage_min)
	$('#Tooltip').SetDialogVariable('damage_max', damage_max)
	$('#Tooltip').SetDialogVariable('attack_range', range)
	$('#Tooltip').SetDialogVariable('armor', armor)
	$('#Tooltip').SetDialogVariable('magic_resistance', magicResistance)
	$('#Tooltip').SetDialogVariable('max_health', maxHealth)
	$('#Tooltip').SetDialogVariable('max_mana', maxMana)
	var CardImage = 'file://{images}/war_of_kings/cards/{CardName}.png'.replace('{CardName}',CardName)
	if (data.prototype_model){
		CardImage = 'file://{images}/heroes/{heroName}.png'.replace('{heroName}',data.prototype_model);
	}
	$('#UnitIcon').SetImage(CardImage)
	$('#Tooltip').FindChildTraverse('TierCard').SetHasClass('Visible', lvl > 0)
	if (lvl > 0){
		var parent = $('#Tooltip').FindChildTraverse('TierCard')
		var count = 0;
		_.each(parent.Children(),function(child){
			if (child.BHasClass('star'))
			child.SetHasClass('Visible',count <= lvl)
			count = count + (count <= lvl ? 1 : 0)
		})
	}
}

function OnLoadDifficuiltTooltip(){
	var data = CustomNetTables.GetTableValue('PlayerData', 'GLOBAL_SETTING').ROUND_DIFFICUILT_DATA
	var number = $.GetContextPanel().GetAttributeString("name", "-1")
	var dataNumbers = {
		'simple':1,
		'normal':2,
		'hard':3,
		'Impossible':4,
		'hell':5,
		'sandbox':6,
	}
	$.GetContextPanel().SetDialogVariable('description', $.Localize("Difficuilt_tooltip_" + number + "_description"))
	number = dataNumbers[number]
	data = data[String(number)]
	$('#GlobalRanking').FindChildTraverse('iconCrossTick').SetHasClass('cross', data.globalRanking == 0)
	$('#EndlessMode').FindChildTraverse('iconCrossTick').SetHasClass('cross', data.endlessMode == 0)
	// $('#DroppedRarity').FindChildTraverse('iconCrossTick').SetHasClass('cross', data.Drop == undefined)
	// $('#DropItems').RemoveAndDeleteChildren()
	// if (data.Drop){
	// 	for (itemdef in data.Drop){
	// 	var xml = '<EconItemImage itemdef="{itemdef}" />'.replace('{itemdef}',itemdef)
	// 	$('#DropItems').BCreateChildren(xml);
	// 	}
	// }
}

function OnLoadTooltipEndTower(){
	var PlayerID = $.GetContextPanel().GetAttributeString("PlayerID", "-1")
	var data = CustomNetTables.GetTableValue('PlayerData', 'Player_' + PlayerID).DataEndGame.CardsData
	var index = $.GetContextPanel().GetAttributeString("index", "-1")
	if (data[index]){
		data = data[index];
		$.GetContextPanel().SetDialogVariable('level', data.Level);
		$.GetContextPanel().SetDialogVariable('total_damage', data.fTotalDamage);
		var bar = $.GetContextPanel().FindChildTraverse('CircularXPProgress');
		bar.value = data.iXp;
		bar.max = data.iMaxXp;
        var stars = data.iMaxGrade;
        var starsCount = data.Grade;
        var count = 1;
        _.each($('#TooltipStars').Children(),function(child){
        	if (child.paneltype != 'Panel') return;
            child.SetHasClass('Visible', count <= stars);
            child.SetHasClass('star' + count, count <= starsCount);
            count += count <= stars && 1 || 0;
        })
        var indexItem = -1
        _.each($('#InventoryTower').Children(),function(child){
        	child.RemoveAndDeleteChildren();
        	indexItem++;
        	if (!data.items[indexItem]) return;
        	var item = data.items[indexItem];
        	var panel = $.CreatePanel('DOTAItemImage',child,'')
        	panel.itemname = item;
        	panel.SetScaling('stretch-to-fit-x-preserve-aspect')

        })
	}
}


function OnLoadTooltipAssembly(){
	var AssemblyName = $.GetContextPanel().GetAttributeString("AssemblyName", "-1") //'sniper_upgrade_2'
	var unitName = $.GetContextPanel().GetAttributeString("unitName", "-1")//'npc_war_of_kings_sniper'
	var entityID = $.GetContextPanel().GetAttributeString("entityID", "-1")
    var playerData = CustomNetTables.GetTableValue("PlayerData", "player_" + GetPlayerID())
    var dataCard = playerData.BuildingsCardsindexID[entityID];
	var AssemblyContentTooltip = $('#AssemblyContentTooltip')
	AssemblyContentTooltip.RemoveAndDeleteChildren()
	var dataUnit = CustomNetTables.GetTableValue("CardInfoUnits", unitName)
	var data = dataUnit.Assemblies[AssemblyName];
	var units =   data.assembliesNeed.split(' | ');
	var abilityAssembly = data.AssemblyAbility;
	var childpanel = $.CreatePanel('Panel',AssemblyContentTooltip,'');
	var localizeName = $.Localize(AssemblyName)
	var IsAssembly = dataCard.hIsAssemblies[AssemblyName] == 1
	localizeName = localizeName.replace(/{ability}/g,$.Localize('Dota_tooltip_ability_' + abilityAssembly).toUpperCase())
	if (data.data) 
	 	for (var q in data.data)
			localizeName = localizeName.replace('{' + q + '}',data.data[q].toFixed(Math.min(GetNumberOfDecimal(data.data[q]),1)))
	$("#AssemblyTooltipLabel").text = localizeName
	childpanel.BLoadLayoutSnippet('RowDescription'); 
	$('#IsAssemblies').SetHasClass('cross', !IsAssembly)
	$('#IsAssemblies').SetHasClass('passed', IsAssembly)
	if (!abilityAssembly){
		if (childpanel.FindChildTraverse('AbilityName'))
		childpanel.FindChildTraverse('AbilityName').DeleteAsync(0)
		if (childpanel.FindChildTraverse('AbilityImage'))
		childpanel.FindChildTraverse('AbilityImage').DeleteAsync(0)
		var parentDescription = $.CreatePanel('Panel',childpanel.FindChildTraverse('DescriptionLabels'),'')
		$.CreatePanel('Panel',parentDescription,'').AddClass('Dot')
		var labelDescription = $.CreatePanel('Label',parentDescription,'')
		labelDescription.text = 'PASSIVE EFFECT';
		AssemblyContentTooltip.style.marginTop = 0  
		parentDescription.style.flowChildren = "right"
	}else{
		childpanel.FindChildTraverse('AbilityName').text = $.Localize('Dota_tooltip_ability_' + abilityAssembly);
		var abilityimage = childpanel.FindChildTraverse('AbilityImage')
		abilityimage.abilityname = abilityAssembly; 
	}
	var descriptionpanel = childpanel.FindChildTraverse('DescriptionLabels')
	for (var unitNames in units){
		var labelDescription = $.CreatePanel('Panel',descriptionpanel,'')
		labelDescription.AddClass('LabelDescription')
		var split = units[unitNames].split(' + ')
		var length = LengthTable(split) 
		var start = 1
		var proto = dataUnit.prototype_model;
		var image = $.CreatePanel('Image',labelDescription,'')
		image.AddClass('HeroImageDescription')
		image.SetImage('file://{images}/heroes/{name}.png'.replace('{name}',proto))
		$.CreatePanel('Label',labelDescription,'plusDescription').text = '+'
		for (var names in split){ 
			var proto = CustomNetTables.GetTableValue("CardInfoUnits", split[names]).prototype_model;
			var image = $.CreatePanel('Image',labelDescription,'')
			image.AddClass('HeroImageDescription')
			image.SetImage('file://{images}/heroes/{name}.png'.replace('{name}',proto))
			if (start < length)
				$.CreatePanel('Label',labelDescription,'plusDescription').text = '+'
			start++
		}
	}
}