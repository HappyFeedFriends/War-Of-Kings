var godnessUnits = {
    'npc_war_of_Kings_special_boss_warrior':true,
    'npc_war_of_Kings_special_boss_mage':true,
    'npc_war_of_Kings_special_boss_rogue':true,
    'npc_war_of_Kings_special_boss_shaman':true,
    'npc_war_of_Kings_special_boss_archer':true,
    'npc_war_of_Kings_special_boss_guardian':true,
}
var BarsContainer
var heroBars = {}
// $('#HeroBarsContainer').RemoveAndDeleteChildren()
function CreateBar(entity){
    var panel = $.CreatePanel('Panel',BarsContainer,'')
    panel.BLoadLayoutSnippet('HealthBar');
    heroBars[entity] = panel
    return panel
} 

function Clamp(num, min, max) {
  return num < min 
  ? min 
  : num > max
        ? max 
        : num;
}

function ShowTextWorld(panel,AssemblyName,unitName,entityId){
    return function(){
        if (IsTooltipOpen())
        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "AssemblyTooltip", "file://{resources}/layout/custom_game/tooltips/TooltipAssemblyWorld.xml", 
            'AssemblyName=' + AssemblyName +
            '&unitName=' + unitName +
            '&entityID=' + entityId)
    }
}

function HideAssemblyTooltip(panel){
    return function(){
        $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "AssemblyTooltip");
    }
}

function ArrayInsertAll(){
    var playerData = CustomNetTables.GetTableValue("PlayerData", "player_" + GetPlayerID())
    var t = Entities.GetAllEntitiesByClassname('npc_dota_creature')
    var t1 = playerData.BuildingsCardsindexID || {}
    var t2 = playerData.Champions || {}
    var dataReturn = []
    for (var entityId in t) 
        if (!dataReturn[Number(entityId)])
            dataReturn.push(Number(entityId))

    for (var entityId in t1) 
        if (!dataReturn[Number(entityId)])
            dataReturn.push(Number(entityId))

    for (var entityId in t2) 
        if (!dataReturn[Number(entityId)])
            dataReturn.push(Number(entityId))

    return dataReturn
}

var screenHR = Game.GetScreenHeight() / 1080;
var cardInfo = CustomNetTables.GetTableValue("BuildSystem", "card_building_info")

function FindKeyByValue(value,table){
    for (i in table){
        if (table[i] == value) return i
    }
    return false
}

