--[[
  * CLASS UiParameterBase has defined basic parameter which used to open user interface.
  *
  * @UI_PREFAB_ROOT the root path of all ui prefabs. do not reset it
  *
  * @UI_NAME the user interface name. reset it in subclass
  *
]]
local UICloseParam = class('UICloseParam')

function UICloseParam:ctor(bDisable, windowName)
  self.bDisable = bDisable
  self.windowName = windowName
end 

function UICloseParam:IsDisable()
  return self.bDisable
end

function UICloseParam:GetWindowName()
  return self.windowName
end 

return UICloseParam