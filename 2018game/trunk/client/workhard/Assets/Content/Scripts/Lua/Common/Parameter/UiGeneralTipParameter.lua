--[[
  * CLASS UiGeneralTipParameter has defined basic parameter which used to open user interface.
  *
  * @UI_PREFAB_ROOT the root path of all ui prefabs. do not reset it
  *
  * @UI_NAME the user interface name. reset it in subclass
  *
]]
local UiGeneralTipParameter = class('UiGeneralTipParameter',ci.GetUiParameterBase().new(nil,nil,nil))

UiGeneralTipParameter.tipId = -1

UiGeneralTipParameter.yesCallback = nil

UiGeneralTipParameter.cancelCallback = nil

function UiGeneralTipParameter:ctor(name,inMenuType, inParent, inId, inYes, inNo, content)
    self.super:ctor(name,inMenuType,inParent)
    self.tipId = inId
    self.yesCallback=inYes
    self.cancelCallback = inNo
    self.bGeneralTip = true
    self.content = content
    self.bAutoClose = bAutoClose or true
end 

function UiGeneralTipParameter:GetSureCallback()
    return self.yesCallback
end 

function UiGeneralTipParameter:GetCancelCallback()
    return self.cancelCallback
end 

function UiGeneralTipParameter:GetTipID()
    return self.tipId
end 

function UiGeneralTipParameter:GetContent()
    return self.content
end 

function UiGeneralTipParameter:SetContent(content)
    self.content = content
end

return UiGeneralTipParameter