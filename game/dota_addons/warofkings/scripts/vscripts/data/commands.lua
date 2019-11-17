USUAL_ACCESS = 1
CHEAT_LOBBY_ACCESS = 2
DEV_ACCESS = 3
CHAT_COMMANDS =
{
	["BUY_CARD"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args,PlayerId)
			card:OnBuyCard({
				PlayerID = PlayerId,
				CardName = args or 'npc_war_of_kings_tusk',
			})
		end
	},	
	['GOLD'] = {
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args,PlayerId)
			local __Player = GetPlayerCustom(PlayerId)
			if __Player and args then 
				__Player:ModifyGold(args)
			end
		end	
	},
	["START_ROUND"] = 
	{
		ACCESS = DEV_ACCESS,
		funcs = function(args,PlayerId)
			round:StartRound()
		end
	},
	['CRYSTAL'] = {
		ACCESS = CHEAT_LOBBY_ACCESS,
		funcs = function(args,PlayerID)
			local __Player = GetPlayerCustom(PlayerID)
			__Player:ModifyCrystal(tonumber(args))
		end,
	},
}
