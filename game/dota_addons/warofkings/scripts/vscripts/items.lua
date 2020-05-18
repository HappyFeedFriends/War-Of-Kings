item_card_base_class = {
	OnSpellStart 	= function(self)
			local name = string.gsub(self:GetAbilityName(), 'item_card_', 'npc_')
			local location = self:GetCursorPosition()
			local builder = PlayerResource:GetSelectedHeroEntity(self:GetCaster():GetPlayerOwnerID())
			SnapToGrid(BUILDING_SIZE,location)
			if builder and BuildSystem:PlaceBuilding(builder, name, location, BUILDING_ANGLE,self.cost or 0) then
				self:UpdateCharge()
			end
	end,
}
function item_card_base_class:CastFilterResultLocation(vLocation)
	if IsServer() then
		SnapToGrid(BUILDING_SIZE, vLocation)
		if not BuildSystem:ValidPosition(BUILDING_SIZE, vLocation, nil) then
			self.error = "dota_hud_error_cant_build_at_location"
			return UF_FAIL_CUSTOM
		end
		local pID = self:GetCaster().GetPlayerID and self:GetCaster():GetPlayerID()
		if pID and  not GetPlayerCustom(pID):IsValidIsland(vLocation) then 
			self.error = "dota_hud_error_cant_build_at_location"
			return UF_FAIL_CUSTOM
		end
		local creepName = string.gsub(self:GetAbilityName(), 'item_card_', 'npc_')
		local creepCount = BuildSystem:GetCountBuild(pID,function(build) return build:IsCreep() end)
		local heroCount = BuildSystem:GetCountBuild(pID,function(build) return build:IsHero() and not build:IsStartingTower() end)

		local IsCreep = Building:IsCreepByName(creepName)
		local myCreep = BuildSystem:FindBuildByName(pID,creepName)
		for k,v in pairs(myCreep) do
			if v:GetGrade() < CARD_DATA.MAX_GRADE[v:GetRariry()] then 
				if v:IsHero() then 
					heroCount = heroCount - 1
				else 
					creepCount = creepCount - 1
				end
				break
			end
		end
 
		if not IsCreep and heroCount >= CARD_DATA.HEROES_MAX then 
			self.error = "dota_hud_error_heroes_max"
			return UF_FAIL_CUSTOM
		end
		if IsCreep and creepCount >= CARD_DATA.CREEP_MAX then 
			self.error = "dota_hud_error_creep_max"
			return UF_FAIL_CUSTOM
		end


	end
	return UF_SUCCESS
end
function item_card_base_class:GetCustomCastErrorLocation(vLocation)
	return self.error
end

item_card_war_of_kings_default_silencer = class(item_card_base_class or {}) 
item_card_war_of_kings_default_drow_ranger = class(item_card_base_class or {}) 
item_card_war_of_kings_default_dragon_knight = class(item_card_base_class or {}) 
item_card_war_of_kings_default_doom = class(item_card_base_class or {}) 

