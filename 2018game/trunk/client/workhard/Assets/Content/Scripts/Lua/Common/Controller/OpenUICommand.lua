--[[
  * COMMAND:: open ui command. 
  *   used to open one user interface. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.OPEN_UI_COMMAND,note)
  *   Warning:: note can not be nil 
]]
local OpenUICommand = class('OpenUICommand', pm.SimpleCommand)


function OpenUICommand:ctor()
    self.executed = false
end

function OpenUICommand:execute(note)
    if note.body == nil then 
        UnityEngine.Debug.LogError("[OpenUICommand]:: Miss open ui parameters. will return......")
        return
    end 
    UIManager.getInstance():Open(note.body)
    
end

return OpenUICommand