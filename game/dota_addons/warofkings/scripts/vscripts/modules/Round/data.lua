ROUND_MODE_NORMAL = 1
ROUND_MODE_ENDLESS = 2

ROUND_DIFFICUILT_SIMPLE = 1
ROUND_DIFFICUILT_NORMAL = 2
ROUND_DIFFICUILT_HARD = 3
ROUND_DIFFICUILT_IMPOSSIBLE = 4
ROUND_DIFFICUILT_HELL = 5
ROUND_DIFFICUILT_SANDBOX = 6

ROUND_DIFFICUILT_STATE_START = 1
ROUND_DIFFICUILT_STATE_TICK = 2
ROUND_DIFFICUILT_STATE_END = 3

PICK_DIFFICULTY_TIME = 30

ROUND_DIFFICUILT_DATA = {
	[ROUND_DIFFICUILT_SANDBOX] = {
		globalRanking = false,
		endlessMode = true,
	},
	[ROUND_DIFFICUILT_SIMPLE] = {
		health = 50,
		damage = 50,
		globalRanking = false,
		endlessMode = false,
	},
	[ROUND_DIFFICUILT_NORMAL] = {
		health = 100,
		damage = 100,
		globalRanking = false,
		endlessMode = true,
	},
	[ROUND_DIFFICUILT_HARD] = {
		health = 150,
		damage = 150,
		globalRanking = false,
		endlessMode = true,
	},
	[ROUND_DIFFICUILT_IMPOSSIBLE] = {
		health = 175,
		damage = 175,
		globalRanking = true,
		endlessMode = true,
	},
	[ROUND_DIFFICUILT_HELL] = {
		health = 200,
		damage = 175,
		globalRanking = true,
		endlessMode = true,
	},
}
NORMAL_CREEP = 1
MUTANT_CREEP = 2
CHAMPION_CREEP = 3
ANCIENT_CREEP = 4
MINI_BOSS_CREEP  = 5
BOSS_CREEP = 6

