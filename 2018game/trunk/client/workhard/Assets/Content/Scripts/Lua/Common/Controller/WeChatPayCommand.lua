--[[
  * COMMAND:: WeChatPayCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local WeChatPayCommand = class('WeChatPayCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function WeChatPayCommand:ctor()
    self.executed = false
end

function WeChatPayCommand:execute(note)
    --UnityEngine.Debug.Log('WeChatPayCommand')
end

return WeChatPayCommand