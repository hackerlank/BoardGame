--[[
  * COMMAND:: VoteCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local VoteCommand = class('VoteCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function VoteCommand:ctor()
    self.executed = false
end

--coding function in here
function VoteCommand:execute(note)
    --UnityEngine.Debug.Log('VoteCommand')
    if note.body == nil then 
        LogError("VoteCommand:: miss parameter")
    end 

    local proxy_name = GetLuaGameManager().GetGameName() .. ".game_proxy"
    local proxy =  pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(proxy_name)
	proxy:VoteDismiss(note.body)
end

return VoteCommand