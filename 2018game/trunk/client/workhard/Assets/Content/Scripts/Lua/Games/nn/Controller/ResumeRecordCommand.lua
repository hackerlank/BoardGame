--[[
  * COMMAND:: ResumeRecordCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ResumeRecordCommand = class('ResumeRecordCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function ResumeRecordCommand:ctor()
    self.executed = false
end

--coding function in here
function ResumeRecordCommand:execute(note)
    --UnityEngine.Debug.Log('ResumeRecordCommand')
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    proxy:ResumeRecord()
end

return ResumeRecordCommand