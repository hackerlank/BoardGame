--[[
  * COMMAND:: StartGameCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local StartGameCommand = class('StartGameCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function StartGameCommand:ctor()
    self.executed = false
end

--coding function in here
function StartGameCommand:execute(note)
    --UnityEngine.Debug.Log('StartGameCommand')
    local proxy =  pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(nn.GAME_PROXY_NAME)
	proxy:PlayerReqStartGame()
end

return StartGameCommand