function GameMode:FiltersOn()
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'ExecuteOrderFilter'), self )
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'DamageFilter'), self)
	--GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( GameMode, "HealingFilter" ), self )
	-- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, 'ModifyGoldFilter'), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, 'ModifyModifierFilter'), self)
	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(GameMode, 'AbilityTurning'), self)
end
function GameMode:ModifyModifierFilter(data)
	if data.entindex_ability_const and data.entindex_caster_const and data.entindex_parent_const then
		local ability = EntIndexToHScript(data.entindex_ability_const)
		local caster = EntIndexToHScript(data.entindex_caster_const)
		local target  = EntIndexToHScript(data.entindex_parent_const)
		if target:IsRealHero() and not DATA_USABLE_MODIFEIRS[data.name_const] then return false end
		local name = data.name_const
		local dataCard = card:GetDataCard(caster:GetUnitName())
		if dataCard and dataCard.Assemblies and caster.GetOwner and caster:GetOwner() then
			if name == "modifier_gyrocopter_rocket_barrage" and card:IsAssemblyCard(caster:GetUnitName(),'gyrocopter_upgrade_1',caster:GetOwner():GetPlayerID()) then
				data.duration = data.duration + dataCard.Assemblies['gyrocopter_upgrade_1'].data.value
			end
		end
	end
	return true
end

function GameMode:ModifyGoldFilter(data)
	local id = data.player_id_const
	local __Player = GetPlayerCustom(id)
	if data.gold > 0 then
		__Player:ModifyAllGold(data.gold,id)
	end
	if data.gold < 0 then 
		__Player:UpdateQuest(QUEST_FOR_BATTLE_SPEND_GOLD,-data.gold)
	end
	return true
end

function GameMode:AbilityTurning(data)
	local ability = EntIndexToHScript(data.entindex_ability_const)
	local value = data.value
	local keyName = data.value_name_const
	local caster = EntIndexToHScript(data.entindex_caster_const)
	local dataCard = card:GetDataCard(caster:GetUnitName())
	if dataCard and dataCard.Assemblies and caster.GetOwner and caster:GetOwner() then
		for k,v in pairs(dataCard.Assemblies) do
			local isAssembly = caster:IsAssembly(k) --card:IsAssemblyCard(caster:GetUnitName(),k,caster:GetOwner():GetPlayerID())
			if isAssembly and CARD_KEY_SWAP[k] and (CARD_KEY_SWAP[k].key_swap == keyName 
				or CARD_KEY_SWAP[k].key_swap_multiply == keyName 
				or CARD_KEY_SWAP[k].key_swap_set == keyName
				or CARD_KEY_SWAP[k].key_swap_dec == keyName) then
				data.value =  CARD_KEY_SWAP[k].key_swap_multiply and data.value * (dataCard.Assemblies[k].data.value) or 
				CARD_KEY_SWAP[k].key_swap_set and dataCard.Assemblies[k].data.value or
				CARD_KEY_SWAP[k].key_swap_dec and  data.value - dataCard.Assemblies[k].data.value or
				data.value + (dataCard.Assemblies[k].data.value)
				-- print(keyName,value,'==>',data.value)
				return true
			end
		end
	end
	return false
end

function GameMode:ExecuteOrderFilter(filterTable)
	local order_type = filterTable.order_type
	local unit
	if filterTable.units["0"] then
		unit = EntIndexToHScript(filterTable.units["0"])
	else
		return true
	end
	local playerId = filterTable.issuer_player_id_const
	local target = EntIndexToHScript(filterTable.entindex_target)
	local ability = EntIndexToHScript(filterTable.entindex_ability)
	local dataCard = card:GetDataCard(unit:GetUnitName())
	local abilityname
	if ability and ability.GetAbilityName then
		abilityname = ability:GetAbilityName()
	end
	if order_type == DOTA_UNIT_ORDER_CAST_TARGET or
		order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE or
		order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		if card:IsAssemblyCard(unit:GetUnitName(),'zeus_upgrade_1',playerId) then
			local radius = dataCard.Assemblies['zeus_upgrade_1'].data.radius
			local dur = dataCard.Assemblies['zeus_upgrade_1'].data.value
			local units = FindUnitsInRadius(unit:GetTeamNumber(),
			unit:GetOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false)
			for k,v in pairs(units) do
				v:AddNewModifier(unit, nil, 'modifier_stunned', {duration = dur})
			end
		end
	end
	if order_type == DOTA_UNIT_ORDER_SELL_ITEM and ability and unit then 
		CustomShop:SellItem(playerId, unit, ability)
	end
	-- if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM and ability and unit then 
	-- 	if unit.GetBuilding and not CustomShop:IsAccesitemByUnit(playerId,abilityname,target) then 
	-- 		DisplayError(playerId,'#dota_hud_error_item_not_available')
	-- 		return false
	-- 	end
	-- end
	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM and ability and unit and abilityname then 
		if target.GetBuilding and UnitVarToPlayerID(target) ~= playerId then return false end
		if not CustomShop:IsAccesitemByUnit(playerId,abilityname,target) then
			DisplayError(playerId,'#dota_hud_error_item_not_available')
			return false
		end
		local item = target:AddItemByName(abilityname)
		if ability:IsStackable() then 
			local chargesRate = ability:GetCurrentCharges() / ability:GetInitialCharges()
			item:SetCurrentCharges(chargesRate)
		end
		ability:RemoveSelf()
		return false
	end

	return true