function UpdateByUnit(){
    $.Schedule(1/60,UpdateByUnit) 
    var creatures = Entities.GetAllEntitiesByClassname('npc_dota_creature')
    var playerData = CustomNetTables.GetTableValue("PlayerData", "player_" + GetPlayerID())
    // playerData.champions = playerData.champions || {}
    var dataBuilding = playerData.BuildingsCardsindexID
    // for (var entityId in heroBars){
    //     entityId = Number(entityId)
    //     var find = FindKeyByValue(entityId,creatures)
    //     if (!find && heroBars[entityId]){
    //         heroBars[entityId].DeleteAsync(0);
    //         delete heroBars[entityId];  // delete health bars if the creeps were killed, but the client no longer knows the information about it           
    //     }
    // }
    for (var entityId of creatures) {
        if (Entities.IsOutOfGame(entityId) || !Entities.IsAlive(entityId)) {
            if (!Entities.IsAlive(entityId) && heroBars[entityId]){
                heroBars[entityId].DeleteAsync(0);
                delete heroBars[entityId];
            }
            continue;
        }
        var data = dataBuilding[entityId];
        var abs = Entities.GetAbsOrigin(entityId);
        var offset = Entities.GetHealthBarOffset(entityId) + 20;
        var screenX = Game.WorldToScreenX(abs[0], abs[1], abs[2] + offset);
        var screenY = Game.WorldToScreenY(abs[0], abs[1], abs[2] + offset);
        var isOnScreen = GameUI.GetScreenWorldPosition(screenX, screenY) != null;
        if (heroBars[entityId]){
            heroBars[entityId].style.visibility = isOnScreen ? 'visible' : 'collapse';
            if (!isOnScreen)
                continue
        }
        var x = screenX / screenHR;
        var y = screenY / screenHR;
        // var champions = playerData.Champions
        var shieldCount = 0;
        var healthAmount = Entities.GetHealth(entityId);
        var maxHealth = Entities.GetMaxHealth(entityId);
        var IsMidasCooldown = false
        var MidasModifierID = -1
        for (var i = 0; i < Entities.GetNumBuffs(entityId); i++) {
            var buff = Entities.GetBuff(entityId, i);
            var name = Buffs.GetName(entityId, buff);
           
            if (name == 'modifier_shield'){
                shieldCount = Buffs.GetStackCount( entityId, buff )
            }

            if (name == 'modifier_unique_aura_midas_buff_cooldown' && !IsMidasCooldown){
                IsMidasCooldown = true
                MidasModifierID = buff
            }
        }
        if (Entities.GetUnitName(entityId) == 'npc_war_of_kings_wave_boss_end'){
            var panel = heroBars[entityId];
            if (!panel){
                panel = $.CreatePanel('Panel',BarsContainer,'');
                panel.BLoadLayoutSnippet('HealthBarLastBoss');
                heroBars[entityId] = panel;
            }
            panel.style.position = (Math.floor(x) - 100) + "px " + (Math.floor(y) - 80) + "px" + ' 0';
            var health = panel.FindChildTraverse('LastBossPB')
            health.FindChild('Amount').style.width = Entities.GetHealthPercent(entityId) + "%"
            health.FindChild('Shield').style.width = (shieldCount == 0 ? 0 : shieldCount/maxHealth*100) + "%";

            var mana = panel.FindChildTraverse('LastBossMana')
            mana.FindChild('Amount').style.width = (Entities.GetMana(entityId)/Entities.GetMaxMana(entityId)*100)  + "%"
            continue;
        }
        if (godnessUnits[Entities.GetUnitName(entityId)]){
            var panel = heroBars[entityId];
            if (!panel){
                panel = $.CreatePanel('Panel',BarsContainer,'');
                panel.BLoadLayoutSnippet('HealthBarGodness');
                heroBars[entityId] = panel;
            }
            panel.FindChildTraverse('ProgressBarHealthWorld').max = maxHealth;
            panel.FindChildTraverse('ProgressBarHealthWorld').value = healthAmount;
            panel.style.position = (Math.floor(x) - 60) + "px " + (Math.floor(y) - 80) + "px" + ' 0';
            continue;
        }
        if ( Entities.GetUnitName(entityId) == 'npc_war_of_kings_special_chest' ){
            var panel = heroBars[entityId];
            if (!panel){
                panel = $.CreatePanel('Panel',BarsContainer,'');
                panel.BLoadLayoutSnippet('HealthBarChest');
                heroBars[entityId] = panel;
            }
            panel.FindChildTraverse('GoldNumber').text = FormatGold(maxHealth);
            panel.FindChildTraverse('DamageTaken').text = FormatGold(playerData.Chest.toFixed(0));
            panel.style.position = (Math.floor(x) - 60) + "px " + (Math.floor(y) - 80) + "px" + ' 0'; 
            continue;
        }
        if (!data || !cardInfo[Entities.GetUnitName(entityId)]) continue
        var IsPrototypeUnit = cardInfo[Entities.GetUnitName(entityId)].entindex == entityId;
        if ( IsPrototypeUnit ||  
            (!Entities.IsCreep(entityId) && !Entities.IsHero(entityId)) || 
            !cardInfo[Entities.GetUnitName(entityId)] ) continue 

        var panel = heroBars[entityId] // || CreateBar(entityId);
        var BuildingData = CustomNetTables.GetTableValue('CardInfoUnits', Entities.GetUnitName(entityId));
        if (!panel){
            panel = CreateBar(entityId)
            _.each(panel.FindChildTraverse('Stars').Children(),function(child){
                child.AddClass(BuildingData.class)
            })
        }
        panel.style.position = (Math.floor(x) - 60) + "px " + (Math.floor(y) - 80 - (IsMidasCooldown ? 60 : 0)) + "px" + ' 0';
        var health = panel.FindChildTraverse('ProgressBarHealthWorld');
        var shield = health.FindChild('Shield')
        var mana = panel.FindChildTraverse('ProgressBarManaWorld');
        var lvl = panel.FindChildTraverse('LevelUnit');
        var xp = panel.FindChildTraverse('CircularXPProgress');
        var UnitName = panel.FindChildTraverse('UnitName');
        var midas = panel.FindChildTraverse('MidasTowerBar')

        var stars = data.iMaxGrade;
        var starsCount = data.Grade;
        var count = 1;
        _.each(panel.FindChildTraverse('Stars').Children(),function(child){
            child.SetHasClass('Visible', count <= stars);
            child.SetHasClass('star' + count, count <= starsCount) ;
            count += count <= stars && 1 || 0;
        })

        midas.SetHasClass('Visible', IsMidasCooldown)
        if (IsMidasCooldown){
            var remainingTime = Buffs.GetRemainingTime( entityId, MidasModifierID )
            midas.FindChildTraverse('CooldownMidas').style.height = ((remainingTime / Buffs.GetDuration( entityId, MidasModifierID )) * 100) + '%'
            midas.FindChildTraverse('CooldownText').text = remainingTime.toFixed(1)
        }

        if (BuildingData.Assemblies){
            var container = panel.FindChildTraverse('IsUpgrades');

            for (i in BuildingData.Assemblies){
                if (BuildingData.Assemblies[i].AssemblyAbility){
                    var isfind = container.FindChildTraverse(i) != null;
                    var panel = container.FindChildTraverse(i) || $.CreatePanel('DOTAAbilityImage',container,i);
                    if (!isfind){
                        var dataAbility = BuildingData.Assemblies[i];
                        var ability = dataAbility.AssemblyAbility;
                        var localizeName = $.Localize(i);
                        if (dataAbility.data) 
                            for (var k in dataAbility.data){
                                localizeName = localizeName.replace('{' + k + '}',dataAbility.data[k].toFixed(Math.min(GetNumberOfDecimal(dataAbility.data[k]),1)));
                            }
                        localizeName = localizeName.replace('{ability}',$.Localize('Dota_tooltip_ability_' + ability).toUpperCase());
                        panel.abilityname = BuildingData.Assemblies[i].AssemblyAbility;
                        panel.SetPanelEvent('onmouseover',ShowTextWorld(panel,i,Entities.GetUnitName(entityId),entityId));
                        panel.SetPanelEvent('onmouseout',HideAssemblyTooltip(panel));
                    }
                } else {
                    var isfind = container.FindChildTraverse(i) != null;
                    var panel = container.FindChildTraverse(i) || $.CreatePanel('Image',container,i);
                    if (!isfind){
                        var dataAbility = BuildingData.Assemblies[i];
                        var localizeName = $.Localize(i);
                        if (dataAbility.data) 
                            for (var k in dataAbility.data){
                                localizeName = localizeName.replace('{' + k + '}',dataAbility.data[k].toFixed(Math.min(GetNumberOfDecimal(dataAbility.data[k]),1)));
                            }
                        panel.SetImage('file://{images}/heroes/' + BuildingData.prototype_model + '.png');
                        panel.SetPanelEvent('onmouseover',ShowTextWorld(panel,i,Entities.GetUnitName(entityId),entityId));
                        panel.SetPanelEvent('onmouseout',HideAssemblyTooltip(panel));
                    }
                }
                panel.SetHasClass('IsActivate', data.hIsAssemblies[i] == 1)
            }
        }
        health.max = maxHealth;
        health.value = healthAmount;
        shield.style.width = (shieldCount == 0 ? 0 : shieldCount/maxHealth*100) + "%";
        mana.max = Entities.GetMaxMana(entityId);
        mana.value = Entities.GetMana(entityId);

        lvl.text = data.Level
        
        xp.value = data.iXp
        xp.max = data.iMaxXp
        UnitName.text = $.Localize(Entities.GetUnitName(entityId))
    }
}
 

(function(){
    heroBars = {}  
    var dotaUI = GetDotaHud()
    BarsContainer = dotaUI.FindChildTraverse('HeroBarsContainerRoot')
    if (BarsContainer){
        BarsContainer.DeleteAsync(0) 
        BarsContainer = null 
    }
    if (!BarsContainer){
        BarsContainer = $.CreatePanel('Panel',dotaUI,'HeroBarsContainerRoot')
        BarsContainer.style.zIndex = "-100"
        BarsContainer.hittest = false
        BarsContainer.BLoadLayout("file://{resources}/layout/custom_game/HeroBarsContainer3.xml", false, false);
        BarsContainer.RemoveAndDeleteChildren()
    }   
    UpdateByUnit();
})();
