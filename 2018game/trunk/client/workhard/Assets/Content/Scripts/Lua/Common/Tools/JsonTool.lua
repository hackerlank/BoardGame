JsonTool =  {}
local json = require('cjson')

--[[
 * decode a string to a table.
 * @return a table instance object
]]
JsonTool.Decode = function(content)
    if content == nil or json == nil then 
        return {}
    end 

    if content == "" then 
        return {}
    end 
    return json.decode(content)
end 

--[[
 * encode a json table to a string object. so we can save it to file
 @ return a string
]]
JsonTool.Encode = function(jsonTable)
    if jsonTable == nil then 
        return ""
    end 

    if json == nil then 
        return ""
    end 

    return json.encode(jsonTable)
end 
