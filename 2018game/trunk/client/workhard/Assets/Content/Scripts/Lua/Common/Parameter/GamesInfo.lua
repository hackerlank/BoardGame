local GamesInfo = class('GamesInfo')


function GamesInfo:ctor(tbKey, tbValue)
    self.id = nil
    self.showName = nil
    self.IconPath = nil
    self.NameIcon = nil 
    self.CardIcon = nil 
    self.BGIcon = nil 
    self.Type = nil
    self.MenuName = nil 
    self.HallType = nil 
    for k,v in ipairs(tbKey) do
        if v == "id" then 
            self.id = tonumber(tbValue[k])
        elseif v == "showname" then 
            self.showName = tbValue[k]
        elseif v == "IconPath" then 
            self.IconPath = tbValue[k]
        elseif v == "NameIcon" then 
            self.NameIcon = tbValue[k]
        elseif v == "CardIcon" then 
            self.CardIcon = tbValue[k]
        elseif v == "BGIcon" then 
            self.BGIcon = tbValue[k]
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

--desc
function GamesInfo:GetGameShowName()
    return self.showName
end 

function GamesInfo:GetGameIconPath()
    return self.IconPath
end 

function GamesInfo:GetNameIconPath()
    return self.NameIcon
end 

function GamesInfo:GetCardIconPath()
    return self.CardIcon
end 

function GamesInfo:GetBGIconPath()
    return self.BGIcon
end 


function GamesInfo:GetGameId()
    return self.id
end 

function GamesInfo:GetGameType()
    return self.Type
end

function GamesInfo:isEqual(obj)
    return id == obj:GetGameId()
end 

function GamesInfo:GetMenuOpenParam()
    return self.MenuOpenParam
end 

function GamesInfo:GetHallType()
    return self.HallType
end 

function GamesInfo:ToString()
    local t = {self.id, self.Name, self.IconPath, self.Type}
    return  table.concat(t)
end 

return GamesInfo