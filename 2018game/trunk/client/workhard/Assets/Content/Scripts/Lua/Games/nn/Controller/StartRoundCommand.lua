--[[
  * COMMAND:: StartRoundCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local StartRoundCommand = class('StartRoundCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function StartRoundCommand:ctor()
    self.executed = false
end

--coding function in here
function StartRoundCommand:execute(note)
    --UnityEngine.Debug.Log('StartRoundCommand')
    facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
    local proxy =  pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(nn.GAME_PROXY_NAME)
	proxy:PlayerReqStartRound()
end

return StartRoundCommand