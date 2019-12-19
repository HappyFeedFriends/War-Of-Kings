
CARD_DATA = {
	MAX_CARD = 10,
	CARD_RANDOM_DROP = 5,
	MAX_GRADE = {
		uncommon = 5,
		rare = 6,
		mythical = 6,
		legendary = 7,
		Starting_towers = 7,
	},
	CREEP_MAX = 6, -- TODO
	HEROES_MAX = 4, -- TODO
	CARDS = {
		['uncommon'] = { -- creeps
			npc_war_of_kings_thunder_lizard = {
				class = 'guardian',
	
			},
			npc_war_of_kings_creep_bed = {
				class = 'warrior',
			},
			npc_war_of_kings_harpy = {
				class = 'archer',
			},
			npc_war_of_kings_creep_good = {
				class = 'warrior',	
			},
			npc_war_of_kings_satyr = {
				class = 'warrior',
			},
			npc_war_of_kings_ogre = {
				class = 'warrior',
			},
			npc_war_of_kings_gnoll = {
				class = 'warrior',
			},
			npc_war_of_kings_bear = {
				class = 'warrior',
			},
			npc_war_of_kings_forge = {
				class = 'archer',	
			},
			npc_war_of_kings_golem = {
				class = 'guardian',
			},
			npc_war_of_kings_worg = {
				class = 'warrior',
			},
			npc_war_of_kings_satyr_big = {
				class = 'warrior',
			},
			npc_war_of_kings_demon = {
				class = 'guardian',
			},
		},
		['rare'] = {
			npc_war_of_kings_tusk = {
				class = 'warrior',
				Assemblies = {
					['tusk_upgrade_1'] = {
						AssemblyAbility = 'tusk_walrus_punch_custom',
						assembliesNeed = 'npc_war_of_kings_medusa | npc_war_of_kings_tidehunter',
						data = {
							value = 120,
						},
					},
					['tusk_upgrade_2'] = {
						AssemblyAbility = 'tusk_walrus_punch_custom',
						assembliesNeed = 'npc_war_of_kings_leshrac',
						data = {
							value = 6,
						},
					},
				},
			},
			npc_war_of_kings_pugna = {
				class = 'mage',
				Assemblies = {
					['pugna_upgrade_1'] = {
						AssemblyAbility = 'pugna_life_drain_custom',
						assembliesNeed = 'npc_war_of_kings_leshrac',
						data = {
							value = 600,
						},
					},
				},
			},
			npc_war_of_kings_bloodseeker = {
				class = 'rogue',
				Assemblies = {
					['bloodseeker_upgrade_1'] = {
						AssemblyAbility = 'bloodseeker_bloodrage_custom',
						assembliesNeed = 'npc_war_of_kings_lion',
						data = {
							value = 0,
						},
					},
					['bloodseeker_upgrade_2'] = {
						AssemblyAbility = 'bloodseeker_bloodrite_custom',
						assembliesNeed = 'npc_war_of_kings_necrophos',
						data = {
							value = 10,
						},
					},
				},
			},
			npc_war_of_kings_lion = {
				class = 'mage',
				Assemblies = {
					['lion_upgrade_1'] = {
						AssemblyAbility = 'lion_finger_of_death_custom',
						assembliesNeed = 'npc_war_of_kings_gnoll | npc_war_of_kings_ogre',
						data = {
							value = 30,
						},
					},
				},
			},
			npc_war_of_kings_puck = {
				class = 'mage',
			},
			npc_war_of_kings_tiny = {
				class = 'guardian',
			},
			npc_war_of_kings_dark_willow = {
				class = 'mage',	
				Assemblies = {
					['dark_willow_1'] = {
						AssemblyAbility = 'dark_willow_3',
						assembliesNeed = 'npc_war_of_kings_shadow_fiend',
						data = {
							value = DAMAGE_TYPE_PURE,
						},
					},
					['dark_willow_2'] = {
						AssemblyAbility = 'dark_willow_2',
						assembliesNeed = 'npc_war_of_kings_creep_bed',
						data = {
							value = 0.25,
						},
					},
				},		
			},

			
			npc_war_of_kings_ogre_mage = {
				class = 'mage',
				Assemblies = {
					['ogre_mage_upgrade_1'] = {
						AssemblyAbility = 'ogre_mage_fireblast_custom',
						assembliesNeed = 'npc_war_of_kings_lycan | npc_war_of_kings_ursa',
						data = {
							value = 3,
						},
					},
				},
			},
			npc_war_of_kings_abaddon = {
				class = 'guardian',
				Assemblies = {
					['abaddon_upgrade_1'] = {
						AssemblyAbility = 'abaddon_borrowed_time_custom',
						assembliesNeed = 'npc_war_of_kings_ogre_mage',
						data = {
							value = 1,
						},
					},
				},
			},
			npc_war_of_kings_ursa = {
				class = 'warrior',
				Assemblies = {
					['ursa_upgrade_1'] = {
						AssemblyAbility = 'ursa_fury_swipes',
						assembliesNeed = 'npc_war_of_kings_phantom_assasin',
						data = {
							value = 25,
						},
					},
				},
			},
			npc_war_of_kings_lina = {
				class = 'mage',
				Assemblies = {

					['lina_upgrade_2'] = {
						AssemblyAbility = 'lina_dragon_slave_custom',
						assembliesNeed = 'npc_war_of_kings_satyr_big | npc_war_of_kings_bear',
						data = {
							value = 70,
							duration = 10,
						},
					},
					['lina_upgrade_3'] = {
						AssemblyAbility = 'lina_laguna_blade_custom',
						assembliesNeed = 'npc_war_of_kings_creep_bed | npc_war_of_kings_creep_good',
						data = {
							value = 500,
						},
					},
				},	
			},
			npc_war_of_kings_queen_of_pain = {
				class = 'mage',
				Assemblies = {

					['queen_upgrade_2'] = {
						AssemblyAbility = 'queenofpain_scream_of_pain',
						assembliesNeed = 'npc_war_of_kings_shadow_shaman + npc_war_of_kings_demon | npc_war_of_kings_clinkz',
						data = {
							value = 99999,
						},
					},
				},	
			},
			npc_war_of_kings_wraith_king = {
				class = 'warrior',
				Assemblies = {
					['wraith_king_upgrade_1'] = {
						AssemblyAbility = 'skeleton_king_hellfire_blast',
						assembliesNeed = 'npc_war_of_kings_lina',
						data = {
							value = 125,
						},
					},
					['wraith_king_upgrade_2'] = {
						AssemblyAbility = 'skeleton_king_hellfire_blast',
						assembliesNeed = 'npc_war_of_kings_queen_of_pain | npc_war_of_kings_outworld_devourer',
						data = {
							value = 1.3,
						},
					},
				},
			},
			npc_war_of_kings_outworld_devourer = {
				class = 'mage',
				Assemblies = {
					['devourer_upgrade_1'] = {
						AssemblyAbility = 'obsidian_destroyer_sanity_eclipse_custom',
						assembliesNeed = 'npc_war_of_kings_tiny'
					},
					['devourer_upgrade_3'] = {
						AssemblyAbility = 'obsidian_destroyer_arcane_orb_custom',
						assembliesNeed = 'npc_war_of_kings_harpy',
						data = {
							value = 1,
							chance = 50,
						},
					},
					['devourer_upgrade_2'] = {
						AssemblyAbility = 'obsidian_destroyer_arcane_orb_custom',
						assembliesNeed = 'npc_war_of_kings_golem',
						data = {
							value = 40,
						},
					},
				},
			},
			npc_war_of_kings_templar_assasin = {
				class = 'rogue',
				Assemblies = {
					['templar_assasin_upgrade_1'] = {
						AssemblyAbility = 'templar_assassin_refraction',
						assembliesNeed = 'npc_war_of_kings_centaur_warruner',
						data = {
							value = 45,
						},
					},
					['templar_assasin_upgrade_2'] = {
						AssemblyAbility = 'templar_assassin_refraction',
						assembliesNeed = 'npc_war_of_kings_zeus',
						data = {
							value = 2,
						},
					},
					['templar_assasin_upgrade_3'] = {
						AssemblyAbility = 'templar_assassin_psi_blades',
						assembliesNeed = 'npc_war_of_kings_ursa',
						data = {
							value = 25,
						},
					},
				},
			},
			npc_war_of_kings_centaur_warruner = {
				class = 'warrior',
				Assemblies = {
					['centaur_warruner_upgrade_1'] = {
						AssemblyAbility = 'centaur_hoof_stomp',
						assembliesNeed = 'npc_war_of_kings_medusa',
						data = {
							value = 2,
						},
					},
					['centaur_warruner_upgrade_2'] = {
						AssemblyAbility = 'centaur_hoof_stomp',
						assembliesNeed = 'npc_war_of_kings_shadow_shaman',
						data = {
							value = 200,
						},
					},
				},
			},
			npc_war_of_kings_shadow_shaman = {
				class = 'mage',
				Assemblies = {
					['shaman_upgrade_1'] = {
						AssemblyAbility = 'shadow_shaman_hex_custom',
						assembliesNeed = 'npc_war_of_kings_dragon',
						data = {
							value = 400,
						},
					},
					['shaman_upgrade_2'] = {
						AssemblyAbility = 'shadow_shaman_ether_shock',
						assembliesNeed = 'npc_war_of_kings_golem',
						data = {
							value = 1.5,
						},
					},
					['shaman_upgrade_3'] = {
						AssemblyAbility = 'shadow_shaman_ether_shock',
						assembliesNeed = 'npc_war_of_kings_medusa',
						data = {
							value = 0.9,
						},
					},
				},
			},
			npc_war_of_kings_dragon = {
				class = 'archer',
				Assemblies = {
					['dragon_upgrade_1'] = {
						AssemblyAbility = 'dragon_splash_attack_custom',
						assembliesNeed = 'npc_war_of_kings_zeus',
						data = {
							value = 25,
						},
					},
					['dragon_upgrade_2'] = {
						AssemblyAbility = 'dragon_splash_attack_custom',
						assembliesNeed = 'npc_war_of_kings_golem',
						data = {
							value = 250,
						},
					},
				},
			},
		},
		['mythical'] = {
			npc_war_of_kings_shadow_fiend = {
				class = 'archer',
				Assemblies = { 
					['sf_upgrade_1'] = {
						AssemblyAbility = 'nevermore_dark_lord_custom',
						assembliesNeed = 'npc_war_of_kings_necrophos + npc_war_of_kings_bloodseeker',
						data = {
							value = 35,
							damage = 400,
						},
					},
					['sf_upgrade_2'] = {
						AssemblyAbility = 'shadow_fiend_shadowraze_custom',
						assembliesNeed = 'npc_war_of_kings_demon',
						data = {
							value = 1,
						},
					},
				},			
			},
			npc_war_of_kings_necrophos = {
				class = 'mage',
				Assemblies = {
					['necrophos_upgrade_1'] = {
						AssemblyAbility = 'necrolyte_death_pulse_custom',
						assembliesNeed = 'npc_war_of_kings_lion',
						data = {
							value = 4,
							heal = 65,
						},
					},
					['necrophos_upgrade_2'] = {
						AssemblyAbility = 'necrolyte_reapers_scythe_custom',
						assembliesNeed = 'npc_war_of_kings_satyr + npc_war_of_kings_forge',
						data = {
							value = 10,
						},
					},
				},
			},
			npc_war_of_kings_clinkz = {
				class = 'archer',
				Assemblies = {
					['clinkz_upgrade_1'] = {
						AssemblyAbility = 'clinkz_searing_arrows',
						assembliesNeed = 'npc_war_of_kings_luna',
						data = {
							value = 100,
						},
					},
				},
			},
			npc_war_of_kings_luna = {
				class = 'archer',
				Assemblies = {
					['luna_upgrade_1'] = {
						AssemblyAbility = 'luna_lucent_beam',
						assembliesNeed = 'npc_war_of_kings_viper',
						data = {
							value = 360,
						},
					},
					['luna_upgrade_2'] = {
						AssemblyAbility = 'luna_moon_glaive',
						assembliesNeed = 'npc_war_of_kings_gyrocopter',
						data = {
							value = 25,
						},
					},
				},
			},
			npc_war_of_kings_viper = {
				class = 'rogue',
				Assemblies = {
					['viper_upgrade_1'] = {
						AssemblyAbility = 'viper_viper_strike',
						assembliesNeed = 'npc_war_of_kings_huskar',
						data = {
							value = 370,
						},
					},
				},
			},
			npc_war_of_kings_gyrocopter = {
				class = 'archer',
				Assemblies = {
					['gyrocopter_upgrade_1'] = {
						AssemblyAbility = 'gyrocopter_rocket_barrage',
						assembliesNeed = 'npc_war_of_kings_zeus',
						data = {
							value = 2,
						},
					},
				},
			},
			npc_war_of_kings_medusa = {
				class = 'archer',
				Assemblies = {
					['medusa_upgrade_1'] = {
						AssemblyAbility = 'medusa_stone_gaze',
						assembliesNeed = 'npc_war_of_kings_golem',
						data = {
							value = 15
						},
					},
					['medusa_upgrade_2'] = {
						AssemblyAbility = 'medusa_split_shot_custom',
						assembliesNeed = 'npc_war_of_kings_tidehunter',
						data = {
							value = 15,
						},
					},
					['medusa_upgrade_3'] = {
						AssemblyAbility = 'medusa_split_shot_custom',
						assembliesNeed = 'npc_war_of_kings_bounty_hunter',
						data = {
							value = 2,
						},
					},
				},
			},
			npc_war_of_kings_tidehunter = {
				class = 'warrior',
				Assemblies = {
					['tidehunter_upgrade_1'] = {
						AssemblyAbility = 'tidehunter_ravage',
						assembliesNeed = 'npc_war_of_kings_bounty_hunter',
						data = {
							value = 300,
						},
					},
					['tidehunter_upgrade_2'] = {
						AssemblyAbility = 'tidehunter_ravage',
						assembliesNeed = 'npc_war_of_kings_pugna',
						data = {
							value = 250,
						},
					},
				},
			},
			npc_war_of_kings_leshrac = {
				class = 'mage',
				Assemblies = {
					['leshrac_upgrade_1'] = {
						AssemblyAbility = 'leshrac_pulse_nova',
						assembliesNeed = 'npc_war_of_kings_enigma',
						data = {
							value = 0,
						},
					},
				},
			},
			npc_war_of_kings_bounty_hunter = {
				class = 'rogue',
				Assemblies = {
					['bounty_hunter_1'] = {
						AssemblyAbility = 'bounty_hunter_jinada_custom',
						assembliesNeed = 'npc_war_of_kings_medusa + npc_war_of_kings_death_prophet + npc_war_of_kings_pugna | npc_war_of_kings_enigma',
						data = {
							value = 15,
						},
					},
				},
			},
		},
		['legendary'] = {
			npc_war_of_kings_zeus = {
				class = 'mage',
				Assemblies = {
					['zeus_upgrade_1'] = {
						assembliesNeed = 'npc_war_of_kings_tusk',
						data = {
							radius = 650,
							value = 0.6,
						},
					},
					['zeus_upgrade_2'] = {
						AssemblyAbility = 'zeus_static_field_custom',
						assembliesNeed = 'npc_war_of_kings_templar_assasin',
						data = {
							value = 2,
						},
					},
					['zeus_upgrade_3'] = {
						AssemblyAbility = 'zeus_arc_lightning_custom',
						assembliesNeed = 'npc_war_of_kings_outworld_devourer',
						data = {
							value = 120,
						},
					},
				},
			},
			npc_war_of_kings_crystal_maiden = {
				class = 'mage',
			},
			npc_war_of_kings_huskar = {
				class = 'archer',
				Assemblies = {
					['huskar_upgrade_1'] = {
						AssemblyAbility = 'huskar_burning_spear_custom',
						assembliesNeed = 'npc_war_of_kings_creep_good', 
						data = {
							value = 8,
						},
					},
				},
			},
			npc_war_of_kings_juggernaut = {
				class = 'warrior',
				Assemblies = {
					['juggernaut_upgrade_1'] = {
						AssemblyAbility = 'juggernaut_omni_slash_custom',
						assembliesNeed = 'npc_war_of_kings_bloodseeker', 
						data = {
							value = 15,
						},
					},
				},
			},
			npc_war_of_kings_sven = {
				class = 'warrior',
				Assemblies = {
					['sven_upgrade_1'] = {
						AssemblyAbility = 'sven_great_cleave',
						assembliesNeed = 'npc_war_of_kings_bear', 
						data = {
							value = 340,
						},
					},
					['sven_upgrade_2'] = {
						AssemblyAbility = 'sven_storm_bolt',
						assembliesNeed = 'npc_war_of_kings_demon + npc_war_of_kings_queen_of_pain', 
						data = {
							value = 350,
						},
					},
				},	
			},
			npc_war_of_kings_enigma = {
				class = 'mage',
				Assemblies = {
					['enigma_upgrade_1'] = {
						AssemblyAbility = 'enigma_black_hole',
						assembliesNeed = 'npc_war_of_kings_death_prophet',
						data = {
							value = 320,
						},
					},
				},
			},
			npc_war_of_kings_death_prophet = {
				class = 'mage',
				Assemblies = {
					['prophet_upgrade_1'] = {
						assembliesNeed = 'npc_war_of_kings_worg',
						data = {
							value = 35,
						},
					},
				},
			},
			npc_war_of_kings_lycan = {
				class = 'warrior',
				Assemblies = {
					['lycan_upgrade_1'] = {
						AssemblyAbility = 'lycan_shapeshift',
						assembliesNeed = 'npc_war_of_kings_gnoll | npc_war_of_kings_puck',
						data = {
							value = 100,
						},
					},
					['lycan_upgrade_2'] = {
						AssemblyAbility = 'lycan_wolves_custom',
						assembliesNeed = 'npc_war_of_kings_worg',
						data = {
							value = 1,
						},
					},
				},
			},
			npc_war_of_kings_phantom_assasin = {
				class = 'rogue',
				Assemblies = {
					['phantom_assasin_upgrade_3'] = {
						assembliesNeed = 'npc_war_of_kings_centaur_warruner',
						data = {
							value = 2,
							value_chance = 15,
						},						
					},
					['phantom_assasin_upgrade_1'] = {
						AssemblyAbility = 'phantom_assassin_coup_de_grace',
						assembliesNeed = 'npc_war_of_kings_templar_assasin',
						data = {
							value = 70,
						},
					},
					['phantom_assasin_upgrade_2'] = {
						AssemblyAbility = 'phantom_assassin_coup_de_grace',
						assembliesNeed = 'npc_war_of_kings_dragon',
						data = {
							value = 5,
						},
					},
				},
			},
		},
		-- hidden
		['Starting_towers'] = {
			npc_war_of_kings_default_silencer = {
				class = 'mage',
				lvl = 0,
				Assemblies = {
					-- ['silencer_1'] = {
					-- 	AssemblyAbility = 'silencer_4',
					-- 	assembliesNeed = 'npc_war_of_kings_harpy',
					-- 	data = {
					-- 		value = 15,
					-- 	},
					-- },
					['silencer_2'] = {
						AssemblyAbility = 'silencer_4',
						assembliesNeed = 'npc_war_of_kings_demon',
						data = {
							value = 1.8,
						},
					},
					['silencer_3'] = {
						AssemblyAbility = 'silencer_1',
						assembliesNeed = 'npc_war_of_kings_satyr_big',
						data = {
							value = 22,
						},
					},
					['silencer_4'] = {
						assembliesNeed = 'npc_war_of_kings_crystal_maiden',
						data = {
							value = 2,
						},
					},
					['silencer_5'] = {
						AssemblyAbility = 'silencer_3',
						assembliesNeed = 'npc_war_of_kings_outworld_devourer',
						data = {
							value = 450,
						},
					},
				},
			},	
			npc_war_of_kings_default_doom = {
				class = 'warrior',
				lvl = 0,
				Assemblies = {
					['doom_upgrade_1'] = {
						AssemblyAbility = 'doom_1',
						assembliesNeed = 'npc_war_of_kings_thunder_lizard',
						data = {
							value = 1,
						},
					},
					['doom_upgrade_2'] = {
						AssemblyAbility = 'doom_4',
						assembliesNeed = 'npc_war_of_kings_demon',
						data = {
							value = 1,
						},
					},
					['doom_upgrade_3'] = {
						AssemblyAbility = 'doom_1',
						assembliesNeed = 'npc_war_of_kings_ogre_mage',
						data = {
							value = 35,
						},
					},
					['doom_upgrade_4'] = {
						AssemblyAbility = 'doom_2',
						assembliesNeed = 'npc_war_of_kings_golem',
						data = {
							value = 65,
						},
					},
					['doom_upgrade_5'] = {
						AssemblyAbility = 'doom_1',
						assembliesNeed = 'npc_war_of_kings_clinkz',
						data = {
							value = 1.1,
						},
					},
				},
			},	
			-- npc_war_of_kings_default_dragon_knight = {
			-- 	class = 'warrior',
			-- 	lvl = 40,
			-- },	
			npc_war_of_kings_default_drow_ranger = {
				class = 'archer',
				lvl = 40,
			},	

		},
	},
}


