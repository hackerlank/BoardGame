--[[
  * COMMAND:: GameShuffledCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GameShuffledCommand = class('GameShuffledCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function GameShuffledCommand:ctor()
    self.executed = false
end

--coding function in here
function GameShuffledCommand:execute(note)
    --UnityEngine.Debug.Log('GameShuffledCommand')
    local proxy_name = GetLuaGameManager().GetGameName() .. ".game_proxy"
    local proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(proxy_name)
    if proxy then 
        proxy:GameShuffled()
    end 
end

return GameShuffledCommand