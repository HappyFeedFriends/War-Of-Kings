

QUEST_DAILY_NO_USE_RUNES = 0
QUEST_DAILY_NO_DAMAGE = 1
QUEST_DAILY_ALIVE_ENDLESS_ROUND = 2
QUEST_DAILY_WIN_NO_UNIQUE = 3
QUEST_DAILY_WIN_HELL = 4
QUEST_DAILY_WIN_INPOSSIBLE = 5
QUEST_DAILY_GOLD_CHEST = 6

QUEST_FOR_BATTLE_KILL_COUNT = 0
QUEST_FOR_BATTLE_ALIVE_ROUND = 1
QUEST_FOR_BATTLE_KILL_GODNESS_BY_NAME = 2
QUEST_FOR_BATTLE_DAMAGE_CHEST = 3
QUEST_FOR_BATTLE_KILL_MINI_BOSS_COUNT = 4
QUEST_FOR_BATTLE_USE_XP_BOOK = 5
QUEST_FOR_BATTLE_SPEND_CRYSTAL = 6
QUEST_FOR_BATTLE_SPEND_GOLD = 7
QUEST_FOR_BATTLE_ROUND_PER_NO_DAMAGE = 8
QUEST_FOR_BATTLE_UPGRADE_TOWER_GRADE = 9
QUEST_FOR_BATTLE_REMOVE_SHIELD_ENEMY_COUNT = 10
--QUEST_FOR_BATTLE_HEALING_TOWER_ITEMS = 11

QUEST_DAILY_LAST = 4
QUEST_FOR_BATTLE_LAST = 10

QUEST_DAILY_COUNT = 2
QUEST_FOR_BATTLE_COUNT = 4
--QUEST_FOR_BATTLE_UPGRADE_TOWER_BY_ROUND = 5


QUEST_DATA = {
		[QUEST_FOR_BATTLE_KILL_COUNT] = {
			description = '#quest_kill_creep_count',
			drop = 'crystal | gold',
			gold = '600 - 1650',
			crystal = '60 - 550',
			count = '450 - 1500',
		},
		[QUEST_FOR_BATTLE_ALIVE_ROUND] = {
			description = '#quest_alive_round',
			drop = 'crystal | gold',
			gold = '200 - 2700',
			crystal = '10 - 650',
			count = '10 - 120',
		},
		[QUEST_FOR_BATTLE_KILL_GODNESS_BY_NAME] = {
			description = '#quest_kill_godness_by_name',
			drop = 'gold | card',
			gold = '4000 - 4000',
			card = {
				'item_card_war_of_kings_medusa',
				'item_card_war_of_kings_tidehunter',
				'item_card_war_of_kings_pugna',
				'item_card_war_of_kings_tusk',
				'item_card_war_of_kings_centaur_warruner',
			},
		},
		[QUEST_FOR_BATTLE_DAMAGE_CHEST] = {
			description = '#quest_damage_by_chest',
			drop = 'crystal',
			crystal = '10 - 800',
			count = '5500 - 1000000',
		},
		-- [QUEST_FOR_BATTLE_CRYSTAL_COUNT] = {
		-- 	description = '#quest_amount_crystal_for_game',
		-- 	drop = 'gold',
		-- 	gold = '250 - 2800',
		-- 	count = '450 - 1750',	
		-- },
		[QUEST_FOR_BATTLE_KILL_MINI_BOSS_COUNT] = {
			description = '#quest_kill_godness_count',
			drop = 'crystal',
			crystal = '100 - 660',
			count = '1 - 6'
		},
		[QUEST_FOR_BATTLE_USE_XP_BOOK] = {
			description = '#quest_use_xp_book_count',
			drop = 'crystal',
			crystal = '125 - 335',
			count = '25 - 45',		
		},
		[QUEST_FOR_BATTLE_SPEND_CRYSTAL] = {
			description = '#quest_spend_crystal_amount',
			drop = 'card',
			count = '1300 - 1300',
			card = {
				'item_card_war_of_kings_tiny',
				'item_card_war_of_kings_creep_bed',
				'item_card_war_of_kings_creep_good',
				'item_card_war_of_kings_tusk',
				'item_card_war_of_kings_sven',
			},	
		},
		[QUEST_FOR_BATTLE_SPEND_GOLD] = {
			description = '#quest_spend_gold_amount',
			drop = 'card',
			count = '50000 - 80000',
			card = {
				'item_card_war_of_kings_tiny',
				'item_card_war_of_kings_creep_bed',
				'item_card_war_of_kings_creep_good',
				'item_card_war_of_kings_tusk',
				'item_card_war_of_kings_sven',
			},	
		},
		[QUEST_FOR_BATTLE_ROUND_PER_NO_DAMAGE] = {
			description = '#quest_round_per_no_damage',
			drop = 'gold',
			gold = '1000 - 7000',
			count = '15 - 30',
			IsFailing = true,
		},
		[QUEST_FOR_BATTLE_UPGRADE_TOWER_GRADE] = {
			description = '#quest_upgrade_tower_grade',
			drop = 'gold',
			gold = '800 - 3200',
			count = '3 - 7',
		},
		[QUEST_FOR_BATTLE_REMOVE_SHIELD_ENEMY_COUNT] = {
			description = '#quest_remove_shield_count',
			drop = 'gold',
			gold = '670 - 2760',
			count = '15 - 45',	
		},
		-- [QUEST_FOR_BATTLE_HEALING_TOWER_ITEMS] = {
		-- 	description = '#quest_healing_tower',
		-- 	drop = 'crystal',
		-- 	crystal = '45 - 250',
		-- 	count = '1000 - 16000',			
		-- 	item = 'healing_flask_custom',
		-- },
}