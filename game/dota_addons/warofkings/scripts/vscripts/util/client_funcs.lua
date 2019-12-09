function CDOTA_Buff:SetSharedKey(key, value)
	local t = CustomNetTables:GetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName()) or {}
	t[key] = value
	CustomNetTables:SetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName(), t)
end

function CDOTA_Buff:GetSharedKey(key)
	local t = CustomNetTables:GetTableValue("modifiers_value", self:GetParent():GetEntityIndex() .. "_" .. self:GetName()) or {}
	return t[key]
end

modifier_attribute_all_base = {}


function table.merge_copy(input1,input2)
	local _input1 = {}
	local _input2 = {}

	for k,v in pairs(input1) do
		_input1[k] = v
	end

	for k,v in pairs(input2) do
		_input2[k] = v
	end
	table.merge(_input1,_input2)
	return _input1
end

function table.merge(input1, input2)
	for i,v in pairs(input2) do
		input1[i] = v
	end
end

