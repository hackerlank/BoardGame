--[[
  * COMMAND:: PreJoinGameCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PreJoinGameCommand = class('PreJoinGameCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function PreJoinGameCommand:ctor()
    self.executed = false
end

--coding function in here
function PreJoinGameCommand:execute(note)
    --UnityEngine.Debug.Log('PreJoinGameCommand')
    if note.body == nil then 
        LogError("invalid room id")
        return 
    end 
    GetLuaGameManager().ClearClipboardRoomId()

    local id = tonumber(note.body)
    local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
    proxy:QueryGameHall(id)
end

return PreJoinGameCommand