end

function GameMode:HealingFilter( data )
	local target = EntIndexToHScript(data.entindex_target_const)
	if target:IsRealHero() then
		
	end 
	return true
end

function GameMode:DamageFilter(filterDamage)
-- Fix Swap Hero

		local attacker = filterDamage.entindex_attacker_const and EntIndexToHScript(filterDamage.entindex_attacker_const) 
		if not attacker then return true end 
		local ability,abilityName
		local victim = EntIndexToHScript(filterDamage.entindex_victim_const)
		local typeDamage = filterDamage.damagetype_const
		local dataCard = card:GetDataCard(attacker:GetUnitName())
		if filterDamage.entindex_inflictor_const then
			ability = EntIndexToHScript(filterDamage.entindex_inflictor_const )
			if ability and ability.GetAbilityName and ability:GetAbilityName() then
				abilityName = ability:GetAbilityName()
			end
		end
		local allModifiers =  victim:FindAllModifiers()
		if typeDamage == DAMAGE_TYPE_MAGICAL and filterDamage.damage > 0 then 
			for k,v in pairs(allModifiers) do
				if v.GetMagicalCriticalDamage and v.GetMagicalCriticalChance and RollPercentage(v.GetMagicalCriticalChance(v)) then 
					filterDamage.damage = (filterDamage.damage*v.GetMagicalCriticalDamage(v)/100 )
					break
				end
			end
		end
		if  attacker.GetOwner and attacker:GetOwner() and attacker:GetOwner().GetPlayerID and card:IsAssemblyCard(attacker:GetUnitName(),'phantom_assasin_upgrade_3',attacker:GetOwner():GetPlayerID()) and RollPercentage(dataCard.Assemblies['phantom_assasin_upgrade_3'].data.value_chance) then
			filterDamage.damage = filterDamage.damage * dataCard.Assemblies['phantom_assasin_upgrade_3'].data.value
		end
		if attacker:HasModifier('modifier_mars_gods_rebuke_crit') and attacker.GetOwner and attacker:GetOwner() and card:IsAssemblyCard(attacker:GetUnitName(),'mars_upgrade_1',attacker:GetOwner():GetPlayerID()) then
			victim:AddNewModifier(attacker, ability, 'modifier_stunned', {duration = dataCard.Assemblies['mars_upgrade_1'].data.value})
		end
		if ability and abilityName then
			if abilityName == "shadow_shaman_ether_shock" and attacker.GetOwner and attacker:GetOwner() then
				if card:IsAssemblyCard(attacker:GetUnitName(),'shaman_upgrade_2',attacker:GetOwner():GetPlayerID()) then
					filterDamage.damage = filterDamage.damage * dataCard.Assemblies['shaman_upgrade_2'].data.value
				end
				if card:IsAssemblyCard(attacker:GetUnitName(),'shaman_upgrade_3',attacker:GetOwner():GetPlayerID()) then
					victim:AddNewModifier(attacker, ability, 'modifier_stunned', {duration = dataCard.Assemblies['shaman_upgrade_3'].data.value})
				end
			end
			--[[if filterDamage.damage > 0 and attacker:FindAbilityByName('obsidian_destroyer_equilibrium') and attacker:HasModifier('modifier_obsidian_destroyer_equilibrium') then
				local IsActive = attacker:HasModifier('modifier_obsidian_destroyer_equilibrium_active') 
				local regen = attacker:FindAbilityByName('obsidian_destroyer_equilibrium'):GetSpecialValueFor(IsActive and 'mana_steal_active' or 'mana_steal')
				attacker:GiveMana(filterDamage.damage / 100 * regen)
			end]]
			if attacker.GetOwner and attacker:GetOwner() and card:IsAssemblyCard(attacker:GetUnitName(),'tidehunter_upgrade_2',attacker:GetOwner():GetPlayerID()) then
				filterDamage.damage = filterDamage.damage + dataCard.Assemblies['tidehunter_upgrade_2'].data.value
			end
			if attacker.GetOwner and attacker:GetOwner() and card:IsAssemblyCard(attacker:GetUnitName(),'tidehunter_upgrade_2',attacker:GetOwner():GetPlayerID()) then
				filterDamage.damage = filterDamage.damage + dataCard.Assemblies['tidehunter_upgrade_2'].data.value
			end
		end
		if attacker.GetOwner and attacker:GetOwner() and attacker:GetOwner().GetPlayerID then
			BuildSystem:EachBuilding(attacker:GetOwner():GetPlayerID(),function(building)
				if building:IsGodness('warrior') then
					filterDamage.damage = filterDamage.damage + (filterDamage.damage  / 100 * CLASS_DATA.warrior.special_bonus)
				end
			end)
		end
		if attacker:HasItemInInventory('item_aether_lens_3') and typeDamage == DAMAGE_TYPE_MAGICAL then
			local item = attacker:FindItemInInventory('item_aether_lens_3')
			local purify = item:GetSpecialValueFor('magical_purify')
			ApplyDamage({
				victim = victim,
				attacker = attacker,
				damage_type = DAMAGE_TYPE_PURE,
				ability = item,
				damage = filterDamage.damage * (purify/100),
			})
		end
		if typeDamage == DAMAGE_TYPE_MAGICAL then
			local penetration = attacker:GetMagicalPenetration()
			if penetration > 0 then
				ApplyDamage({
					victim = victim,
					attacker = attacker,
					damage_type = DAMAGE_TYPE_PURE,
					ability = ability,
					damage = filterDamage.damage * (penetration/100),
				})
			end
		end
		if attacker:HasModifier('modifier_unique_aura_physical_buff') then
			if  typeDamage == DAMAGE_TYPE_PHYSICAL then
				filterDamage.damage = filterDamage.damage * 2
			end
			if  typeDamage == DAMAGE_TYPE_MAGICAL then
				filterDamage.damage = filterDamage.damage - (filterDamage.damage * 0.6)
			end
		end
		if attacker:HasModifier('modifier_unique_aura_magical_buff') then
			if  typeDamage == DAMAGE_TYPE_PHYSICAL then
				filterDamage.damage = filterDamage.damage - (filterDamage.damage * 0.6)
			end
			if  typeDamage == DAMAGE_TYPE_MAGICAL then
				filterDamage.damage = filterDamage.damage + (filterDamage.damage * 0.4)
			end
		end
		if filterDamage.damage > 0 and BuildSystem:IsBuilding(attacker) and not attacker:IsNull() and attacker:IsAlive()  then
			attacker:GetBuilding():ModifyTotalDamage(filterDamage.damage)
		end
		if victim:HasModifier('modifier_shield') then
			local shield = victim:FindModifierByName('modifier_shield')
			local shieldCount = shield:GetStackCount()
			local damage_start = filterDamage.damage
			shield:SetStackCount(math.max(shieldCount - filterDamage.damage,0))
			filterDamage.damage = math.max(filterDamage.damage - shieldCount,0)
			if shield:GetStackCount() < 1 then
				for k,v in pairs( allModifiers ) do
					if v.OnShieldRemove then
						v:OnShieldRemove({ -- custom event modifier
							hAttacker = attacker,
							iShieldOld = shieldCount,
							fDamage_end = filterDamage.damage,
							fDamage_start = damage_start,
							iDamage_type = typeDamage,
							hModifier = shield,
						})
					end
				end
				if attacker and attacker.GetBuilding then 
					local __Player = GetPlayerCustom(attacker:GetBuilding():GetPlayerOwnerID())
					__Player:UpdateQuest(QUEST_FOR_BATTLE_REMOVE_SHIELD_ENEMY_COUNT,1)
				end
				shield:Destroy()
			end
		end
		if victim.playerRound and attacker and attacker.GetOwner and attacker:GetOwner() and attacker:GetOwner().GetPlayerID and victim.GoldDropPercentage then
			local bonusHealth = filterDamage.damage * victim.GoldDropPercentage
			local maxMana = victim:GetMaxMana()
			local maxhealth = victim:GetMaxHealth()
			local __Player = GetPlayerCustom(victim.playerRound)
			victim:SetBaseMaxHealth(maxhealth+bonusHealth)
			victim:SetMaxHealth(maxhealth+bonusHealth)
			victim:SetHealth(maxhealth+bonusHealth)
			__Player:ModifyDamageChest(filterDamage.damage)
			filterDamage.damage = 0
		end
		if victim:GetHealth() - filterDamage.damage < 1 then
			for k,v in pairs(victim:FindAllModifiers() ) do
				if v.OnFatalDamage then
					v:OnFatalDamage({ -- custom event modifier
						hAttacker = attacker,
						fDamage = filterDamage.damage,
						iDamage_type = typeDamage,
					})
				end
			end
		end
		if victim:HasModifier('modifier_ability_creep_blocked_attacks') and filterDamage.damage > 40 then 
			victim:AddStackModifier({
				modifier = 'modifier_ability_creep_blocked_attacks',
				count = -1,
				caster = victim,
			})
		end
		--filterDamage.damage = 0
	return true
end

