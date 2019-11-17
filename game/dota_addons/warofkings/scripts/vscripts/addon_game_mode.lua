function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheUnitByNameSync("npc_war_of_kings_medusa", context)
	PrecacheUnitByNameSync("npc_war_of_kings_tidehunter", context)
	PrecacheUnitByNameSync("npc_war_of_kings_leshrac", context)
	PrecacheUnitByNameSync("npc_war_of_kings_bounty_hunter", context)
	PrecacheUnitByNameSync("npc_war_of_kings_pugna", context)
	PrecacheUnitByNameSync("npc_war_of_kings_mars", context)
	PrecacheUnitByNameSync("npc_war_of_kings_satyr", context)
	PrecacheUnitByNameSync("npc_war_of_kings_ogre", context)
	PrecacheUnitByNameSync("npc_war_of_kings_ghost", context)
	PrecacheUnitByNameSync("npc_war_of_kings_troll_berserk", context)
	PrecacheUnitByNameSync("npc_war_of_kings_fire_spirit", context)
	PrecacheUnitByNameSync("npc_war_of_kings_earth_spirit", context)
	PrecacheUnitByNameSync("npc_war_of_kings_wind_spirit", context)
	PrecacheUnitByNameSync("npc_war_of_kings_tusk", context)
	PrecacheUnitByNameSync("npc_war_of_kings_outworld_devourer", context)
	PrecacheUnitByNameSync("npc_war_of_kings_shadow_shaman", context)

	PrecacheUnitByNameSync("npc_war_of_kings_dragon", context)
	PrecacheUnitByNameSync("npc_war_of_kings_centaur", context)
	PrecacheUnitByNameSync("npc_war_of_kings_enigma", context)
	PrecacheUnitByNameSync("npc_war_of_kings_keeper_of_the_light", context)
	PrecacheUnitByNameSync("npc_war_of_kings_satyr_big", context)
	PrecacheUnitByNameSync("npc_war_of_kings_worg", context)
	PrecacheUnitByNameSync("npc_war_of_kings_golem", context)
	PrecacheUnitByNameSync("npc_war_of_kings_death_prophet", context)

	PrecacheUnitByNameSync("npc_war_of_kings_zeus", context)
	PrecacheUnitByNameSync("npc_war_of_kings_phantom_assasin", context)
	PrecacheUnitByNameSync("npc_war_of_kings_templar_assasin", context)
	PrecacheUnitByNameSync("npc_war_of_kings_drow_ranged", context)
	PrecacheUnitByNameSync("npc_war_of_kings_centaur_warruner", context)
	PrecacheUnitByNameSync("npc_war_of_kings_beast", context)
	PrecacheUnitByNameSync("npc_war_of_kings_troll_shaman", context)
	PrecacheUnitByNameSync("npc_war_of_kings_gnoll", context)

	PrecacheUnitByNameSync("npc_war_of_kings_wraith_king", context)
	PrecacheUnitByNameSync("npc_war_of_kings_luna", context)
	PrecacheUnitByNameSync("npc_war_of_kings_viper", context)
	PrecacheUnitByNameSync("npc_war_of_kings_gyrocopter", context)
	PrecacheUnitByNameSync("npc_war_of_kings_lina", context)
	PrecacheUnitByNameSync("npc_war_of_kings_queen_of_pain", context)
	PrecacheUnitByNameSync("npc_war_of_kings_demon", context)
	PrecacheUnitByNameSync("npc_war_of_kings_forge", context)
	PrecacheUnitByNameSync("npc_war_of_kings_bear", context)
	PrecacheUnitByNameSync("npc_war_of_kings_creep_bed", context)
	PrecacheUnitByNameSync("npc_war_of_kings_creep_good", context)

	PrecacheUnitByNameSync("npc_war_of_kings_puck", context)
	PrecacheUnitByNameSync("npc_war_of_kings_crystal_maiden", context)
	PrecacheUnitByNameSync("npc_war_of_kings_ursa", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_warrior_building", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_rogue_building", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_mage_building", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_guardian_building", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_shaman_building", context)
	PrecacheUnitByNameSync("npc_war_of_Kings_special_boss_archer_building", context) 

	PrecacheUnitByNameSync("npc_war_of_kings_huskar", context)
	PrecacheUnitByNameSync("npc_war_of_kings_tiny", context)
	PrecacheUnitByNameSync("npc_war_of_kings_clinkz", context)
	PrecacheUnitByNameSync("npc_war_of_kings_sven", context)
	PrecacheUnitByNameSync("npc_war_of_kings_sniper", context)
	for k,v in pairs(ROUND_DATA.ROUNDS) do
		if k ~= 'Special' then 
			local units = string.split(v.UnitList or ('npc_war_of_kings_wave_' .. k),' | ')
			for _,UnitName in pairs(units) do
				PrecacheUnitByNameSync(UnitName, context)
			end
		end
	end
	-- for k,v in pairs(CARD_DATA.CARDS) do
	-- 	for unitName,_ in pairs(v) do
	-- 		print(unitName)
	-- 		PrecacheUnitByNameSync(unitName, context)
	-- 	end
	-- end
end 
-- local items_game = LoadKeyValues("scripts/items/items_game.txt")
require('gamemode')
function Activate()
	GameRules.AddonTemplate = GameMode()
	GameRules.AddonTemplate:Init()
end