MAX_ROUND = 80
CREEP_DATA = {
	[NORMAL_CREEP] = {
		crystal_drop = 1
	},
	[MUTANT_CREEP] = {
		crystal_drop = 1
	},
	[CHAMPION_CREEP] = {
		bonus_damage_tower = 30,
		health_bonus = 35,
		movespeed = 15,
		crystal = 5,
		gold = 55,
		chance = 15,
		shield = 55,
	},
	[ANCIENT_CREEP] = {
		damage = 100,
		health = 250,
		base_speed = 170,
		crystal = 8,
		gold = 75,
		chance = 20,
	},
	[MINI_BOSS_CREEP] = {
		damage = 300,
		crystal = 45,
		gold = 1600,
		chance_drop_card = 10,
		interval = 35,
	},
	[BOSS_CREEP] = {
		damage = 600,
		crystal = 150,
		gold = 5000,
	},
}
ROUND_DATA = {
	--NEXT_TIME_ROUND = 45,
	ROUNDS = {
		[1] = {
			["SpawnCount"] 	=	55,
			["SpawnTick"] 	=	0.9,
		},
		[2] = {
			["UnitList"] 	=	"npc_war_of_kings_wave_2_1 | npc_war_of_kings_wave_2_2",
			["SpawnCount"] 	=	58,
			["SpawnTick"] 	=	0.9,
		},
		[3] = {
			["SpawnCount"] 	=	55,
			["SpawnTick"] 	=	0.9,
		},
		[4] = {
			["SpawnCount"] 	=	58,
			["SpawnTick"] 	=	0.9,
		},
		[6] = {
			["UnitList"] 	=	"npc_war_of_kings_wave_6_1 | npc_war_of_kings_wave_6_2 | npc_war_of_kings_wave_6_3",
			["SpawnCount"] 	=	50,
			["SpawnTick"] 	=	0.9,
		},
		[7] = {
			["SpawnCount"] 	=	22,
			["SpawnTick"] 	=	2,
		},
		[8] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.8,
		},
		[9] = {
			["SpawnCount"] 	=	65,
			["SpawnTick"] 	=	0.5,
		},
		[11] = {
			["SpawnCount"] 	=	10,
			["SpawnTick"] 	=	4,
		},
		[12] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.7,
		},
		[13] = {
			["SpawnCount"] 	=	52,
			["SpawnTick"] 	=	0.7,
		},
		[14] = {
			["SpawnCount"] 	=	5,
			["SpawnTick"] 	=	10,
		},
		[16] = {
			["SpawnCount"] 	=	15,
			["SpawnTick"] 	=	2,
		},
		[17] = {
			["SpawnCount"] 	=	33,
			["SpawnTick"] 	=	0.4,
		},
		[18] = {
			["SpawnCount"] 	=	35,
			["SpawnTick"] 	=	0.5,
		},
		[19] = {
			["SpawnCount"] 	=	42,
			["SpawnTick"] 	=	0.5,
		},
		[21] = {
			["SpawnCount"] 	=	18,
			["SpawnTick"] 	=	2,
		},
		[22] = {
			["SpawnCount"] 	=	4,
			["SpawnTick"] 	=	0.8,
		},
		[23] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.9,
		},
		[24] = {
			["SpawnCount"] 	=	40,
			["SpawnTick"] 	=	0.9,
		},
		[26] = {
			["SpawnCount"] 	=	32,
			["SpawnTick"] 	=	1.3,
		},
		[27] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.8,
		},
		[28] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.7,
		},
		[29] = {
			["SpawnCount"] 	=	54,
			["SpawnTick"] 	=	1,
		},
		[31] = {
			["SpawnCount"] 	=	54,
			["SpawnTick"] 	=	0.7,
		},
		[32] = {
			["SpawnCount"] 	=	76,
			["SpawnTick"] 	=	0.7,
		},
		[33] = {
			["SpawnCount"] 	=	10,
			["SpawnTick"] 	=	7,
		},
		[34] = {
			["SpawnCount"] 	=	65,
			["SpawnTick"] 	=	0.7,
		},
		[36] = {
			["SpawnCount"] 	=	54,
			["SpawnTick"] 	=	0.7,
		},
		[37] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.7,
		},
		[38] = {
			["SpawnCount"] 	=	40,
			["SpawnTick"] 	=	0.7,
		},
		[39] = {
			["SpawnCount"] 	=	29,
			["SpawnTick"] 	=	1.1,
		},
		[41] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.8,
		},
		[42] = {
			["SpawnCount"] 	=	47,
			["SpawnTick"] 	=	0.75,
		},
		[43] = {
			["SpawnCount"] 	=	37,
			["SpawnTick"] 	=	0.6,
		},
		[44] = {
			["SpawnCount"] 	=	40,
			["SpawnTick"] 	=	0.6,
		},
		[46] = {
			["SpawnCount"] 	=	42,
			["SpawnTick"] 	=	0.65,
		},
		[47] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.7,
		},
		[48] = {
			["SpawnCount"] 	=	20,
			["SpawnTick"] 	=	1.2,
		},
		[49] = {
			["SpawnCount"] 	=	35,
			["SpawnTick"] 	=	0.6,
		},
		[51] = {
			["SpawnCount"] 	=	55,
			["SpawnTick"] 	=	0.6,
		},
		[52] = {
			["SpawnCount"] 	=	65,
			["SpawnTick"] 	=	0.7,
		},
		[53] = {
			["SpawnCount"] 	=	55,
			["SpawnTick"] 	=	0.6,
		},
		[54] = {
			["SpawnCount"] 	=	32,
			["SpawnTick"] 	=	1,
		},
		--
		[56] = {
			["SpawnCount"] 	=	5,
			["SpawnTick"] 	=	3.3,
		},
		[57] = {
			["SpawnCount"] 	=	42,
			["SpawnTick"] 	=	0.9,
		},
		[58] = {
			["SpawnCount"] 	=	46,
			["SpawnTick"] 	=	1,
		},
		[59] = {
			["SpawnCount"] 	=	55,
			["SpawnTick"] 	=	1,
		},
		[61] = {
			["SpawnCount"] 	=	65,
			["SpawnTick"] 	=	0.5,
		},
		[62] = {
			["SpawnCount"] 	=	32,
			["SpawnTick"] 	=	1,
		},
		[63] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.85,
		},
		[64] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.6,
		},
		[66] = {
			["SpawnCount"] 	=	75,
			["SpawnTick"] 	=	0.7,
		},
		[67] = {
			["SpawnCount"] 	=	39,
			["SpawnTick"] 	=	0.75,
		},
		[68] = {
			["SpawnCount"] 	=	32,
			["SpawnTick"] 	=	1,
		},
		[69] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	1,
		},
		[71] = {
			["SpawnCount"] 	=	48,
			["SpawnTick"] 	=	1,
		},
		[72] = {
			["SpawnCount"] 	=	44,
			["SpawnTick"] 	=	0.89,
		},
		[73] = {
			["SpawnCount"] 	=	51,
			["SpawnTick"] 	=	0.9,
		},
		[74] = {
			["SpawnCount"] 	=	47,
			["SpawnTick"] 	=	1,
		},
		[76] = {
			["SpawnCount"] 	=	80,
			["SpawnTick"] 	=	0.6,
		},
		[77] = {
			["SpawnCount"] 	=	10,
			["SpawnTick"] 	=	2.3,
		},
		[78] = {
			["SpawnCount"] 	=	45,
			["SpawnTick"] 	=	0.8,
		},
		[79] = {
			["SpawnCount"] 	=	15,
			["SpawnTick"] 	=	1.4,
		},
		['Special'] = {
			'npc_war_of_kings_special_chest', -- per 5 round
			{ -- per 15 round
				warrior = 'npc_war_of_Kings_special_boss_warrior',
				mage = 'npc_war_of_Kings_special_boss_mage',
				rogue = 'npc_war_of_Kings_special_boss_rogue',
				shaman = 'npc_war_of_Kings_special_boss_shaman',
				archer = 'npc_war_of_Kings_special_boss_archer',
				guardian = 'npc_war_of_Kings_special_boss_guardian',
			},
		},
	},
}

