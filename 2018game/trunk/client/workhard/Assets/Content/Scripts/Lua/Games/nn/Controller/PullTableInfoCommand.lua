--[[
  * COMMAND:: PullTableInfoCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PullTableInfoCommand = class('PullTableInfoCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function PullTableInfoCommand:ctor()
    self.executed = false
end

--coding function in here
function PullTableInfoCommand:execute(note)
    --UnityEngine.Debug.Log('PullTableInfoCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    proxy:PullTableInfo(note.body)
end

return PullTableInfoCommand