--[[
  * COMMAND:: LogoutCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LogoutCommand = class('LogoutCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function LogoutCommand:ctor()
    self.executed = false
end

--coding function in here
function LogoutCommand:execute(note)
    --UnityEngine.Debug.Log('LogoutCommand')
    local proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    proxy:Logout()
end

return LogoutCommand