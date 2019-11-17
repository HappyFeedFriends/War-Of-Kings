if not request then
	request = class({})
end
request.__http = 'http://f0345464.xsph.ru/'
request.__authKey = GetDedicatedServerKey("authKey")

function request:RequestData(typeReq,url,callback,data)
	data = json.encode({
		data = data,
		__authKey = self.__authKey,
	})
    local req = CreateHTTPRequestScriptVM(typeReq, request.__http .. url .. '.php')
	req:SetHTTPRequestGetOrPostParameter("Data", data )
	req:Send(function(get)
        if get.StatusCode ~= 200 then  
        	print("Error, Status code = ",get.StatusCode) 
        	return 
        end
        print('request response')
		local obj, pos, err = json.decode(get.Body)
		if not obj or type(obj) ~= "table" or obj == '' then 
			print("Error, object not found, obj = '" .. tostring(obj) .. "' type = ",type(obj))
			PrintTable(get) 
			return 
		end
        if callback and obj and type(obj) == "table" then
			callback(obj)
        end
    end)
end



