--[[
  * COMMAND:: ShutdownAppCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ShutdownAppCommand = class('ShutdownAppCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function ShutdownAppCommand:ctor()
    self.executed = false
end

--coding function in here
function ShutdownAppCommand:execute(note)
    --UnityEngine.Debug.Log('ShutdownAppCommand')
    if GameHelper.isEditor == true then 
        GameHelper.StopEditorPlayer()
    else
        UnityEngine.Application.Quit() 
    end 
end

return ShutdownAppCommand