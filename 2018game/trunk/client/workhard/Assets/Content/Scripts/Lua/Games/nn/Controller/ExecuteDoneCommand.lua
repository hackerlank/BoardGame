--[[
  * COMMAND:: ExecuteDoneCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ExecuteDoneCommand = class('ExecuteDoneCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local game_proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function ExecuteDoneCommand:ctor()
    self.executed = false
end

--coding function in here
function ExecuteDoneCommand:execute(note)
    game_proxy:PopupCmd()
end

return ExecuteDoneCommand