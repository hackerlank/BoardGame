--[[
  * COMMAND:: PlayerReadyCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PlayerReadyCommand = class('PlayerReadyCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function PlayerReadyCommand:ctor()
    self.executed = false
end

--coding function in here
function PlayerReadyCommand:execute(note)
    --UnityEngine.Debug.Log('PlayerReadyCommand')
    local proxy =  facade:retrieveProxy(nn.GAME_PROXY_NAME)
    facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
	proxy:PlayerReqReady()
end

return PlayerReadyCommand