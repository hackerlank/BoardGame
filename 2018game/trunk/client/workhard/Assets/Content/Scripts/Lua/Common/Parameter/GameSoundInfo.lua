local GameSoundInfo = class('GameSoundInfo')


function GameSoundInfo:ctor(tbKey, tbValue)
    self.id = nil
    self.soundPath = nil
    self.desc = nil
    for k,v in ipairs(tbKey) do
        if v == "id" then 
            self.id = tonumber(tbValue[k])
        elseif v == "soundPath" then 
            self.soundPath = tbValue[k]
        elseif v == "desc" then 
            self.desc = tbValue[k]
        end 
    end 
end 

function GameSoundInfo:GetSoundPath()
    return self.soundPath
end 

function GameSoundInfo:GetDesc()
    return self.desc
end 

function GameSoundInfo:GetSoundId()
    return self.id
end 

function GameSoundInfo:isEqual(obj)
    return id == obj:GetSoundId()
end 

function GameSoundInfo:ToString()
    local t = {"id=", self.id, " soundPath=", self.soundPath, " desc=", self.desc}
    return table.concat(t)
end 
return GameSoundInfo