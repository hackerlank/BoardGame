--[[
  * LevelInfo class used to cache simple information of each level.
  * the object will be treated as template not a real instance
  * object, that is created by depends function. Use all public 
  * interfaces to visit members.
  * use LevelInfo class like: 
  * local template = depends("Common.Parameters.LevelInfo")
  * if nil ~= template then 
  *     local tmpInfo = template.new(tbKey, tbValue). 
  * end 
  *
]]
local levelInfo = class('LevelInfo')


--[[
  * this is default constructor of self. we will init all members in here
  * @param tbKey  the all keys of level information configuration file.
  * @param tbValue the all values of each level's property
]]
function levelInfo:ctor(tbKey, tbValue)
    self.levelName = ""
    self.G = ""
    self.D = ""
    self.L = ""
    self.GameMode = ""
    self.desc = ""

    if tbKey ~= nil and tbValue ~= nil then 
        for k,v in ipairs(tbKey) do
            if v == "G" then 
                self.G = tonumber(tbValue[k])
            elseif v == "D" then 
                self.D = tonumber(tbValue[k])
            elseif v == "L" then 
                self.L = tonumber(tbValue[k])
            elseif v == "GameMode" then 
                self.GameMode = tbValue[k]
            elseif v== "levelName" then 
                self.levelName = tbValue[k] 
            elseif v == "desc" then 
                self.desc = tbValue[k]
            end 
        end 
    end 
end 

function levelInfo:SetValues(name, G, D, L, gameMode)
    self.levelName = name
    self.G = G
    self.D = D
    self.L = L
    self.GameMode = gameMode
end 

--get level name
function levelInfo:getLevelName()
    return self.levelName
end 

function levelInfo:GetGDL()
    return self.G, self.D, self.L
end 

--whether is self
function levelInfo:isDGLEqual(G, D, L)
    return self.G == G and self.D == D and self.L == L
end 

--get game mode class path of level
function levelInfo:getGameMode()
    return self.GameMode
end 

--get description of level
function levelInfo:getDesc()
    return self.desc
end 

function levelInfo:isEqual(obj)
    if obj ~= nil then 
        if self.G == obj.G and self.D == obj.D and self.L == obj.L then 
            return true
        end 
    end 

    return false
end 

--to string 
function levelInfo:ToString()
    return "G=" .. self.G .. "\tD="..self.D .. "\tL=" .. self.L .. "\tGameMode=".. self.GameMode .. "\tLevelName=" .. self.levelName .. "\tdesc="..self.desc
end 

return levelInfo