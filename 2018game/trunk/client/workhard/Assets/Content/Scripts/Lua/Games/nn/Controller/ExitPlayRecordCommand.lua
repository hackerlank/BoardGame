--[[
  * COMMAND:: ExitPlayRecordCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ExitPlayRecordCommand = class('ExitPlayRecordCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function ExitPlayRecordCommand:ctor()
    self.executed = false
end

--coding function in here
function ExitPlayRecordCommand:execute(note)
    --UnityEngine.Debug.Log('ExitPlayRecordCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
end

return ExitPlayRecordCommand