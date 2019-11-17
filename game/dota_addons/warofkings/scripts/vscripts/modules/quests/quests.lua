quest = class({})
ModuleRequire(...,'data')

function quest:GenerationQuest(iEnum)
	local returnData = {}
	local ValueCount = 1
	local valueBonus
	local data = QUEST_DATA[iEnum]
	if not data then 
		print('[Quest] Generation Quest error, enum = ' .. iEnum .. ' not found')
		return {error = 'Generation Quest error, enum = ' .. iEnum .. ' not found'}
	end
	local dropBonus = string.split(data.drop,' | ')
	dropBonus = dropBonus[RandomInt(1,#dropBonus)]
	if iEnum == QUEST_FOR_BATTLE_KILL_GODNESS_BY_NAME then
		returnData.sTarget = GODNESS_UNITS[RandomInt(1,#GODNESS_UNITS)]
	end
	if iEnum == QUEST_FOR_BATTLE_HEALING_TOWER_ITEMS then
		returnData.sItem =  data.item
	end
	if data[dropBonus] then
		if type(data[dropBonus]) == 'string' then
			local valueObj = string.split(data[dropBonus]:gsub('%s+',''),'-') 
			local minValue = tonumber(valueObj[1])
			local maxValue = tonumber(valueObj[2]) 
			local countObj = string.split((data.count or '1 - 1'):gsub('%s+',''),'-')
			local minValueCount,maxValueCount = tonumber(countObj[1]),tonumber(countObj[2])
			ValueCount = tostring(RandomInt(minValueCount,maxValueCount))
			if #ValueCount > 1 and tonumber(ValueCount:sub(#ValueCount,#ValueCount)) % 5 ~= 0 then
				ValueCount = ValueCount:sub(1,-2)..'0'
			end
			ValueCount = math.max(tonumber(ValueCount),minValueCount)
			local pct = ((ValueCount - minValueCount)/math.max(maxValueCount - minValueCount,1) )
			valueBonus = math.floor(((maxValue - minValue) * pct) + minValue)
		else
			local valueObj = data[dropBonus]
			local countObj = string.split((data.count or '1 - 1'):gsub('%s+',''),'-')
			local minValueCount,maxValueCount = tonumber(countObj[1]),tonumber(countObj[2])
			ValueCount = tostring(RandomInt(minValueCount,maxValueCount))
			if #ValueCount > 1 and tonumber(ValueCount:sub(#ValueCount,#ValueCount)) % 5 ~= 0 then
				ValueCount = ValueCount:sub(1,-2)..'0'
			end
			ValueCount = math.max(tonumber(ValueCount),minValueCount)
		end
	end
	if dropBonus == 'card' then
		returnData.aValueDropSucces = data.card[RandomInt(1,#data.card)]
	else
		returnData.aValueDropSucces = valueBonus
	end
 	returnData.sDropType = dropBonus
 	returnData.sDescription = data.description
 	returnData.tQuestProgress = {
	 	iValue = 0,
	 	iMaxValue = ValueCount,
	 	bSucces = false,
	 	bLose = false,
	}
 	return returnData
end

function quest:GenerationAllQuest(pID)
	local __Player = GetPlayerCustom(pID)
	local DonateType = __Player.bSub
	local data = {}
	local countQuest = QUEST_FOR_BATTLE_COUNT + (tonumber(DonateType) > 0 and 3 or 0)
	local count = QUEST_FOR_BATTLE_LAST
	local RandomQuestEnum = function()
		local enum = RandomInt(0,count)
		while data[enum] do
			enum = RandomInt(0,count)
		end
		return enum
	end
	for i=1,countQuest do
		local randomEnumQuest = RandomQuestEnum()
		data[randomEnumQuest] = quest:GenerationQuest(randomEnumQuest)
	end
	return data
end