CARD_KEY_SWAP = { -- filter
	['wraith_king_upgrade_2'] = {
		key_swap = 'blast_stun_duration',
	},
	['wraith_king_upgrade_1'] = {
		key_swap = 'blast_dot_damage',
	},
	['medusa_upgrade_1'] = {
		key_swap = 'bonus_physical_damage',
	},
	['enigma_upgrade_1'] = {
		key_swap = 'far_damage',
	},
	['ursa_upgrade_1'] = {
		key_swap = 'damage_per_stack',
	},
	['keeper_upgrade_1'] = {
		key_swap_multiply = 'damage_per_second',
	},
	['tidehunter_upgrade_1'] = {
		key_swap = 'radius',
	},
	['leshrac_upgrade_1'] = {
		key_swap_set = 'mana_cost_per_second', 
	},
	['zeus_upgrade_2'] = {
		key_swap = 'damage_health_pct',
	},
	['zeus_upgrade_3'] = {
		key_swap = 'arc_damage',
	},
	['phantom_assasin_upgrade_1'] = {
		key_swap = 'crit_bonus',
	},
	['phantom_assasin_upgrade_2'] = {
		key_swap = 'crit_chance',
	},
	['templar_assasin_upgrade_2'] = {
		key_swap = 'instances',
	},
	['templar_assasin_upgrade_1'] = {
		key_swap = 'bonus_damage',
	},
	['templar_assasin_upgrade_3'] = {
		key_swap = 'attack_spill_pct',
	},
	['drow_ranged_upgrade_1'] = {
		key_swap = 'bonus_damage',
	},
	['drow_ranged_upgrade_2'] = {
		key_swap = 'split_count_scepter',
	},
	['centaur_warruner_upgrade_2'] = {
		key_swap = 'radius',
	},
	['centaur_warruner_upgrade_1'] = {
		key_swap = 'stun_duration',
	},
	luna_upgrade_1 = {
		key_swap = 'beam_damage',
	},
	luna_upgrade_2 = {
		key_swap_dec = 'damage_reduction_percent',
	},
	viper_upgrade_1 = {
		key_swap = 'damage',
	},
	queen_upgrade_2 = {
		key_swap_set = 'area_of_effect',
	},
	sven_upgrade_1 = {
		key_swap = 'cleave_distance',
	},
	sven_upgrade_2 = {
		key_swap = 'bolt_aoe',
	},	
	lycan_upgrade_1 = {
		key_swap = 'crit_multiplier',
	},
}
CLASS_DATA = {
	warrior = {
		bonus_star = 50,
		special_bonus = 20,
	},
	guardian = {
		bonus_star = 1,
		special_bonus = 1,
	},
	mage = {
		bonus_star = 10,
		special_bonus = 30,
	},
	rogue = {
		bonus_star = {
			chance = 5,
			critical = 100,
		},
		special_bonus = {
			chance = 25,
			critical = 250,
		},
	},
	archer = {
		bonus_star = 0.1,
		special_bonus = 300,
	},
}

ALL_CARD_NAME = {} -- no godness
for k,v in pairs(CARD_DATA.CARDS) do
	if k ~= 'Godness' then 
		for name,_ in pairs(v) do
			table.insert(ALL_CARD_NAME,name)
		end
	end
end
