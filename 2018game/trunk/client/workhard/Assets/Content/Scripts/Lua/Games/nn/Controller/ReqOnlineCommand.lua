--[[
  * COMMAND:: ReqOnlineRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ReqOnlineCommand = class('ReqOnlineCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function ReqOnlineCommand:ctor()
    self.executed = false
   
end

--coding function in here
function ReqOnlineCommand:execute(note)
    UnityEngine.Debug.Log('ReqOnlineCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    if proxy:IsJoinedGame() == false then 
        facade:sendNotification(nn.PLAYER_PULL_TABLE_INFO, EOperation.EO_ReqOnline)
    else 
        print("real req online")
        proxy:PlayerReqOnline()
    end 
end

return ReqOnlineCommand