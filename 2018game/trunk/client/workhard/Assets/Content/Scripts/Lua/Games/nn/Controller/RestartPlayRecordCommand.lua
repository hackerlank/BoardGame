--[[
  * COMMAND:: StartPlayRecordCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local StartPlayRecordCommand = class('StartPlayRecordCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function StartPlayRecordCommand:ctor()
    self.executed = false
end

--coding function in here
function StartPlayRecordCommand:execute(note)
    --UnityEngine.Debug.Log('StartPlayRecordCommand')
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    proxy:RestartRecord()
end

return StartPlayRecordCommand