GODNESS_UNITS = {
   	'npc_war_of_Kings_special_boss_warrior',
    'npc_war_of_Kings_special_boss_mage',
    'npc_war_of_Kings_special_boss_rogue',
    'npc_war_of_Kings_special_boss_shaman',
    'npc_war_of_Kings_special_boss_archer',
    'npc_war_of_Kings_special_boss_guardian',
}

ENDLESS_MODEL_CREEP = {
	'models/courier/greevil/gold_greevil.vmdl','models/courier/gold_mega_greevil/gold_mega_greevil.vmdl','models/courier/frog/frog.vmdl',
	'models/courier/mechjaw/mechjaw.vmdl','models/courier/venoling/venoling.vmdl','models/items/courier/amphibian_kid/amphibian_kid.vmdl',
	'models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl','models/items/courier/bucktooth_jerry/bucktooth_jerry.vmdl',
	'models/items/courier/courier_mvp_redkita/courier_mvp_redkita_flying.vmdl','models/items/courier/courier_ti9/courier_ti9_lvl7/courier_ti9_lvl7.vmdl',
	'models/items/courier/d2l_steambear/d2l_steambear.vmdl','models/items/courier/gnomepig/gnomepig.vmdl','models/items/courier/grim_wolf_radiant/grim_wolf_radiant.vmdl',
	'models/items/courier/krobeling/krobeling.vmdl','models/items/courier/mole_messenger/mole_messenger_lvl5.vmdl','models/items/courier/nexon_turtle_11_blue/nexon_turtle_11_blue.vmdl',
	'models/items/courier/onibi_lvl_06/onibi_lvl_06_flying.vmdl','models/items/courier/onibi_lvl_20/onibi_lvl_20_flying.vmdl',
	'models/items/courier/shroomy/shroomy.vmdl','models/items/courier/snapjaw/snapjaw.vmdl',
}
