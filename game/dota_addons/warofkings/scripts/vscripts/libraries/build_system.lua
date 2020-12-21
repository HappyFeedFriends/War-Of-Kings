GRID_ALPHA = 25 -- Defines the transparency of the ghost squares (Panorama)
MODEL_ALPHA = 75 -- Defines the transparency of both the ghost model (Panorama) and Building Placed (Lua)
RECOLOR_GHOST_MODEL = true -- Whether to recolor the ghost model green/red or not
RECOLOR_BUILDING_PLACED = true -- Whether to recolor the queue of buildings placed (Lua)
BUILDING_SIZE = 3
BUILDING_ANGLE = -90

if BuildSystem == nil then
	BuildSystem = class({})
	BuildSystem.tPlayerBuildings = {}
end

function BuildSystem:init(bReload)
	if not bReload  then
		self.hBlockers = {}
		self.cardBuildingInfo = {}
		for cardName,data in pairs(card.AllCards) do
			self.cardBuildingInfo[cardName] = {
				attack_range = data.BaseStats.AttackRange,
				abilityName = string.gsub(cardName,'npc_','item_card_')
			}			
		end 
		CustomNetTables:SetTableValue("BuildSystem", "card_building_info", self.cardBuildingInfo)

		local building_disabled = Entities:FindAllByName("building_disabled")
		for k,v in pairs(building_disabled) do
			local origin = v:GetAbsOrigin()
			local angles = v:GetAngles()
			local bounds = v:GetBounds()
			local vMin = RotatePosition(Vector(0, 0, 0), angles, bounds.Mins)+origin
			local vMax = RotatePosition(Vector(0, 0, 0), angles, bounds.Maxs)+origin

			self:CreateBlocker({
				Vector(vMin.x, vMin.y, 0),
				Vector(vMax.x, vMin.y, 0),
				Vector(vMax.x, vMax.y, 0),
				Vector(vMin.x, vMax.y, 0),
			}, v)
		end
		self.tPlayerBuildings = {}
		PlayerResource:PlayerIterate(function(playerID)
			self.tPlayerBuildings[playerID] = {
					CardList = {},
			}
		end)
	end
	self:UpdateNetTables()
end

function BuildSystem:UpdateNetTables()
	CustomNetTables:SetTableValue("BuildSystem", "player_buildings", self.tPlayerBuildings)
end

function BuildSystem:IsBuilding(unit)
	return IsValid(unit) and unit.GetBuilding ~= nil
end

function BuildSystem:GetCountBuild(pID,fn)
	local value = 0
	BuildSystem:EachBuilding(pID, function(building)
		if fn then 
			value = value + (fn(building) and 1 or 0)
		else
			value = value + 1
		end
	end)
	return value	
end

function BuildSystem:FindBuildByName(pID,name)
	local data = {}
	BuildSystem:EachBuilding(pID, function(building)
		if building:GetUnitEntityName() == name then 
			table.insert(data,building)
		end
	end)
	return data
end

function BuildSystem:PlaceBuilding(hero, name, location, angle,cost)
	local playerID = hero:GetPlayerOwnerID()
	angle = angle or BUILDING_ANGLE
	local IsUpgrade = false
	local countBuilds = 0
	local countBonus = 0
	BuildSystem:EachBuilding(playerID, function(building)
		if building:GetUnitEntityName() == name and CARD_DATA.MAX_GRADE[building:GetRariry()]  and building.iGrade < CARD_DATA.MAX_GRADE[building:GetRariry()] then
			building:UpgradeBuilding()
			building.iGoldCost = building.iGoldCost + cost
			IsUpgrade = true
			return true
		end
		countBuilds = countBuilds + 1
	end)
	if IsUpgrade then return true end
	local max = CARD_DATA.MAX_CARD + countBonus
	if countBuilds >= max then
		DisplayError(playerID,'war_of_kings_hud_error_max_buildings')
		return false
	end
	local building = NewBuilding(name, location, angle, hero,cost)
	if name == 'npc_war_of_kings_devoloper' then
		return
	end
	local __Player = GetPlayerCustom(playerID)
	__Player:ModifyTowerAmount(max,'max',true)
	__Player:ModifyTowerAmount(1)
	table.insert(self.tPlayerBuildings[playerID].CardList, building:GetUnitEntityIndex())
	local nettables = CustomNetTables:GetTableValue('PlayerData', "player_" .. playerID)
	BuildSystem:EachBuilding(playerID, function(building)
		local hIsAssemblies = {}
		for k,v in pairs(card:GetDataCard(building:GetUnitEntityName()).Assemblies or {}) do
			hIsAssemblies[k] = card:IsAssemblyCard(building:GetUnitEntityName(),k,playerID)
		end
		nettables.BuildingsCardsindexID[tostring(building:GetUnitEntityIndex())].hIsAssemblies = hIsAssemblies
	end)
	CustomNetTables:SetTableValue("PlayerData", "player_" .. playerID, nettables)
	self:UpdateNetTables()
	if not hero:IsAlive() then
		self:RemoveBuilding(building)
	end
	return building
end


function BuildSystem:MoveBuilding( building, location )
	if not self:IsBuilding(building) then
		return
	end
	building = building:GetBuilding()

	return building:Move(location)
end

