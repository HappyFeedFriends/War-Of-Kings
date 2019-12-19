//=========================
//  Author: Samsara
//=========================
var state = 'disabled';
var size = 0;
var overlay_size = 0;
var grid_alpha = 30;
var overlay_alpha = 90;
var model_alpha = 100;
var recolor_ghost = false;
var rangeParticle;
var modelParticle;
var gridParticles;
var overlayParticles;
var builderIndex;
var iconPanel = $.GetContextPanel().FindChildTraverse('IconPanel') ||  $.CreatePanel('Image',$.GetContextPanel(),'IconPanel')
iconPanel.style.width = '40px';
iconPanel.style.height = '40px';
iconPanel.hittest =false
iconPanel.style.zIndex = '2000000';
iconPanel.SetScaling('stretch-to-cover-preserve-aspect')
iconPanel.style.borderRadius = "50%";

var blockers = [];
var screenHR = Game.GetScreenHeight() / 1080;
function StartBuildingHelper( params )
{
    if (params !== undefined)
    {
        // Set the parameters passed by AddBuilding
        state = params.state;
        size = 3;
        overlay_size = size * 3;
        grid_alpha = 25;
        model_alpha = 75;
        recolor_ghost = Number(params.recolor_ghost);
        builderIndex = params.builderIndex;
        var scale = params.scale;
        var entindex = params.entindex;
        var attack_range = params.attack_range

        // If we chose to not recolor the ghost model, set it white
        var ghost_color = [0, 255, 0]
        if (!recolor_ghost)
            ghost_color = [255,255,255]
        var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );

        // if (modelParticle !== undefined) {
        //     Particles.DestroyParticleEffect(modelParticle, true)
        // }
        if (gridParticles !== undefined) {
            for (var i in gridParticles) {
                Particles.DestroyParticleEffect(gridParticles[i], true)
            }
        }

        // Range
        rangeParticle = Particles.CreateParticle("particles/ui_mouseactions/range_display.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, -1);
        Particles.SetParticleControl(rangeParticle, 1, [attack_range, attack_range, attack_range]);

        // Building Ghost
        // modelParticle = Particles.CreateParticle("particles/buildinghelper/ghost_model.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN, localHeroIndex);
        // Particles.SetParticleControlEnt(modelParticle, 1, entindex, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, "", Entities.GetAbsOrigin(entindex), true)
        // Particles.SetParticleControl(modelParticle, 2, ghost_color)
        // Particles.SetParticleControl(modelParticle, 3, [model_alpha,0,0])
        // Particles.SetParticleControl(modelParticle, 4, [scale,0,0])
        // Grid squares
        let dataUnit = CustomNetTables.GetTableValue('CardInfoUnits',params.cardName)
        iconPanel.SetImage(`s2r://panorama/images/heroes/${dataUnit.prototype_model}.png`)
        gridParticles = [];
        for (var x=0; x < size*size; x++)
        {
            var particle = Particles.CreateParticle("particles/buildinghelper/square_sprite.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, 0)
            Particles.SetParticleControl(particle, 1, [32,0,0])
            Particles.SetParticleControl(particle, 3, [grid_alpha,0,0])
            gridParticles.push(particle)
        }

        overlayParticles = [];
        for (var y=0; y < overlay_size*overlay_size; y++)
        {
            var particle = Particles.CreateParticle("particles/buildinghelper/square_overlay.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, 0)
            Particles.SetParticleControl(particle, 1, [32,0,0])
            Particles.SetParticleControl(particle, 3, [0,0,0])
            overlayParticles.push(particle)
        }
    }

    if (state == 'active')
    {
        $.Schedule(0, StartBuildingHelper);

        var mPos = GameUI.GetCursorPosition();

        var GamePos = GameUI.GetScreenWorldPosition(mPos);

        if ( GamePos !== null )
        {
            SnapToGrid(GamePos, size)

            var invalid = false;
            var color = [0,255,0]
            var part = 0
            var halfSide = (size/2)*64
            var boundingRect = {}
            boundingRect["leftBorderX"] = GamePos[0]-halfSide
            boundingRect["rightBorderX"] = GamePos[0]+halfSide
            boundingRect["topBorderY"] = GamePos[1]+halfSide
            boundingRect["bottomBorderY"] = GamePos[1]-halfSide

            if (GamePos[0] > 10000000) return

            // Building Base Grid

            for (var x=boundingRect["leftBorderX"]+32; x <= boundingRect["rightBorderX"]-32; x+=64)
            {
                for (var y=boundingRect["topBorderY"]-32; y >= boundingRect["bottomBorderY"]+32; y-=64)
                {
                    var pos = [x,y,GamePos[2]]
                    if (part>size*size)
                        return

                    var gridParticle = gridParticles[part]
                    Particles.SetParticleControl(gridParticle, 0, pos)
                    part++;

                    // Grid color turns red when over invalid positions
                    // Until we get a good way perform clientside FindUnitsInRadius & Gridnav Check, the prevention will stay serverside
                    color = [0,255,0]
                    for (var index = 0; index < blockers.length; index++) {
                        if (IsPointInPolygon(pos, blockers[index]))
                        {
                            color = [255,0,0]
                            invalid = true //Mark invalid for the ghost recolor
                            break;
                        }
                    }

                    Particles.SetParticleControl(gridParticle, 2, color)
                }
            }
            let screenX = Game.WorldToScreenX(GamePos[0], GamePos[1], GamePos[2])
            let screenY =  Game.WorldToScreenY(GamePos[0], GamePos[1], GamePos[2])
            iconPanel.style.position = `${screenX/screenHR}px ${screenY/screenHR}px 0px`;
            // Overlay Grid, visible with Alt pressed
            // Keep in mind that a particle with 0 alpha does still eat frame rate.
            //overlay_alpha = GameUI.IsAltDown() ? 90 : 0;

            //color = [255,255,255]
            var part2 = 0
            var halfSide2 = (overlay_size/2)*64
            var boundingRect2 = {}
            boundingRect2["leftBorderX"] = GamePos[0]-halfSide2
            boundingRect2["rightBorderX"] = GamePos[0]+halfSide2
            boundingRect2["topBorderY"] = GamePos[1]+halfSide2
            boundingRect2["bottomBorderY"] = GamePos[1]-halfSide2

            for (var x2=boundingRect2["leftBorderX"]+32; x2 <= boundingRect2["rightBorderX"]-32; x2+=64)
            {
                for (var y2=boundingRect2["topBorderY"]-32; y2 >= boundingRect2["bottomBorderY"]+32; y2-=64)
                {
                    var pos2 = [x2,y2,GamePos[2]]
                    if (part2>=overlay_size*overlay_size)
                        return

                    var overlayParticle = overlayParticles[part2]
                    Particles.SetParticleControl(overlayParticle, 0, pos2)
                    part2++;

                    // Grid color turns red when over invalid positions
                    // Until we get a good way perform clientside FindUnitsInRadius & Gridnav Check, the prevention will stay serverside
                    color = [255,255,255]
                    for (var index = 0; index < blockers.length; index++) {
                        if (IsPointInPolygon(pos2, blockers[index]))
                        {
                            color = [255,0,0]
                            break;
                        }
                    }
                    Particles.SetParticleControl(overlayParticle, 2, color)
                    Particles.SetParticleControl(overlayParticle, 3, [overlay_alpha,0,0])
                }
            }

            // Update the range particle
            Particles.SetParticleControl(rangeParticle, 0, GamePos)

            // Update the model particle
            // Particles.SetParticleControl(modelParticle, 0, GamePos)

            // // Turn the model red if we can't build there
            // if (recolor_ghost){
            //     if (invalid)
            //         Particles.SetParticleControl(modelParticle, 2, [255,0,0])
            //     else
            //         Particles.SetParticleControl(modelParticle, 2, [255,255,255])
            // }
        }
    }
}

function EndBuildingHelper() {
    state = 'disabled'
    if (rangeParticle) {
        Particles.DestroyParticleEffect(rangeParticle, false);
    }
    // if (modelParticle !== undefined) {
    //     Particles.DestroyParticleEffect(modelParticle, false);
    // }
    for (var i in gridParticles) {
        Particles.DestroyParticleEffect(gridParticles[i], true);
    }
    for (var i in overlayParticles) {
        Particles.DestroyParticleEffect(overlayParticles[i], true);
    }
    iconPanel.SetImage('none')
}
function IsPointInPolygon(point, polygon) {
    var j = polygon.length-1;
    var bool = 0;
    for (var i = 0; i < polygon.length; i++) {
        var polygonPoint1 = polygon[i];
        var polygonPoint2 = polygon[j];
        if (((polygonPoint2.y < point[1] && polygonPoint1.y >= point[1]) || (polygonPoint1.y < point[1] && polygonPoint2.y >= point[1])) && (polygonPoint2.x <= point[0] || polygonPoint1.x <= point[0])) {
            bool = bool ^ (((polygonPoint2.x + (point[1]-polygonPoint2.y)/(polygonPoint1.y-polygonPoint2.y)*(polygonPoint1.x-polygonPoint2.x)) < point[0]) ? 1 : 0);
        }
        j = i;
    }
    return bool == 1;
}
var ActiveAbility = -1;
function CheckBuildingHelper() {
    var CardBuildingInfo = CustomNetTables.GetTableValue("BuildSystem", "card_building_info");
    var ability = Abilities.GetLocalPlayerActiveAbility();
    if (ability != -1) {
        var unitEntIndex = Players.GetLocalPlayerPortraitUnit();
        if (ActiveAbility != ability) {
            EndBuildingHelper();
            for (var cardName in CardBuildingInfo) {
                var data = CardBuildingInfo[cardName];
                if ( Abilities.GetAbilityName(ability) == data.abilityName && (Abilities.GetBehavior(ability) & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) {
                    StartBuildingHelper({
                        state : "active",
                        // size : data.size,
                        // scale : data.scale,
                        // grid_alpha : data.grid_alpha,
                        // model_alpha : data.model_alpha,
                        // recolor_ghost : data.recolor_ghost,
                        // entindex : data.entindex,
                        // builderIndex : unitEntIndex,
                        attack_range : data.attack_range,
                        cardName : cardName,
                    });
                }
            }
        }
    }
    else {
        EndBuildingHelper();
    }
    ActiveAbility = ability;
}

function polygonArray(polygon) {
    var p = []
    for (var k in polygon) {
        p.push(polygon[k]);
    }
    return p;
}

function UpdateBuilding() {
    $.Schedule(1/60, UpdateBuilding);
    CheckBuildingHelper();
}

function OnPlayerSelectReplaceBuilding(data)
{
    GameUI.SelectUnit(data.building, true);
}
function UpdateBlockers() {
    var data = CustomNetTables.GetAllTableValues("build_blocker");
    var polygons = [];
    for (var index = 0; index < data.length; index++) {
        polygons.push(polygonArray(data[index].value));
    }
    blockers = polygons;
}

(function () {
    //BuildingOverheadContainer.RemoveAndDeleteChildren();
    GameEvents.Subscribe("player_select_replace_building", OnPlayerSelectReplaceBuilding);

    CustomNetTables.SubscribeNetTableListener("build_blocker", UpdateBlockers);
    UpdateBlockers();
    UpdateBuilding();
})();


function SnapToGrid(vec, size) {

    if (size % 2 != 0)
    {
        vec[0] = SnapToGrid32(vec[0])
        vec[1] = SnapToGrid32(vec[1])
    }
    else
    {
        vec[0] = SnapToGrid64(vec[0])
        vec[1] = SnapToGrid64(vec[1])
    }
}

function SnapToGrid64(coord) {
    return 64*Math.floor(0.5+coord/64);
}
 
function SnapToGrid32(coord) {
    return 32+64*Math.floor(coord/64);
}