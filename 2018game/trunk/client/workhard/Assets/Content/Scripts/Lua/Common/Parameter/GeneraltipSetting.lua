--[[
  * GeneraltipSetting class used to cache general tip  information.
  * the object will be treated as template not a real instance
  * object, that is created by depends function. Use all public 
  * interfaces to visit members.
  * use LevelInfo class like: 
  * local template = depends("Common.Parameters.GeneraltipSetting")
  * if nil ~= template then 
  *     local tmpInfo = template.new(tbKey, tbValue). 
  * end 
  *
]]

local tipSetting = class('GeneraltipSetting')

function tipSetting:ctor(tbKey, tbValue)
    tipSetting.id = -1
    tipSetting.title = ""
    tipSetting.content = ""
    tipSetting.text_sure = ""
    tipSetting.text_cancel = ""

    for k,v in ipairs(tbKey) do
        if v == "id" then 
            self.id = tonumber(tbValue[k])
        elseif v == "title" then 
            self.title = tbValue[k]
        elseif v == "content" then 
            self.content = tbValue[k]
        elseif v == "sure_text" then 
            self.sure_text = tbValue[k]
        elseif v== "cancel_text" then 
            self.cancel_text = tbValue[k] 
        end 
    end 

end 
function tipSetting:GetTipID()
    return self.id
end 

function tipSetting:GetTitle()
    return self.title
end 

function tipSetting:GetContent()
    return self.content
end 

function tipSetting:GetSureText()
    return self.sure_text
end 

function tipSetting:GetCancelText()
    return self.cancel_text
end 

function tipSetting:isEqual(obj)
    if self.id == obj:GetTipID() then 
        return true
    end
    return false
end 

function tipSetting:ToString()
    local t = {"ID=", self.id , " title=", self.title, " content=", self.content, " sure_text=", self.sure_text, " cancel_text=", self.cancel_text}
    return table.concat(t)
end 

return tipSetting