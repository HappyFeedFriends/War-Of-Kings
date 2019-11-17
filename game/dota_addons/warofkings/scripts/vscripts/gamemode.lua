LinkLuaModifier("modifier_war_of_kings_passive", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_war_of_kings_passive_unit", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_war_of_kings_bonus_damage", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_war_of_kings_bonus_attack_speed", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_war_of_kings_bonus_amplify", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_war_of_kings_rogue_critical_damage", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_war_of_kings_bonus_attack_damage_special", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_war_of_kings_bonus_attack_range", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_war_of_kings_bonus_amplify_special", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_base_movespeed_ancient", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_building", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bonus_movespeed_creep", 'modifiers.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_dragon_slave_custom_debuff", "abilityHero/lina/modifiers/modifier_lina_dragon_slave_custom_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_sniper_range_attack_bonus", "abilityHero/sniper/modifier_sniper_range_attack_bonus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_sniper_base_attack", "abilityHero/sniper/modifier_sniper_base_attack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_physical", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_physical_buff", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_magical", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_magical_buff", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_midas", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_midas_buff", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_unique_aura_midas_buff_cooldown", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_creep_heroes", "modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_octarine_core_custom', 'items/item_octarine_1.lua', LUA_MODIFIER_MOTION_NONE)
if GameMode == nil then
    _G.GameMode = class({})
end

local RequireList = {
	"settings",
	"events",
	"filters",
	"modifiers",
	["libraries"] = {
		"timers",
		"keyvalues",
		"build_system",
	},
	['InheritClasses'] = {
		"building",
		'Player',
	},
	["util"] = {
		"funcs",
		"math",
		"PlayerResource",
		"string",
		"table",
	},
}

for k,v in pairs(RequireList) do
	if type(v) == "table" then
		for _,value in pairs(v) do
			require(k .. "/" .. value)
		end 
	else
		require(v)
	end
end
require("modules/index")
function GameMode:OnHeroInGame(hero)
end

function GameMode:OnGameInProgress()
	round:UpgradeDifficultyState(ROUND_DIFFICUILT_STATE_START)
end

function GameMode:PreGame()

end
function GameMode:HeroSelection()
	-- card:OnPreLoad()
end 

function GameMode:Init()
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME )
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
	GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
	GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )
	GameRules:SetStartingGold( STARTING_GOLD )
	local mode = GameRules:GetGameModeEntity()     
	mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
	mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
	mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
	mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
	mode:SetBuybackEnabled( BUYBACK_ENABLED )
	mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
	mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
	mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
	mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
	mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
	mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )
	mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
	mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
	mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
	mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
	mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
	if FORCE_PICKED_HERO ~= nil then
		mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
	end
	mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
	mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
	mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
	mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
	mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
	mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
	mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
	mode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )
	for rune, spawn in pairs(ENABLED_RUNES) do
		mode:SetRuneEnabled(rune, spawn)
	end
	mode:SetUnseenFogOfWarEnabled( USE_UNSEEN_FOG_OF_WAR )
	mode:SetDaynightCycleDisabled( DISABLE_DAY_NIGHT_CYCLE )
	mode:SetKillingSpreeAnnouncerDisabled( DISABLE_KILLING_SPREE_ANNOUNCER )
	mode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )
	GameRules:LockCustomGameSetupTeamAssignment( true )
	GameRules:EnableCustomGameSetupAutoLaunch( true )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 15 )
	for k,v in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
		GameRules:SetCustomGameTeamMaxPlayers(k, v)
	end
	if USE_CUSTOM_TEAM_COLORS then
		for team,color in pairs(TEAM_COLORS) do
			SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
		end
	end
	GameMode:StartGameEvents()
	GameMode:FiltersOn()
	round:Preload()
	CustomShop:Preload()
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
end

function GameMode:Think()
	Timers:CreateTimer(0.1,function()

		return 0.1
	end)
end