item_card_war_of_kings_thunder_lizard = class(item_card_base_class or {}) 
item_card_war_of_kings_harpy = class(item_card_base_class or {}) 
item_card_war_of_kings_shadow_fiend = class(item_card_base_class or {}) 
item_card_war_of_kings_tinker = class(item_card_base_class or {}) 
item_card_war_of_kings_dark_willow = class(item_card_base_class or {}) 
item_card_war_of_kings_undying = class(item_card_base_class or {}) 
item_card_war_of_kings_ogre_mage = class(item_card_base_class or {})
item_card_war_of_kings_abaddon = class(item_card_base_class or {})
item_card_war_of_kings_lycan = class(item_card_base_class or {})
item_card_war_of_kings_necrophos = class(item_card_base_class or {})
item_card_war_of_kings_bloodseeker = class(item_card_base_class or {})
item_card_war_of_kings_lion = class(item_card_base_class or {})
item_card_war_of_kings_devoloper = class(item_card_base_class or {})
item_card_war_of_kings_medusa = class(item_card_base_class or {})
item_card_war_of_kings_tidehunter = class(item_card_base_class or {})
item_card_war_of_kings_leshrac = class(item_card_base_class or {})
item_card_war_of_kings_bounty_hunter = class(item_card_base_class or {})
item_card_war_of_kings_pugna = class(item_card_base_class or {})
item_card_war_of_kings_tusk = class(item_card_base_class or {})
item_card_war_of_kings_mars = class(item_card_base_class or {})
item_card_war_of_kings_satyr = class(item_card_base_class or {})
item_card_war_of_kings_ogre = class(item_card_base_class or {})
item_card_war_of_kings_ghost = class(item_card_base_class or {})
item_card_war_of_kings_tusk = class(item_card_base_class or {})
item_card_war_of_kings_enigma = class(item_card_base_class or {})
item_card_war_of_kings_keeper_of_the_light = class(item_card_base_class or {})
item_card_war_of_kings_death_prophet = class(item_card_base_class or {})
item_card_war_of_kings_outworld_devourer = class(item_card_base_class or {})
item_card_war_of_kings_shadow_shaman = class(item_card_base_class or {})
item_card_war_of_kings_centaur = class(item_card_base_class or {})
item_card_war_of_kings_golem = class(item_card_base_class or {})
item_card_war_of_kings_worg = class(item_card_base_class or {})
item_card_war_of_kings_satyr_big = class(item_card_base_class or {})
item_card_war_of_kings_dragon = class(item_card_base_class or {})
item_card_war_of_kings_zeus = class(item_card_base_class or {})
item_card_war_of_kings_gnoll = class(item_card_base_class or {})
item_card_war_of_kings_troll_shaman = class(item_card_base_class or {})
item_card_war_of_kings_beast = class(item_card_base_class or {})
item_card_war_of_kings_centaur_warruner = class(item_card_base_class or {})
item_card_war_of_kings_drow_ranged = class(item_card_base_class or {})
item_card_war_of_kings_templar_assasin = class(item_card_base_class or {})
item_card_war_of_kings_phantom_assasin = class(item_card_base_class or {})
item_card_war_of_kings_earth_spirit = class(item_card_base_class or {})
item_card_war_of_kings_wind_spirit = class(item_card_base_class or {})
item_card_war_of_kings_fire_spirit = class(item_card_base_class or {})
item_card_war_of_kings_puck = class(item_card_base_class or {})
item_card_war_of_kings_troll_berserk = class(item_card_base_class or {})
item_card_war_of_kings_crystal_maiden = class(item_card_base_class or {})
item_card_war_of_kings_ursa = class(item_card_base_class or {})
item_card_war_of_Kings_special_boss_warrior_building = class(item_card_base_class or {})
item_card_war_of_Kings_special_boss_rogue_building = class(item_card_base_class or {})
item_card_war_of_Kings_special_boss_mage_building = class(item_card_base_class or {})
item_card_war_of_Kings_special_boss_shaman_building = class(item_card_base_class or {})
item_card_war_of_Kings_special_boss_archer_building = class(item_card_base_class or {}) 
item_card_war_of_Kings_special_boss_guardian_building = class(item_card_base_class or {})
item_card_war_of_kings_tiny = class(item_card_base_class or {})
item_card_war_of_kings_clinkz = class(item_card_base_class or {})
item_card_war_of_kings_juggernaut = class(item_card_base_class or {})
item_card_war_of_kings_huskar = class(item_card_base_class or {})
item_card_war_of_kings_sven = class(item_card_base_class or {})
item_card_war_of_kings_sniper = class(item_card_base_class or {})
item_card_war_of_kings_creep_good = class(item_card_base_class or {})
item_card_war_of_kings_creep_bed = class(item_card_base_class or {}) 
item_card_war_of_kings_bear = class(item_card_base_class or {})
item_card_war_of_kings_forge = class(item_card_base_class or {})
item_card_war_of_kings_demon = class(item_card_base_class or {})
item_card_war_of_kings_queen_of_pain = class(item_card_base_class or {})
item_card_war_of_kings_lina = class(item_card_base_class or {})
item_card_war_of_kings_viper = class(item_card_base_class or {})
item_card_war_of_kings_luna = class(item_card_base_class or {})
item_card_war_of_kings_wraith_king = class(item_card_base_class or {})
item_card_war_of_kings_gyrocopter = class(item_card_base_class or {})
