--[[
  * COMMAND:: close ui command. 
  *   used to close one user interface. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.CLOSE_UI_COMMAND,note)
  *   Warning:: note can not be nil 
]]

local CloseUICommand = class('CloseUICommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError

function CloseUICommand:ctor()
    self.executed = false
end

function CloseUICommand:execute(note)
    if note.body == nil then 
        LogError("[CloseUICommand]:: Miss close ui parameters. will return......")
        return
    end 
    UIManager.getInstance():Close(note.body:IsDisable(), note.body:GetWindowName())
end

return CloseUICommand