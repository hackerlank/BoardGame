local AllGamesInfo = class('AllGamesInfo')


function AllGamesInfo:ctor(tbKey, tbValue)
    self.id = nil
    self.Name = nil
    self.IconPath = nil
    self.Type = nil
    self.MenuName = nil 
    self.HallType = nil 
    for k,v in ipairs(tbKey) do
        if v == "id" then 
            self.id = tonumber(tbValue[k])
        elseif v == "Name" then 
            self.Name = tbValue[k]
        elseif v == "IconPath" then 
            self.IconPath = tbValue[k]
        elseif v == "Type" then
            self.Type = tonumber(tbValue[k])
        elseif v == "MenuName" then 
            self.MenuName = tbValue[k]
        elseif v == "HallType" then 
            self.HallType = tbValue[k]
        end 
    end 

    if self.MenuName ~= nil then 
        self.MenuOpenParam = ci.GetUiParameterBase().new(self.MenuName, EMenuType.EMT_Common, nil, false)
    end 
end 

function AllGamesInfo:GetGameName()
    return self.Name
end 

function AllGamesInfo:GetGameIconPath()
    return self.IconPath
end 

function AllGamesInfo:GetGameId()
    return self.id
end 

function AllGamesInfo:GetGameType()
    return self.Type
end

function AllGamesInfo:isEqual(obj)
    return id == obj:GetGameId()
end 

function AllGamesInfo:GetMenuOpenParam()
    return self.MenuOpenParam
end 

function AllGamesInfo:GetHallType()
    return self.HallType
end 

function AllGamesInfo:ToString()
    local t = {self.id, self.Name, self.IconPath, self.Type}
    return  table.concat(t)
end 

return AllGamesInfo