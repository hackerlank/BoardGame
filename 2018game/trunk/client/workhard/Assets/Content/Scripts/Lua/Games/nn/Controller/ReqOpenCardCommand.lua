--[[
  * COMMAND:: ReqOpenCardCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ReqOpenCardCommand = class('ReqOpenCardCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--replace nn with xxx
local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function ReqOpenCardCommand:ctor()
    self.executed = false
end

--coding function in here
function ReqOpenCardCommand:execute(note)
    --Log('ReqOpenCardCommand')
    if game_proxy then 
        game_proxy:ReqOpenCard()
    end 
end

return ReqOpenCardCommand