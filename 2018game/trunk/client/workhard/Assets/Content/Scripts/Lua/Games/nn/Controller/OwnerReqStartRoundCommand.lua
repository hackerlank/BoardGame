--[[
  * COMMAND:: OwnerReqStartRoundCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local OwnerReqStartRoundCommand = class('OwnerReqStartRoundCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--replace nn with xxx
local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function OwnerReqStartRoundCommand:ctor()
    self.executed = false
end

--coding function in here
function OwnerReqStartRoundCommand:execute(note)
    --Log('OwnerReqStartRoundCommand')
    if game_proxy then 
        game_proxy:OwnerReqStartRound()
    end 
end

return OwnerReqStartRoundCommand