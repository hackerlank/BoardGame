--[[
  * COMMAND:: LeaveHallCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LeaveHallCommand = class('LeaveHallCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function LeaveHallCommand:ctor()
    self.executed = false
end

--coding function in here
function LeaveHallCommand:execute(note)
    --UnityEngine.Debug.Log('LeaveHallCommand')
    local facade =  pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
	proxy:LeaveHall()
end

return LeaveHallCommand