function BuildSystem:SellBuilding( building, fGoldReturn )
	if not self:IsBuilding(building) then
		return
	end
	building = building:GetBuilding()
	fGoldReturn = fGoldReturn or 0.5

	local iGoldCost = building:GetGoldCost()
	local iGoldReturn = math.floor(iGoldCost*fGoldReturn)
	local hOwner = building:GetOwner()
	local hBuilding = building:GetUnitEntity()
	local iPlayerID = hOwner:GetPlayerOwnerID()
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hBuilding, iGoldReturn, nil)

	local particleID = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particleID, 0, hBuilding:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particleID)
	
	EmitSoundOnLocationWithCaster(hBuilding:GetAbsOrigin(), "DOTA_Item.Sheepstick.Activate", hOwner)

	self:RemoveBuilding(building:GetUnitEntity())

	return iGoldReturn
end

function BuildSystem:RemoveBuilding( building )
	if not self:IsBuilding(building) then
		print('[BuildSystem] Not Building target')
		return
	end

	building = building:GetBuilding()
	local playerID = building:GetPlayerOwnerID()
	local xp = building:GetAllXp() / math.max(BuildSystem:GetCountBuild(playerID) - 1,1)
	local goldCost = building.iGoldCost > 0 and building.iGoldCost/2 or building.iGoldCost
	GetPlayerCustom(playerID):ModifyGold(goldCost,true)
	ArrayRemove(self.tPlayerBuildings[playerID].CardList, building:GetUnitEntityIndex())
	building:RemoveSelf()


	BuildSystem:EachBuilding(playerID,function(build)
		build:AddExperience(xp)
	end)
	self:UpdateNetTables()
end

function BuildSystem:ReplaceBuilding( building, sName )
	if not self:IsBuilding(building) then
		return
	end
	building = building:GetBuilding()
	local playerID = building:GetPlayerOwnerID()
	ArrayRemove(self.tPlayerBuildings[playerID].CardList, building:GetUnitEntityIndex())
	local hUnit = building:Replace(sName)
	table.insert(self.tPlayerBuildings[playerID].CardList, building:GetUnitEntityIndex())

	self:UpdateNetTables()

	return hUnit
end

function BuildSystem:ValidPosition(location,size)
	size = (size or BUILDING_SIZE)
	local halfSide = ((size-1)/2)*64
	local leftBorderX = location.x-halfSide
	local rightBorderX = location.x+halfSide
	local topBorderY = location.y+halfSide
	local bottomBorderY = location.y-halfSide
	for blockerEntIndex, blocker in pairs(self.hBlockers) do
		if IsPointInPolygon(location, blocker.polygon) or
		IsPointInPolygon(Vector(leftBorderX, bottomBorderY, 0), blocker.polygon) or
		IsPointInPolygon(Vector(rightBorderX, bottomBorderY, 0), blocker.polygon) or
		IsPointInPolygon(Vector(rightBorderX, topBorderY, 0), blocker.polygon) or
		IsPointInPolygon(Vector(leftBorderX, topBorderY, 0), blocker.polygon) then
			return false
		end
	end

	return true
end

function BuildSystem:GridNavSquare(location,size)
	size = size or BUILDING_SIZE
	SnapToGrid(size, location)

	local halfSide = (size/2)*64

	return {
		Vector(location.x-halfSide, location.y-halfSide, 0),
		Vector(location.x+halfSide, location.y-halfSide, 0),
		Vector(location.x+halfSide, location.y+halfSide, 0),
		Vector(location.x-halfSide, location.y+halfSide, 0),
	}
end

function BuildSystem:CreateBlocker(polygon, blocker)
	blocker = blocker or SpawnEntityFromTableSynchronous("info_target", {origin = Vector(0,0,0)})

	blocker.polygon = polygon
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), Polygon2D(polygon))
	self.hBlockers[blocker:entindex()] = blocker

	return blocker
end

function BuildSystem:RemoveBlocker(blocker)
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), nil)
	self.hBlockers[blocker:entindex()] = nil

	blocker:RemoveSelf()
end

function BuildSystem:GetBlockerPolygon(blocker)
	return blocker.polygon
end

function BuildSystem:SetBlockerPolygon(blocker, polygon)
	blocker.polygon = polygon
	CustomNetTables:SetTableValue("build_blocker", tostring(blocker:entindex()), Polygon2D(polygon))
end

function BuildSystem:EachBuilding(iPlayerID, func)
	if not iPlayerID then return end
	if not self.tPlayerBuildings[iPlayerID] then  return end
	for pID,dataPlayer in pairs(self.tPlayerBuildings[iPlayerID]) do
		for index,cardName in pairs(dataPlayer) do
			local hUnit = EntIndexToHScript(cardName)
			if IsValid(hUnit) and self:IsBuilding(hUnit) then
				if func(hUnit:GetBuilding()) then
					return
				end
			end
		end 
	end 
end


function Vector2D(vector)
	return {x=vector.x,y=vector.y}
end

function Polygon2D(polygon)
	local new = {}
	for k,v in pairs(polygon) do
		new[k] = Vector2D(v)
	end
	return new
end

function SnapToGrid( size, location )
	size = size or BUILDING_SIZE
	if size % 2 ~= 0 then
		location.x = SnapToGrid32(location.x)
		location.y = SnapToGrid32(location.y)
	else
		location.x = SnapToGrid64(location.x)
		location.y = SnapToGrid64(location.y)
	end
end

function SnapToGrid64(coord)
	return 64*math.floor(0.5+coord/64)
end

function SnapToGrid32(coord)
	return 32+64*math.floor(coord/64)
end

return BuildSystem